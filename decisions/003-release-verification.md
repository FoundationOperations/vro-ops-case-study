# ADR 003: Separate review, deployment, and live evidence

## Context

A reviewed revision can pass repository checks without being deployed. A
deployment command can also complete without proving which revision is running
or whether a targeted workflow is healthy.

## Alternatives

- Treat merge as deployment evidence.
- Treat a successful deployment command as live verification.
- Record reviewed revision, deployed identity, and targeted runtime read-back as
  distinct evidence.

## Decision

Keep review, deployment, and live verification as separate states. Repository
gates support the reviewed revision. A deliberate deployment records the
candidate identity. Runtime identity and a bounded health or behavior read-back
support a live claim.

## Tradeoff

Release closeout has more checkpoints and cannot be inferred from source control
alone. In return, a failure can be located at review, transfer, startup, or
runtime behavior instead of being hidden behind one green status.

## Failure mode

Documentation can describe intended architecture after the runtime has changed.
A green build can be attached to one revision while a different revision is
running. A shallow health acknowledgement can also miss the workflow actually
being claimed.

## Verification

Compare the reviewed and deployed identities, then perform the narrowest
read-back that supports the claim. Record limitations and avoid promoting a
code-level check into production or business evidence.

## Current limitation

This public repository has no deployment and no production connectivity. Its
workflow verifies only the synthetic case-study artifacts.
