# Support and maintenance

This repository is a maintained portfolio case study, not an application,
service, production runbook, or customer-support channel. Issues may report a
broken public check, inaccessible explanation, or inconsistency among these
synthetic artifacts.

Verification runs locally and in GitHub Actions:

```bash
bash tests/verify.sh
```

Hosted verification uses a GitHub-hosted runner with read-only repository
permission, an immutable checkout revision, no secrets, and no production
connectivity. It validates the public tree only and performs no deployment or
release automation.

The checks cannot prove private production behavior, business outcomes,
provider behavior, or historical state. Changes are reviewed against the
publication boundary and released without a promised cadence.
