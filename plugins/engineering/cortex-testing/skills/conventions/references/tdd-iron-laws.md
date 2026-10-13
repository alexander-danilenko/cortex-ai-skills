# TDD Iron Laws

## The rule

**No production code without a failing test first.** If you wrote the code first, delete it and start over.

The reason this is absolute rather than a preference: a test written after the code is shaped by the code. You already know how it works, so you test the path you built instead of the behaviour you needed — and you never find out whether the test can fail at all.

## Three laws

1. **Production code exists only to make a failing test pass.** Every line traces back to a test that was written first and observed failing.
2. **If you did not watch it fail, you do not know what it tests.** Run the test, see red, and read the failure message — a test that has never failed proves nothing, and a test that passes against an empty implementation is testing nothing.
3. **No prior failing test means it is not TDD**, however many tests exist afterwards.

## Red → Green → Refactor

- **Red** — one minimal failing test. Smallest scope, clear failure message, observed failing.
- **Green** — the simplest code that passes it. No extra features, no optimisation. Under-implementing here is deliberate: the next test is what forces the general solution, and if it doesn't, the general solution wasn't needed.
- **Refactor** — improve the code with the tests staying green. No new behaviour.

## Rationalizations to reject

Each of these is the moment the discipline is about to break.

| Thought | Why it's wrong |
| --- | --- |
| "I can test this manually, faster" | Manual testing doesn't prevent the regression next month |
| "I'll add tests after, to save time" | After-the-fact tests follow the code and skip its edges |
| "Too simple to need a test" | Simple code changes; the test is what documents the intent |
| "I already wrote it, I can't delete it now" | Sunk cost. Delete it — you'll rewrite it in minutes |
| "I know this works, I've done it before" | Your memory isn't executable |
| "We're in a hurry" | Debugging untested code is what you're in a hurry from |

## For a bug fix

Write the test that reproduces the bug and watch it fail. That failure is proof you've actually found the bug rather than a plausible-looking neighbour — and once it passes, the same test is the regression guard.

---

_Adapted from [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent (@obra), MIT License._
