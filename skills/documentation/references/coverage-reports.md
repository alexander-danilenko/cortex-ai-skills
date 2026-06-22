# Documentation Health Reports

A documentation report measures **health, not headcount**. A file where every member carries a doc block is not the goal — many of those blocks just restate the signature and will rot. Report what actually improved the docs: redundancy removed, stale or contradicted comments corrected, and the genuinely missing pieces (intent summaries, `@throws`) added. A bare coverage percentage is a weak floor signal, not the score.

## Documentation Health Report Template

```markdown
# Documentation Report: {project_name}

## Health Actions

- **Redundant comments removed**: 38 (signature restatements, noise, commented-out code)
- **Stale / contradicted docs corrected**: 12 (text no longer matched behaviour)
- **Intent summaries added**: 27 public members that had none
- **`@throws` added**: 19 functions whose throw set was undocumented
- **`@param`/`@returns` added**: 9 (only where they carry units, ranges, defaults, or edge-value/`null` semantics the signature can't)

## Coverage (floor signal only)

- Public members with a summary: 146/150 — the 4 gaps are listed below
- Functions that can throw and document it: 19/19

## Files Modified

| File                     | Health change                             |
| ------------------------ | ----------------------------------------- |
| src/services/user.ts     | +8 summaries, −5 restated `@param` blocks |
| src/services/auth.ts     | +5 `@throws`, 2 stale summaries corrected |
| src/controllers/users.ts | +6 endpoint summaries, −3 noise comments  |
| src/dto/user.dto.ts      | 4 fields reframed WHAT-not-WHY            |

## API Documentation

- **Framework**: NestJS
- **Strategy**: @nestjs/swagger decorators
- **Swagger UI**: /api/docs
- **OpenAPI spec**: /api-json

## Documentation Style

- **Python**: Google style docstrings
- **TypeScript**: TSDoc (Microsoft contract-first conventions)
- **API**: OpenAPI 3.1 via decorators

## Remaining Gaps

| File                | Gap                                  | Priority |
| ------------------- | ------------------------------------ | -------- |
| src/utils/crypto.ts | 3 functions throw, none document it  | High     |
| src/helpers/date.ts | 2 public helpers lack intent summary | Medium   |

## Next Steps

1. Run the docstring linter (see below) to catch restated or malformed tags
2. Audit, don't pad — gaps above are about missing _intent_ and `@throws`, not headcount
3. Add tested examples only where they earn their keep
```

## Health Audit Checklist

A coverage tool tells you what is _missing_; this checklist is how you tell what is _wrong_. Run it over both new and existing docs — existing comments rot, so auditing them matters as much as filling gaps.

```markdown
## Documentation Health Checklist

### Before Starting

- [ ] Confirmed format preference (Google/TSDoc/etc.)
- [ ] Identified files to exclude (tests, generated)
- [ ] Detected framework for API docs

### Remove / Correct (existing docs)

- [ ] Deleted comments that only restate the signature
- [ ] Deleted commented-out code, changelog/journal notes, and attribution bylines
- [ ] Corrected summaries that no longer match the code's behaviour
- [ ] Reframed data-shape docs from WHY to WHAT (meaning, units, format, constraints)

### Add (genuine gaps)

- [ ] Every public function/class has a one-line intent summary
- [ ] `@throws` documented wherever code can throw
- [ ] `@param`/`@returns` present only where they add units, ranges, defaults, or edge-value/`null` semantics — never a name+type echo

### API Endpoints

- [ ] Endpoints have intent summaries (not paraphrased route names)
- [ ] Request/response schemas defined; error responses documented
- [ ] Authentication requirements noted

### Final Checks

- [ ] Ran the docstring linter
- [ ] Verified Swagger UI renders correctly
- [ ] Tested every code example shipped (an untested example is a comment that lies)
```

## Linting and Coverage Tooling

Coverage tools (`interrogate`, `docstr-coverage`) find members with _no_ docstring — a useful floor. They cannot tell a redundant block from a valuable one, so treat a high score as "nothing is empty," not "the docs are good."

```bash
# JavaScript/TypeScript - ESLint (catches malformed/empty/restated tags)
npm install eslint-plugin-jsdoc --save-dev
# Add to .eslintrc: "plugins": ["jsdoc"]

# Python - pydocstyle (style/format conformance)
pip install pydocstyle
pydocstyle --convention=google src/

# Python - interrogate (presence-only coverage; a floor signal)
pip install interrogate
interrogate -v src/
```

## Health Signals

Judge the report by these, not by a coverage percentage.

| Signal | Healthy | Needs work |
| --- | --- | --- |
| Restated-signature comments | None remain | Present (delete them) |
| Stale / contradicted docs | None found, or all corrected | Comments disagree with the code |
| Functions that throw | All document `@throws` | Throw set undocumented |
| Public members with intent summary | All | Gaps that mislead generated docs |
| Code examples | All tested | Untested examples shipped |
