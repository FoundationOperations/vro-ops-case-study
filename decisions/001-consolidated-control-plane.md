# ADR 001: Consolidate with explicit module ownership

## Context

An operations estate spread across separate surfaces makes discovery, shared
contracts, and current-state review inconsistent. Consolidation can improve
coherence, but it can also turn unrelated modules into one coupled system.

## Alternatives

- Keep each operational surface and repository independent.
- Merge every concern into one undifferentiated application layer.
- Use one control plane with a registry, bounded feature modules, shared
  security primitives, and explicit adapters.

## Decision

Use a consolidated control plane while preserving module ownership. The
registry supports discovery. A feature module owns its domain behavior. Shared
helpers define cross-cutting security and write boundaries. External systems
remain behind adapters and retain authority for their own records.

## Tradeoff

Shared contracts and one operator surface reduce drift, but a shared change can
have a wider blast radius. The repository therefore needs named boundaries,
separate test families, and review gates that match the affected module.

## Failure mode

A module can bypass a shared boundary or reach into another module's state,
making an apparently local change unsafe. A registry can also become decorative
if it is not treated as the discovery source of truth.

## Verification

Review module ownership and adapter contracts. Test shared gates independently
from feature presentation. Check that every registered module resolves to a
bounded public interface and that writes cannot use a read-only fallback.

## Current limitation

The public registry sample is illustrative. It cannot prove the private
repository's current module inventory, dependency graph, or runtime behavior.
