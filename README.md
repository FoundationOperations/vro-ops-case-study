# Vital Records Online (VRO) Ops engineering case study

This repository is a new public case study describing engineering lessons from
an internally used private operations control system. It is not a sanitized
copy of the application. Every sample, diagram, and decision record here was
written for public review with fictional data.

Published by Eric Diaz through Foundation Operations LLC.

## Scope

The case study explains how an operations control surface can consolidate an
estate overview, bounded feature modules, and operator workflows while keeping
authorization and deployment evidence explicit. It covers architecture and
verification patterns, not business procedures or production configuration.

## Eric's role

Eric was the product, engineering, and operations owner for the private system.
He defined requirements and architecture, implemented portions of the system,
reviewed changes, directed deployments, and remained accountable for operating
decisions and verification.

The private implementation was collaborative and AI-assisted, with multiple
human and automated contributors in its history. This repository does not claim
that Eric alone authored that implementation. The public narrative and samples
were newly drafted with AI assistance under Eric's direction and review.

## Operations-control problem

Operational information had accumulated across separate applications, tools,
and repositories. An operator could know that a service existed without having
a consistent view of its health, ownership boundary, current work, or next
action. Separate surfaces also encouraged duplicated authentication logic and
different interpretations of the same operational state.

The control-plane response was to create one place to discover modules and
coordinate work while leaving each external authority responsible for its own
records. The system is an operator aid, not a replacement for every underlying
service.

## Module boundaries

The consolidated repository uses explicit module boundaries: a registry-backed
overview, feature modules, service adapters, shared authorization helpers, and
deployment tooling. A module owns its presentation and domain behavior but uses
shared gates for identity, role, resource ownership, and write availability.

The [synthetic module registry](samples/module-registry.json) illustrates the
shape without copying private names, code, routes, or data. The
[architecture document](architecture.md) shows the same boundary visually and
in prose.

## Design-system governance

The private application separated a licensed upstream interface foundation
from project-owned presentation primitives and feature composition. Feature
code was expected to compose the approved project layer rather than reach into
the licensed layer or invent one-off presentation rules.

Automated repository checks enforced those layering and styling constraints
alongside lint, type, test, and build gates. The engineering value was the
governance contract, not redistribution of the interface kit. This public case
study contains no private component code, styling, tokens, markup, fonts,
icons, screenshots, or close visual reproduction.

## Independent authorization

A page-level check improves navigation but is not a security decision. Every
action and request handler must independently verify the signed-in identity,
the role required for the operation, and ownership of the requested resource.
A write also fails closed when its authoritative data service is unavailable.

The [fictional authorization scenarios](samples/authorization-scenarios.json)
make that rule reviewable. [ADR 002](decisions/002-independent-authorization.md)
records why presentation gates and action authorization remain separate.

## CI isolation

Private-source evidence showed a deliberate distinction between build checks
and production access. Verification jobs test that their environment cannot use
production data or credentials before running repository gates.

This public repository goes further by having no production integration at all.
Its [GitHub Actions workflow](.github/workflows/verify.yml) uses a GitHub-hosted
runner, read-only repository permission, one immutable action revision, no
secrets, and only the synthetic public verification command.

## Deployment verification

Merge, deployment, and live verification are separate states. A reviewed
revision can pass its gates without being the revision currently running. The
private engineering lesson is to record the reviewed revision, perform the
deployment as a deliberate step, then read back runtime identity and health
before making a live claim.

This public repository has no deployment. Its checks establish only that the
case-study artifacts are internally consistent and stay within the publication
boundary. See [ADR 003](decisions/003-release-verification.md).

## Tradeoff

Consolidation reduces duplicated contracts and gives operators one coherent
control surface. It also increases the consequence of weak module boundaries:
an unclear shared helper or broad gate can affect unrelated features. The
chosen tradeoff is a consolidated repository with explicit module ownership,
shared security primitives, and independent gates for distinct code families.
See [ADR 001](decisions/001-consolidated-control-plane.md).

## Failure and lesson

Architecture and deployment assumptions changed while older documentation
remained plausible. That made a stale description easy to mistake for current
reality. A second failure mode was treating a merged revision or green build as
evidence of what was live.

The lesson is to read the current source of truth before acting and to match
evidence to the claim: source review for design, tests for code behavior,
deployment identity for release state, and runtime read-back for live state.
Current controls improve this discipline; they do not describe every historical
change.

## Outcomes and limitations

No quantitative business outcome is published. There is no approved baseline,
measurement method, sample, or disclosure authority for a result claim about
this system. Repository history can support that engineering changes occurred,
but not customer impact, business value, performance, reliability, or adoption.

The case study therefore supports bounded architecture and verification claims
only. It does not prove private production behavior and does not disclose an
operational inventory.

## Vendor and collaborator boundaries

External providers own their services, interfaces, and behavior. Eric's scope
was the local integration boundary, product and engineering decisions, review,
deployment direction, and operational accountability. No vendor interface,
proprietary procedure, or upstream source is reproduced.

Private collaborators are acknowledged collectively because authority to name
individual contributions publicly was not established. Licensed interface
components and their styling, assets, markup, and screenshots are excluded.

## Private-source boundary

The production monorepo and history remain private. Customer and employee data,
credentials, hosts, routes, network topology, recovery procedures, deployment
configuration, private module names, migrations, source code, tests, interface
assets, and screenshots are excluded.

Only a clean, remote-verified default-branch snapshot was consulted for
high-level capability evidence. No private code or prose was copied or closely
paraphrased. The detailed review record is summarized in
[PROVENANCE.md](PROVENANCE.md).

## Maintenance status

This repository is maintained as a documentation-first portfolio artifact. It
has no runtime service, production access, release automation, or support
promise. Changes should clarify the public evidence boundary, preserve the
synthetic examples, and pass:

```bash
bash tests/verify.sh
```

Documentation and diagrams are licensed under
[CC BY 4.0](LICENSE-DOCS). Original samples and verification code are licensed
under the [MIT License](LICENSE). See [CONTRIBUTING.md](CONTRIBUTING.md),
[SECURITY.md](SECURITY.md), [SUPPORT.md](SUPPORT.md), and the
[screenshot policy](screenshots/README.md).
