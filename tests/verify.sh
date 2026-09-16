#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

required_files=(
  README.md
  architecture.md
  PROVENANCE.md
  SECURITY.md
  CONTRIBUTING.md
  SUPPORT.md
  LICENSE
  LICENSE-DOCS
  decisions/001-consolidated-control-plane.md
  decisions/002-independent-authorization.md
  decisions/003-release-verification.md
  samples/module-registry.json
  samples/authorization-scenarios.json
  screenshots/README.md
  .github/workflows/verify.yml
)

for required_file in "${required_files[@]}"; do
  if [[ ! -s "$required_file" ]]; then
    printf 'FAIL: required file is missing or empty: %s\n' "$required_file" >&2
    exit 1
  fi
done

python3 - <<'PY'
import json
import re
from pathlib import Path

root = Path.cwd()
readme = (root / "README.md").read_text(encoding="utf-8")
required_sections = [
    "Scope",
    "Eric's role",
    "Operations-control problem",
    "Module boundaries",
    "Design-system governance",
    "Independent authorization",
    "CI isolation",
    "Deployment verification",
    "Tradeoff",
    "Failure and lesson",
    "Outcomes and limitations",
    "Vendor and collaborator boundaries",
    "Private-source boundary",
    "Maintenance status",
]
headings = re.findall(r"^## (.+)$", readme, flags=re.MULTILINE)
positions = []
for section in required_sections:
    if section not in headings:
        raise SystemExit(f"FAIL: README section missing: {section}")
    positions.append(headings.index(section))
if positions != sorted(positions) or len(set(positions)) != len(positions):
    raise SystemExit("FAIL: README sections are not in the required order")
if "Vital Records Online (VRO)" not in readme:
    raise SystemExit("FAIL: README must expand Vital Records Online on first mention")
if "No quantitative business outcome is published." not in readme:
    raise SystemExit("FAIL: README must state the outcome-evidence boundary")

registry = json.loads((root / "samples/module-registry.json").read_text(encoding="utf-8"))
if registry.get("fictional") is not True:
    raise SystemExit("FAIL: module registry must declare fictional=true")
if not registry.get("organization", {}).get("domain", "").endswith(".example"):
    raise SystemExit("FAIL: module registry must use a reserved .example domain")
modules = registry.get("modules", [])
if not modules or any(not {"name", "purpose", "authority"} <= set(item) for item in modules):
    raise SystemExit("FAIL: module registry entries are incomplete")

policy = json.loads((root / "samples/authorization-scenarios.json").read_text(encoding="utf-8"))
if policy.get("fictional") is not True:
    raise SystemExit("FAIL: authorization scenarios must declare fictional=true")
if not policy.get("tenant_domain", "").endswith(".example"):
    raise SystemExit("FAIL: authorization scenarios must use a reserved .example domain")
scenarios = policy.get("scenarios", [])
if not scenarios:
    raise SystemExit("FAIL: authorization scenarios are missing")
for scenario in scenarios:
    expected = (
        scenario.get("authenticated") is True
        and scenario.get("role_allows_action") is True
        and scenario.get("owns_resource") is True
    )
    if scenario.get("expected") != ("allow" if expected else "deny"):
        raise SystemExit(f"FAIL: authorization result is inconsistent: {scenario.get('name')}")

link_pattern = re.compile(r"\[[^\]]+\]\(([^)]+)\)")
for markdown_file in root.rglob("*.md"):
    for target in link_pattern.findall(markdown_file.read_text(encoding="utf-8")):
        if target.startswith(("https://", "http://", "mailto:", "#")):
            continue
        target_path = target.split("#", 1)[0]
        if target_path and not (markdown_file.parent / target_path).resolve().exists():
            raise SystemExit(f"FAIL: broken local link in {markdown_file}: {target}")
PY

