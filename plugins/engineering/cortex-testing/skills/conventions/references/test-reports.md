# Test Reports

Report every finding, including low-severity and uncertain ones, with a severity and a confidence attached. Ranking is the reader's job; dropping items at the point of discovery makes "nothing found" indistinguishable from "found and filtered".

## Severity

| Severity     | Criteria                                        |
| ------------ | ----------------------------------------------- |
| **CRITICAL** | Security vulnerability, data loss, system crash |
| **HIGH**     | Major functionality broken, severe performance  |
| **MEDIUM**   | Feature partially working, workaround exists    |
| **LOW**      | Minor issue, cosmetic, edge case                |

## Template

```markdown
# Test Report: {Feature}

**Date** YYYY-MM-DD · **Version** {version} · **Scope** unit / integration / e2e / perf / security

## Summary

| Total | Passed | Failed | Skipped | Coverage |
| ----- | ------ | ------ | ------- | -------- |
| X     | X      | X      | X       | X%       |

## Findings

### [CRITICAL] {Title}

- **Location** src/api/users.ts:45
- **Reproduce** POST /api/users with no auth header
- **Expected** 401 · **Actual** 201
- **Impact** Any anonymous caller can create users
- **Fix** Apply the auth guard to the route

### [HIGH] {Title}

- **Location** src/services/orders.ts:123
- **Detail** N+1 query on order list; 3s response at 100 orders
- **Fix** Eager-load order items

## Coverage gaps

Name the untested paths, not the percentages — `src/services/payment.ts:45-60` (error handling), `src/api/admin.ts` (no tests).

## Performance

| Endpoint   | p50  | p95   | p99   |
| ---------- | ---- | ----- | ----- |
| GET /users | 45ms | 120ms | 250ms |

## Recommendations

Ordered by severity, each naming the finding it resolves.
```
