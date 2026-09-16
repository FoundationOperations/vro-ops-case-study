# ADR 002: Reauthorize every action

## Context

A page or layout can hide controls from an unauthenticated viewer, but that
presentation decision does not protect the underlying action or request
handler. Role and resource ownership can also differ between operations.

## Alternatives

- Rely on a page-level or navigation-level session check.
- Trust the client to submit only allowed actions.
- Independently check identity, required role, resource ownership, and write
  availability at every action boundary.

## Decision

Treat presentation checks as user experience only. Each action and request
handler revalidates identity and its required role, then verifies ownership of
the requested resource. A mutation also requires an authoritative write service
and fails closed when that service is unavailable.

## Tradeoff

The repeated boundary is more deliberate than relying on inherited page state.
It adds explicit checks to each operation, but it keeps a navigation refactor or
client request from silently changing authorization.

## Failure mode

An action that trusts a layout check can be invoked directly. A role check
without an ownership check can authorize access to another operator's resource.
A fallback data source can also be mistaken for a writable authority.

## Verification

Exercise allow and deny scenarios at the action boundary: missing identity,
insufficient role, mismatched owner, unavailable write service, and a fully
authorized request. Verify denial through the public action result, not through
whether a button was visible.

## Current limitation

The JSON scenarios in this repository model the rule but contain no private
handler, session, database, or customer record. They are not a security audit of
the production system.
