# Specification Template

Section order for `specs/{project_name}_reverse_spec.md`. Drop a section only when the system genuinely has nothing under it — an empty heading is a useful signal, a missing one looks like an oversight.

```markdown
# Reverse-Engineered Specification: [System/Feature Name]

## Overview

What the system does, in a paragraph, and the boundary of this analysis — what was read and what was not.

## Architecture Summary

**Stack:** language, framework, database, ORM, and versions as found in the manifest.

**Modules:** directory tree annotated with each module's responsibility.

**Request path:** the actual flow, e.g. `Request → Guard → Controller → Service → Repository → DB`, noting where external calls happen.

## Observed Functional Requirements

Grouped by module. EARS sentences with an ID and evidence:

**OBS-AUTH-001** — Login While credentials are valid, when `POST /auth/login` is called, the system shall return a JWT access token (15m) and a refresh token (7d). _Evidence: src/auth/auth.controller.ts:31_

## Observed Non-Functional Requirements

Concrete values read from the code, not aspirations — token algorithm and lifetime, hash cost factor, rate limits, pool sizes, timeouts, pagination defaults and caps.

### Error Responses

| Code | Condition          | Body                                 |
| ---- | ------------------ | ------------------------------------ |
| 400  | Validation failure | `{ error: string, details: object }` |
| 401  | Invalid token      | `{ error: "Unauthorized" }`          |

## Inferred Acceptance Criteria

Given/When/Then, derived from the observations above. Mark these clearly as inference — they are what the behaviour implies, not what anyone specified.

## Uncertainties and Questions

Open questions for a maintainer. What triggers each state transition; whether deletes are soft; which external systems own which fields; what runs on a schedule.

## Recommendations

Gaps and risks noticed while reading — missing validation, undocumented endpoints, absent tracing. Separate from the specification itself so a reader can take the spec without taking the opinions.
```
