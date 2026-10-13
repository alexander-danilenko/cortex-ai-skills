# The 53 writing rules

Paraphrase of the ASD-STE100 Issue 9 writing rules, with software examples. The official wording, and the dictionary of approved words that Section 1 depends on, are in the free standard at asd-ste100.org.

Cite a number from this file or do not cite one. The sections are grouped by grammar topic rather than by importance, so the numbering rarely matches a guess.

| Section | Rules | Topic |
| --- | --- | --- |
| [1](#1--words) | 1.1–1.14 | Approved words and technical terms |
| [2](#2--noun-clusters) | 2.1–2.2 | Chains of nouns |
| [3](#3--verbs) | 3.1–3.7 | Tense, voice, and modals |
| [4](#4--sentences) | 4.1–4.5 | Sentence construction |
| [5](#5--procedures) | 5.1–5.5 | Instructions |
| [6](#6--descriptive-writing) | 6.1–6.6 | Explanations |
| [7](#7--safety-instructions) | 7.1–7.3 | Warnings and cautions |
| [8](#8--punctuation-and-word-count) | 8.1–8.7 | Marks, and what counts as one word |
| [9](#9--writing-practices) | 9.1–9.4 | Applying the standard |
| [GR](#general-recommendations) | GR-1–GR-8 | Recommendations, not hard rules |

## 1 — Words

| Rule | Statement |
| --- | --- |
| 1.1 | Use a word only if the dictionary approves it, or if it is a technical noun or verb. |
| 1.2 | Use an approved word only as the part of speech the dictionary lists for it. |
| 1.3 | Use an approved word only with the meaning the dictionary gives it. |
| 1.4 | Inflect verbs and adjectives only into the forms the dictionary permits. |
| 1.5 | Nouns from your own field count as technical nouns — `sidecar`, `changeset`, `queue`. |
| 1.6 | A word outside the dictionary earns its place only by being a technical noun, or part of one. |
| 1.7 | A technical noun stays a noun. Not "webhook the event". |
| 1.8 | Use the established technical nouns of your project or industry. |
| 1.9 | A technical noun you invent has to be short and impossible to misread. |
| 1.10 | Keep slang, regional words, and in-house jargon out of technical nouns. |
| 1.11 | One item, one name, for the whole document. |
| 1.12 | Verbs from your own field count as technical verbs — `rebase`, `provision`, `serialize`. |
| 1.13 | A technical verb stays a verb. Not "do a deploy". |
| 1.14 | Use American English spelling. |

In practical depth, 1.5, 1.8, and 1.12 keep your vocabulary legal. The rules that get broken are 1.7, 1.11, and 1.13.

Known part-of-speech rulings, useful as patterns even without the dictionary:

| Word | Ruling |
| --- | --- |
| test, check, work | Nouns only. "Do a test", not "test the service". "Check that X" becomes "make sure that X". |
| help | Verb only. Where you want the noun, the dictionary supplies "aid". |
| fall | Downward motion under gravity, nothing else. Never a synonym for "decrease". |
| follow | To come after. Never "obey" — write "obey the instructions". |
| above, below | Physical position only. For limits write "more than" and "less than". |

## 2 — Noun clusters

| Rule | Statement |
| --- | --- |
| 2.1 | Keep a multi-word noun to three words or fewer. |
| 2.2 | If a technical noun needs more words, write it in full once, then define a short form or hyphenate the parts. |

Break a longer chain with a preposition — of, in, on, for.

- **Before:** the request retry backoff interval setting
- **After:** the backoff interval for request retries

## 3 — Verbs

| Rule | Statement |
| --- | --- |
| 3.1 | Use only the verb forms the dictionary lists. |
| 3.2 | Six forms are open to you: the infinitive, the imperative, the three simple tenses, and a past participle acting as an adjective. |
| 3.3 | A past participle may modify a noun and nothing else — "the cached response". |
| 3.4 | No auxiliary constructions. No present perfect, no "is to be restarted". |
| 3.5 | Use an `-ing` form only as a noun or inside one — never as a verb, never as a trailing clause. |
| 3.6 | Write in the active voice. Passive is allowed in descriptive text only when the actor is unknown. |
| 3.7 | Express an action with a verb, not with a noun made from one. |

Approved modals are can, will, and must. `should`, `would`, `may`, `might`, and `could` are rejected: a possibility is "can occur", a requirement is "must", and a recommendation is either stated as a fact or deleted.

## 4 — Sentences

| Rule | Statement |
| --- | --- |
| 4.1 | Keep sentences short and direct. |
| 4.2 | Do not shorten by dropping words or using contractions. Keep articles and `that`. |
| 4.3 | Put complex material in a vertical list. |
| 4.4 | Connect related sentences with a linking word — "Then", "As a result". |
| 4.5 | Put an article or a demonstrative in front of a noun where one applies. |

Rule 4.2 is the reason STE is not telegraph style. Short sentence, complete grammar.

## 5 — Procedures

| Rule | Statement |
| --- | --- |
| 5.1 | No sentence passes 20 words. This covers warnings and cautions too. |
| 5.2 | Carry one instruction per sentence. Two are allowed when both actions occur together. |
| 5.3 | Give every instruction as a command to the reader. |
| 5.4 | Put a required condition before the command, separated by a comma. |
| 5.5 | A note gives information only, never an instruction, and takes the 25-word limit. |

## 6 — Descriptive writing

| Rule | Statement                                                       |
| ---- | --------------------------------------------------------------- |
| 6.1  | Add information in small steps, a single fact at a time.        |
| 6.2  | Repeat anchor words and phrases so the shape of the text shows. |
| 6.3  | 25 words maximum per sentence.                                  |
| 6.4  | Group related information into paragraphs.                      |
| 6.5  | One topic per paragraph.                                        |
| 6.6  | Six sentences maximum per paragraph.                            |

No imperative in descriptive text. A description explains. A procedure instructs.

## 7 — Safety instructions

| Rule | Statement |
| --- | --- |
| 7.1 | Signal the level of risk — WARNING for injury, CAUTION for damage or loss. |
| 7.2 | Start with the command or the condition. |
| 7.3 | Give the risk or the result after it. |

The pattern transfers to destructive flags, irreversible migrations, and dangerous API options. The instruction never comes after its explanation.

## 8 — Punctuation and word count

| Rule | Statement |
| --- | --- |
| 8.1 | Every standard mark is permitted except the semicolon. Write two sentences. |
| 8.2 | Hyphenate words that act as a single unit. |
| 8.3 | Parentheses are permitted for references, item numbers, abbreviations, plurals, alternatives, and short explanations. |
| 8.4 | A colon that introduces a vertical list ends the sentence for counting. |
| 8.5 | Everything inside one pair of parentheses counts as a single word. |
| 8.6 | Count as one word: a number, a number with its unit, an abbreviation, an alphanumeric identifier, quoted text, a title, a label, a proper noun. |
| 8.7 | Anything joined by a hyphen counts once. |

Rule 8.6 is what makes the limits workable in software text. `terraform apply -var-file=prod.tfvars` in backticks is one word.

## 9 — Writing practices

| Rule | Statement |
| --- | --- |
| 9.1 | When a word-for-word replacement fails, rebuild the sentence. |
| 9.2 | Use each approved word with its approved meaning and part of speech. |
| 9.3 | Leave phrasal verbs unbuilt — "set up" resolves to "install" or "configure". |
| 9.4 | Hold one style and one terminology across the whole document. |

## General recommendations

| Rule | Statement |
| --- | --- |
| GR-1 | Keep the conjunction `that`. It marks the clause boundary for the reader. |
| GR-2 | Be careful with "with" — it hides the relation between the two things it joins. |
| GR-3 | Give every pronoun an unmistakable referent. |
| GR-4 | Prefer "this setting" over a bare "this". |
| GR-5 | Avoid words that look like a word in the reader's own language but mean something else. |
| GR-6 | Avoid Latin abbreviations. "e.g." becomes "for example", "i.e." becomes "that is", and "etc." is deleted in favor of naming the items. |
| GR-7 | Use inclusive language. |
| GR-8 | Use the possessive apostrophe only when you are certain it is correct. Non-native readers find it hard, so restructure if in doubt. |
