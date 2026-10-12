# Learning frontmatter schema

The frontmatter contract for every learning under `docs/solutions/`. Field meanings, category mapping, and YAML safety live here. `assets/learning.schema.json` is the machine-checkable version of the same rules — keep the two in step. Section order lives in `assets/resolution-template.md`.

## Corpus-first vocabulary

`component` and `root_cause` are open vocabulary, and the category directories are a default layout, not a fixed one. A repo that already holds learnings has its own values and directory names, and its retrieval (agent instructions, greps, tooling) is keyed on them. A doc written to this file's defaults instead of the repo's vocabulary is a doc the repo cannot find.

So before classifying, when `docs/solutions/` already has docs, sample their frontmatter (`component`, `root_cause`, `problem_type`, `tags`) and directory names:

- **`component`** — match by area: use the value existing docs use for this area.
- **`root_cause`** — match by the cause itself, not the area: use the value existing docs use for this same underlying cause, wherever they live. An area's usual root cause does not carry over to a doc whose verified cause differs.
- **Several spellings** for the same area or cause — use the one most docs use (tie: the most recently dated doc). Reuse corpus values as spelled; never coin a near-synonym.
- **Suggested defaults** below apply only when no existing doc covers the area (`component`) or names the cause (`root_cause`). A new fallback value is lowercase, underscore-separated.
- **Directory** — file the doc in the existing directory that covers this area. Use the category mapping only when none does.

`problem_type`, `severity`, and `resolution_type` stay closed enums. `problem_type` picks the track.

## Tracks

| Track | `problem_type` values | Covers |
| --- | --- | --- |
| **Bug** | `build_error`, `test_failure`, `runtime_error`, `performance_issue`, `database_issue`, `security_issue`, `ui_bug`, `integration_issue`, `logic_error` | Defects and failures that were diagnosed and fixed |
| **Knowledge** | `best_practice`, `documentation_gap`, `workflow_issue`, `developer_experience`, `architecture_pattern`, `design_pattern`, `tooling_decision`, `convention` | Practices, patterns, conventions, decisions, workflow improvements. Prefer the narrowest value; `best_practice` is fallback. |

## Required fields (both tracks)

- **`title`** — clear problem or guidance title.
- **`date`** — `YYYY-MM-DD`, the creation date. Never put a date in the filename.
- **`category`** — the `docs/solutions/` subdirectory the doc lives in.
- **`module`** — module or area affected.
- **`problem_type`** — one value from the tracks table.
- **`component`** — open vocabulary. Suggested defaults: `data_model`, `api_layer`, `service_layer`, `background_job`, `database`, `frontend`, `messaging`, `infrastructure`, `observability`, `authentication`, `payments`, `development_workflow`, `testing_framework`, `documentation`, `tooling`.
- **`severity`** — `critical`, `high`, `medium`, or `low`.

## Bug track — also required

- **`symptoms`** — array, 1–5 observable symptoms (errors, broken behavior).
- **`root_cause`** — open vocabulary. Suggested defaults: `wrong_api`, `data_integrity`, `concurrency`, `async_timing`, `memory_leak`, `config_error`, `logic_error`, `test_isolation`, `missing_validation`, `missing_permission`, `missing_workflow_step`, `inadequate_documentation`, `missing_tooling`, `incomplete_setup`.
- **`resolution_type`** — `code_fix`, `migration`, `config_change`, `test_fix`, `dependency_update`, `environment_setup`, `workflow_improvement`, `documentation_update`, `tooling_addition`, or `seed_data_update`.

Optional on bug track only: **`framework_version`** — runtime and version the bug was seen on, such as `node 22.4.0`.

## Knowledge track — all optional

- **`applies_when`** — array, up to 5 conditions where the guidance applies.
- **`symptoms`** — array, up to 5 gaps or friction that prompted it.
- **`root_cause`** — when there is a specific one.
- **`resolution_type`** — when it applies.

Bug-track fields found on an existing knowledge-track doc are harmless. Do not strip them unless the doc is being rewritten for other reasons.

## Optional fields (both tracks)

- **`related_components`** — array of other components involved.
- **`tags`** — array, up to 8 search keywords, lowercase and hyphen-separated.
- **`last_updated`** — `YYYY-MM-DD`, added when an existing doc is updated in place.
- **`retire_when`** — the change outside the repo that would retire this learning, and how a refresh can check for it without changing the repo. Example: `"acme/sdk#1234 closed as fixed in a released sdk version; check the issue and the sdk release notes"`. Set it only when the guidance holds just while something outside the repo holds (an open upstream bug, a tool or platform version, a dependency's behavior). A check that needs a repo change, such as removing a workaround and rerunning CI, belongs in the body. One string.

Refresh-only fields: `status: stale`, `stale_reason`, `stale_date` (stale-marking), and optionally `supersedes` on a replacement doc.

## Category mapping

Default layout for a store with no established directories. When `docs/solutions/` already has a taxonomy, use the existing directory that covers the area instead of creating one nothing else uses.

| `problem_type`         | Directory                               |
| ---------------------- | --------------------------------------- |
| `build_error`          | `docs/solutions/build-errors/`          |
| `test_failure`         | `docs/solutions/test-failures/`         |
| `runtime_error`        | `docs/solutions/runtime-errors/`        |
| `performance_issue`    | `docs/solutions/performance-issues/`    |
| `database_issue`       | `docs/solutions/database-issues/`       |
| `security_issue`       | `docs/solutions/security-issues/`       |
| `ui_bug`               | `docs/solutions/ui-bugs/`               |
| `integration_issue`    | `docs/solutions/integration-issues/`    |
| `logic_error`          | `docs/solutions/logic-errors/`          |
| `developer_experience` | `docs/solutions/developer-experience/`  |
| `workflow_issue`       | `docs/solutions/workflow-issues/`       |
| `best_practice`        | `docs/solutions/best-practices/`        |
| `documentation_gap`    | `docs/solutions/documentation-gaps/`    |
| `architecture_pattern` | `docs/solutions/architecture-patterns/` |
| `design_pattern`       | `docs/solutions/design-patterns/`       |
| `tooling_decision`     | `docs/solutions/tooling-decisions/`     |
| `convention`           | `docs/solutions/conventions/`           |

## Validation rules

1. Determine the track from `problem_type`.
2. All shared required fields are present; bug-track docs also carry `symptoms`, `root_cause`, `resolution_type`.
3. Enum fields match the allowed values exactly.
4. Open-vocabulary fields follow the corpus-first rule.
5. Arrays respect their item counts.
6. `date` and `last_updated` match `YYYY-MM-DD`.
7. `framework_version` appears only on bug-track docs.

## YAML safety

Strict YAML parsers reject array items that start with a reserved indicator. Wrap any array-of-strings item (`symptoms`, `applies_when`, `tags`, `related_components`) in double quotes when it starts with any of `` ` `` `[` `*` `&` `!` `|` `>` `%` `@` `?`, or contains a colon followed by a space.

```yaml
# Breaks strict YAML
symptoms:
  - `npm ci` hangs on the postinstall step

# Parses cleanly
symptoms:
  - "`npm ci` hangs on the postinstall step"
```

For top-level scalar values, quote the whole value when it contains a space followed by `#` (YAML silently truncates it as a comment) or a colon followed by a space (read as a nested mapping).