for adr in decisions/*.md; do
  for heading in Context Alternatives Decision Tradeoff "Failure mode" Verification "Current limitation"; do
    rg -q "^## ${heading}$" "$adr" || {
      printf 'FAIL: %s lacks required heading: %s\n' "$adr" "$heading" >&2
      exit 1
    }
  done
done

rg -q '^```mermaid$' architecture.md || {
  printf 'FAIL: architecture.md lacks a Mermaid diagram\n' >&2
  exit 1
}
rg -q '^## Text equivalent$' architecture.md || {
  printf 'FAIL: architecture.md lacks equivalent prose\n' >&2
  exit 1
}
rg -q '922d61d7cc70d938c662f5cecb25b0d097fa7ad4' PROVENANCE.md || {
  printf 'FAIL: provenance lacks the verified source revision\n' >&2
  exit 1
}
rg -q 'CC BY 4\.0' README.md LICENSE-DOCS || {
  printf 'FAIL: documentation license is missing\n' >&2
  exit 1
}
rg -q 'MIT' README.md LICENSE || {
  printf 'FAIL: sample and verification license is missing\n' >&2
  exit 1
}

workflow=.github/workflows/verify.yml
if ! rg -q '^permissions:$' "$workflow" || ! rg -q '^  contents: read$' "$workflow"; then
  printf 'FAIL: workflow permissions are not read-only\n' >&2
  exit 1
fi
rg -q 'runs-on: ubuntu-latest' "$workflow" || {
  printf 'FAIL: workflow is not GitHub-hosted\n' >&2
  exit 1
}
rg -q 'actions/checkout@d23441a48e516b6c34aea4fa41551a30e30af803' "$workflow" || {
  printf 'FAIL: checkout action is not pinned to the approved immutable revision\n' >&2
  exit 1
}
rg -q '^[[:space:]]*persist-credentials: false$' "$workflow" || {
  printf 'FAIL: checkout credentials are persisted\n' >&2
  exit 1
}
if rg -n -i 'self-hosted|pull_request_target|secrets\.|permissions:[[:space:]]*write|contents:[[:space:]]*write' "$workflow"; then
  printf 'FAIL: workflow exceeds the public CI boundary\n' >&2
  exit 1
fi

if rg -n \
  '(^|[^0-9])([0-9]{1,3}[.]){3}[0-9]{1,3}([^0-9]|$)' \
  --glob '!tests/verify.sh' .; then
  printf 'FAIL: network address found\n' >&2
  exit 1
fi

if rg -n '(^|[[:space:]`(])/[A-Za-z][A-Za-z0-9._/-]*' \
  --glob '*.md' --glob '!tests/verify.sh' .; then
  printf 'FAIL: route-like absolute path found\n' >&2
  exit 1
fi

python3 - <<'PY'
import re
from pathlib import Path

root = Path.cwd()
allowed_domains = {"creativecommons.org"}
domain_pattern = re.compile(
    r"(?<![@\w.-])([a-z0-9](?:[a-z0-9.-]*[a-z0-9])?\.(?:app|com|dev|io|net|org))(?![\w.-])",
    flags=re.IGNORECASE,
)
for path in root.rglob("*"):
    if not path.is_file() or ".git" in path.parts or path == root / "tests/verify.sh":
        continue
    text = path.read_text(encoding="utf-8")
    for domain in domain_pattern.findall(text):
        if domain.lower() not in allowed_domains:
            raise SystemExit(f"FAIL: non-example public domain found in {path}: {domain}")
PY

if rg -n \
  'sk_live_|ghp_[A-Za-z0-9]+|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----' \
  --glob '!tests/verify.sh' .; then
  printf 'FAIL: credential-shaped content found\n' >&2
  exit 1
fi

if rg -n -i \
  '[0-9]+([.][0-9]+)?[[:space:]]*(seconds?|minutes?|hours?|days?|weeks?|months?|years?|%|percent)|\$[0-9]|time saved|reduced by|faster by|success rate|uptime' \
  --glob '*.md' --glob '!LICENSE*' .; then
  printf 'FAIL: quantitative outcome wording found\n' >&2
  exit 1
fi

email_matches=$(rg -o -N -i '[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}' \
  --glob '!LICENSE*' --glob '!tests/verify.sh' . || true)
if [[ -n "$email_matches" ]] && printf '%s\n' "$email_matches" | rg -v -i '@[A-Z0-9.-]+[.]example$'; then
  printf 'FAIL: non-example email address found\n' >&2
  exit 1
fi

if find . -path ./.git -prune -o -type l -print | grep -q .; then
  printf 'FAIL: symbolic links are not allowed in the public case study\n' >&2
  exit 1
fi

unexpected_files=$(find . -path ./.git -prune -o -type f -print | \
  rg -v '^\./(README[.]md|architecture[.]md|PROVENANCE[.]md|SECURITY[.]md|CONTRIBUTING[.]md|SUPPORT[.]md|LICENSE|LICENSE-DOCS|decisions/[0-9]{3}-[a-z0-9-]+[.]md|samples/(module-registry|authorization-scenarios)[.]json|screenshots/README[.]md|tests/verify[.]sh|[.]github/workflows/verify[.]yml|[.]gitignore)$' || true)
if [[ -n "$unexpected_files" ]]; then
  printf 'FAIL: unexpected file(s):\n%s\n' "$unexpected_files" >&2
  exit 1
fi

printf 'PASS: structure, samples, links, licenses, exclusions, and public CI policy passed.\n'
