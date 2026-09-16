# Provenance and exclusion record

## Source boundary

The only private evidence source for this public case study was the clean,
remote-verified default-branch snapshot:

`vro-ops@922d61d7cc70d938c662f5cecb25b0d097fa7ad4`

Before drafting, the source checkout, its local remote-tracking revision, and a
read-only remote query all resolved to that identity. The source checkout was
clean. It was never modified for this work.

Review was limited to high-level evidence about the control-plane purpose,
module boundaries, independent action authorization, design governance, CI
isolation, and the distinction between merge, deployment, and live read-back.
The detailed private review paths and approval are recorded outside this public
repository.

## Original public creation

The README, architecture prose, Mermaid diagram, decision records, JSON samples,
policies, verification script, and GitHub Actions workflow were written from a
blank page for this repository. AI assisted the drafting under Eric Diaz's
direction and review. No private code, prose, test, schema, migration, fixture,
interface, asset, screenshot, or Git history was copied or closely paraphrased.

## Roles and attribution

Eric was the product, engineering, and operations owner for the private system
and is accountable for factual review and publication of this case study. The
private history includes multiple human and automated contributors. This public
edition does not claim sole authorship of the private implementation and does
not name collaborators whose public attribution authority was not established.

External providers own their platforms and behavior. The public architecture
uses generic capability labels and includes no vendor procedure or source.

## Exclusions

The public tree excludes:

- customer, employee, and collaborator data or private identities;
- secrets, account identifiers, credential handling, and recovery procedures;
- production hosts, routes, network addresses, topology, and configuration;
- private module names, business procedures, source code, tests, and data
  shapes;
- licensed interface code, styling, assets, icons, fonts, and screenshots;
- vendor interfaces, proprietary workflows, and copied documentation; and
- timing, volume, reliability, financial, customer-impact, or other
  quantitative business outcomes.

## Licensing boundary

Documentation and diagrams are newly authored and licensed under CC BY 4.0.
Original files under `samples/`, `tests/`, and `.github/workflows/` are licensed
under MIT. The licenses do not apply to the private source, vendor services, or
excluded third-party material.
