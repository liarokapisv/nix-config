# Bibliography & Referenced Documents

All documents referenced by (or orbiting) the wiki's Eye Messages page, with
access notes. ⚠ = not retrievable from this repo's CI/sandbox environment
(network policy); fetch from a normal machine.

## Primary

| Document | URL | Notes |
| --- | --- | --- |
| Noita Wiki — Eye Messages (incl. *CodeWarrior0's Novel Cipher* section) | <https://noita.wiki.gg/wiki/Eye_Messages> | Canonical, actively maintained ⚠ |
| Noita Wiki (Fandom mirror) — Eye Messages | <https://noita.fandom.com/wiki/Eye_Messages> | Older mirror, may lag ⚠ |
| CodeWarrior0 — *Noita Eye Glyphs: Analytical Overview* | <https://docs.google.com/document/d/1QeagH8TklJsd8iribMtT5LIRL91laOUU_tFcVl7OOqA/> | The core statistical analysis ⚠ |
| codewarrior0/noita-eye-glyph-analyses | <https://github.com/codewarrior0/noita-eye-glyph-analyses> | Companion source code to the Analytical Overview |
| *Noita Eye Glyphs — Progress* (PDF) | Course Hero copy: <https://www.coursehero.com/file/226068863/Noita-Eye-Glyphs-Progress-pdf/> | Progress write-up; paywalled mirror ⚠ |
| *Noita Eye Glyph Messages* (PDF) | Scribd: <https://www.scribd.com/document/911932819/Noita-Eye-Glyph-Messages> | Explainer document ⚠ |

## Community research repositories

| Repo | URL | Notes |
| --- | --- | --- |
| SirCapybar/NoitaEyeGlyphResearch | <https://github.com/SirCapybar/NoitaEyeGlyphResearch> | C++/data toolkit: trigram collections, IoC, frequency, Vigenère/Caesar experiments; mirror: Doctor-Ned/NoitaEyeGlyphResearch |
| ngraham20/NoitaCryptographyResearch | <https://github.com/ngraham20/NoitaCryptographyResearch> | "Research and analyze Eye and Cauldron"; trigram & cipher-order analysis |
| Unsolved Puzzles — The Eye Puzzle | <https://unsolved-puzzles.github.io/unsolved-puzzles/noita/eye-puzzle.html> | Independent summary page with data ⚠ |

## Community / discussion

| Resource | URL / Access | Notes |
| --- | --- | --- |
| Official Noita Discord — `silmä-huone` channel | via <https://discord.gg/noita> (ask a moderator, e.g. Slurpps or Harry, for channel access) | Live research hub; pinned messages index current docs |
| "Emerald Tablet Document" | Pinned in `silmä-huone` | Index of documents for Eyes / Cauldron / other mysteries |
| Steam discussion — "Eye Messages discovery(?)" | <https://steamcommunity.com/app/881100/discussions/0/4700161534027181070/> | Early community discussion ⚠ |
| Official release notes | <https://noitagame.com/release_notes/> | For dating builds that touched the eyes ⚠ |

## Named contributors (as credited on the wiki)

- **CodeWarrior0** — statistical analysis, state-space argument, novel-cipher
  conclusion, Analytical Overview + companion repo.
- **Lymm** — "Lymm's Patterns" (gap patterns), i.e. the isomorph discovery.
- **Pyry** — autokey-Alberti demonstration reproducing isomorph generation.
- **RmVw** — Vigenère key-length estimation argument.
- **kootahen** — community research/transcription efforts.
- **SirCapybar, ngraham20** — analysis toolkits/repositories.

## Retrieval note (this workspace)

This sandbox's network policy blocks direct fetches of the sources above
(only web-search summarization was available), and cross-owner GitHub adds
are disabled, so document contents were assembled from search-engine
extraction of the wiki and research pages on 2026-07-23. Run
`data/fetch-data.sh` on an unrestricted machine to pull the raw
transcriptions and (optionally) clone the research repos for local reference.
