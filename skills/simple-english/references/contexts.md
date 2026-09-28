# Applying the rules outside documentation

The standard was written for aircraft maintenance manuals, and most registered users now sit outside aerospace. The properties travel: one meaning per word, one instruction per sentence, and the condition in front of the command hold anywhere that a misread costs something.

Each context below gives the classification and what changes.

## Error messages and CLI output

Procedural. The highest-value target in this list — an error message is an instruction delivered to someone at 2 a.m. who did not ask for it.

Say what failed in the simple past, give the cause if you know it, then give the fix as an imperative. No apology, no "Oops", no "please".

- **Before:** Oops! Something went wrong while trying to connect. Please ensure your credentials are configured correctly and try again.
- **After:** Connection to `redis-prod` failed. The password for user `worker` was rejected. Set `REDIS_PASSWORD` and start the worker again.

If you do not know the cause, say nothing about it. A guessed cause sends the reader down the wrong path.

## Runbooks and standard operating procedures

Procedural, at strict depth. Nothing in software sits closer to the original use: a page at 03:00 turns a runbook into exactly the document the standard was built for.

Every step is imperative and carries one instruction. Conditions come first. Warnings come before the step they guard, not after. Hold the 20-word limit without exception — the reader is under stress and reads each line once.

## Incident reports and postmortems

Descriptive, simple past only. A timeline written in the present perfect hides when things happened, which is the one thing a postmortem exists to record.

- **Before:** Our team has been investigating reports that a subset of customers may have experienced degraded upload performance.
- **After:** Between 09:14 and 09:47 UTC, 23% of uploads returned HTTP 503. A deploy at 09:12 removed the retry on the storage client.

Removing the hedges pays off here. State the facts you hold and mark the rest "unknown". Readers trust that more, and they are right to.

## Commit messages and pull request descriptions

Imperative subject, descriptive body. Convention already agrees with the standard, so only the body needs work: 25-word limit, plain past facts, and no "this PR aims to". Say what the change does.

## Release notes and changelogs

Descriptive. Give each change its own entry, and keep the entry to a single sentence when the change permits. Anything breaking takes the warning shape: command first, consequence second.

- **After:** Update your calls to `POST /v2/users`. The `name` field is now `first_name` and `last_name`.

## Instructions for AI agents

Procedural. A system prompt, an `AGENTS.md`, or a skill is a procedure carried out by a reader who cannot ask a follow-up question. That is the reader the standard was designed for, which is why the fit is so close.

- A sentence that carries one instruction can be quoted on its own, and it leaves no half of itself to skip.
- A frozen vocabulary stops the model from treating `check`, `verify`, and `validate` as three separate operations.
- A condition at the front survives. A trailing condition gets dropped.
- No `should`. A model reads it as optional, so write `must` or delete the line.

## Support replies and status page updates

Descriptive, 25-word limit. Most products serve more readers outside the English-speaking world than inside it, and a short update reaches all of them faster. Drop the apology and give the facts.

- **After:** The API was unavailable for 18 minutes. Uploads sent during this time were saved. They will process today.

## User interface copy and empty states

Procedural, under limits far tighter than 20 words. Buttons and labels count as technical names and stay exempt. The surrounding text obeys the rules: "This workspace has no pipelines. Add one to begin." Nothing longer survives the space anyway.

## Translation and localization

Strict. The standard exists because maintenance crews read English as a foreign language, and the same discipline prepares text for a translation engine. Fixed word meanings, together with the full grammar that Rule 4.2 keeps, strip out the ambiguity a translator would otherwise resolve by guessing. If the documentation gets localized, this cuts both the error rate and the bill.

## Where it does not fit

Marketing pages, launch announcements, blog voice, brand writing. The rules delete persuasion deliberately. Write those in your own voice, then apply the standard to the documentation they link to.
