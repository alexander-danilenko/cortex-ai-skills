# CONCEPTS.md vocabulary rules

`CONCEPTS.md` at the repo root is the project glossary: the words that mean something specific in this codebase. Learnings in `docs/solutions/` and the agent instruction files cite it instead of redefining terms. The file is created the first time a run produces a qualifying entry.

## Supported mutations

A run may **add** an entry, **refine** one, **fold** one into the entry that already carries its meaning, **retire** one to `## Retired`, **delete** one, or **scrub** violations from one it touched. Each skill states which subset it may perform.

**Update-only** names what a run withholds — no creation, no seeding. It never widens the subset the run already has.

## How terms enter

- **Accretion** — a learning brings up a term whose meaning was not obvious, so it gets defined. This catches _peripheral_ terms, because friction is what brings them up.
- **Seeding** — a run defines the **core domain nouns** of the area it works in. This catches the _stable-central_ terms accretion never reaches: the nouns a system is built around rarely break, so they rarely appear in a learning, yet a reader needs them to orient. Without seeding, the file fills with peripheral mechanics and never names what the project is about.

### Seed goal

Define the core nouns the area's **declared domain model** exposes (schema, core types, primary models, top-level domain docs — not a full-codebase trawl) that meet the bar in "What earns a slot". The codebase sets the count: seed every term that qualifies, none added to reach a number.

### Scope of a seed

- A **scoped run** (a learning capture, or a refresh narrowed to an area) seeds only that area's core nouns, and only terms it investigated against code.
- A **repo-wide bootstrap** (an explicit "create CONCEPTS.md" request) seeds the whole project's declared domain model. Only this path produces a coherent "what is this project" glossary.

## Be opinionated

When the team uses several words for one concept, pick the best one and drop the rest. A dropped synonym is not a retirement: it becomes an aliases line on the surviving entry and never goes to `## Retired`. Settled distinctions go to the Flagged ambiguities tail. The glossary is the team's agreed vocabulary, not every word ever used.

## The file stands on its own

Each entry teaches its concept to a reader with no codebase, PR history, meetings, or chat. That rules out:

- Implementation specifics — file paths, class names, function signatures, table names, library calls.
- Status fields, dates, and owners on entries.
- Current-config values that will change. State the behavior, not the number: "each service sets its own retry limit", not "retries 3 times".
- Links to PRs, issues, channels, or roadmap milestones.
- Version-specific claims ("currently uses X; migrating to Y").

Cross-references between entries are fine. General programming vocabulary (cache, queue, job, session) and everyday English need no entry. But when an entry leans on another _project-specific_ term, that term needs an entry too.

## What earns a slot — and what keeps one

A term qualifies on two counts: its meaning here is precise enough that a new engineer would need it defined to follow conversations, tickets, or code; and it is a concept in its own right, not a property of one already defined. Both counts apply when admitting a term and when deciding whether an entry keeps its heading.

An entry that loses its heading still has to resolve for whoever meets the term in an old ticket, learning, or commit. Find the surviving entry that can carry it — the neighbor whose property it always was, or the concept that replaced it — and **fold** it there: move the meaning, repoint cross-references, and name the old term on that entry so a reader can tell whether it meant this entry or was replaced by it. When nothing can carry it, **retire** it to `## Retired` if readers will still meet it in the project's own material, else delete it.

Remove an entry only on positive contrary evidence; uncertainty leaves it standing. Name where the concept went. A deleted class, path, or symbol is never that evidence — an entry is meant to outlive the code that implemented it — and neither is a lack of corroboration.

## Coherence neighborhood

An entry's neighborhood is its cluster siblings plus the terms it cross-references or that reference it. It bounds a capture-time pass: act only on evidence already in hand, never audit the whole file, and flag for `learn-with-docs-refresh` anything that would need investigation this run did not do.

## Per entry

The definition is one sentence: what the term means here and what sets it apart from neighbors. A term with non-obvious behavioral rules (lifecycle, cancellation, ownership) earns a second paragraph for those rules only. List dropped synonyms as an aliases line directly under the definition: _Avoid: Booking, appointment_.

## File layout

- **Preamble** under the `# Concepts` heading, when the file is created:

  > Shared domain vocabulary for this project — entities, named processes, and status concepts with project-specific meaning. Seeded with core domain vocabulary, then grows as learnings are captured and refreshed; direct edits are fine. Glossary only, not a spec or catch-all.

- **Clusters** — group concepts by domain relationship (entities with their states, processes with their stages). One to four terms can stay flat. Reshape as the file grows.
- **`## Relationships`** (optional) — near the top of the file or cluster, only when ownership, cardinality, or cross-entry lifecycle carries meaning a reader needs.
- **`## Flagged ambiguities`** (tail) — one line per settled distinction: _"'account' had been used for both Customer and User — these are distinct."_
- **`## Retired`** (tail, only when it has entries) — one line per concept the project no longer has and nothing replaced: what it meant and what removed it.

## Illustrative entry — the shape, not a template

```markdown
## Booking

### Reservation

A future commitment to seat a Party at a specified date and time. _Avoid:_ Booking, appointment

A Reservation owns its Party but not a Table — Tables are acquired only when the Party arrives, through a Seating. Lifecycle: Booked, Seated, Completed, No-Show. Cancellation before a Seating is non-destructive; after a Seating it is recorded as a No-Show.

### Party

The guests committed to a Reservation. Party size is the count promised at booking, not the count who arrive.

### Seating

The act of placing a Party at a Table once it arrives. A Reservation has at most one Seating.
```
