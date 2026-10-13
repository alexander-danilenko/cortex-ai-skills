# Testing Anti-Patterns

**Test what the code does, not what the mocks do.** Tests that verify mock behaviour give full confidence and catch zero bugs — which is worse than having no tests, because no-tests is at least honest about the risk.

## The five

**1. Testing the mock.** The only assertion is `expect(mockApi).toHaveBeenCalledWith(1)`. That verifies the call you just wrote, not the result. Assert on what the unit returns or persists; if the only observable thing is that a call happened, ask whether the test is worth keeping.

**2. Test-only methods in production.** `_resetForTesting()`, `_setStateForTest()`. Test concerns ship to users and become API someone eventually calls for real. Construct a fresh instance per test instead.

**3. Mocking without understanding.** Every dependency stubbed, so `expect(result.success).toBe(true)` passes without exercising anything. Run against real implementations first to learn the actual behaviour, then mock only at the process boundary — network, clock, filesystem — and keep your own units real.

**4. Incomplete mocks.** A stub returning `{ id, name }` when the real API returns fifteen fields passes the test and crashes production on `user.email`. Mirror the real response shape, and use factories so defaults stay complete as the shape grows.

**5. Tests as an afterthought.** "We'll add tests later" means the code was designed without testability as a constraint, so retrofitting tests means restructuring it. The feature and its tests ship together or the feature isn't done.

## Detection

Scan tests for these — each maps to one of the above.

| Warning sign | Anti-pattern |
| --- | --- |
| `expect(mock).toHaveBeenCalled()` as the sole assertion | Testing the mock |
| `_reset`, `ForTesting`, `__test` in production code | Test-only methods |
| Every dependency mocked | Mocking without understanding |
| Stubs returning `{ success: true }` and little else | Incomplete mocks |
| Test files added weeks after the feature | Afterthought |

---

_Adapted from [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent (@obra), MIT License._
