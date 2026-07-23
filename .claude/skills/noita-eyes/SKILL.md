---
name: noita-eyes
description: >
  Orient a session on the Noita Eye Messages research workspace: the unsolved
  83-symbol eye-glyph cryptogram. Use when the user mentions the Noita eyes,
  eye messages, eye glyphs, trigrams, or asks to continue the decipherment
  research.
---

# Noita Eye Messages workspace

Everything lives under `research/noita-eyes/`. Orientation order:

1. `README.md` — layout and quick start
2. `docs/01-overview.md` — what the puzzle is (9 messages, parallel worlds,
   devs confirmed real content, unsolved)
3. `docs/02-encoding-and-structure.md` — base-5 eye glyphs → trigrams →
   83-symbol alphabet via the orthodox reading order
4. `docs/03-statistical-findings.md` — findings **F1–F7**; this is the
   ciphertext's signature and the hard constraint set
5. `docs/04-codewarrior0-novel-cipher.md` — leading model: novel deck cipher
   over S₈₃ with generalized autokey and a period-4 component
6. `docs/05-ruled-out-and-hypotheses.md` — dead ends + solution checklist
   **C1–C7** + prioritized attack queue
7. `docs/06-bibliography.md` — every referenced external document

## Working rules

- **Data**: `data/messages.txt` (gitignored; produced by `data/fetch-data.sh`
  on a machine with normal network). Validate before use:
  `python research/noita-eyes/tools/eyes_analysis.py --data research/noita-eyes/data/messages.txt validate`.
  If it's missing, do analytical/simulation work — never invent corpus values.
- **Tools**: `tools/eyes_analysis.py` (statistics: report/gaps/isomorphs/
  selftest) and `tools/hypothesis_harness.py` (score candidate ciphers
  against C2–C6). Extend these rather than scattering scripts.
- **Dev shell**: `nix develop .#noita-eyes` provides python with
  numpy/scipy/sympy/pandas/matplotlib plus ent, gnuplot, hexyl, imagemagick.
- **Delegate**: use the `noita-crypto-analyst` agent for statistical /
  hypothesis-evaluation work and `noita-cipher-implementer` for coding and
  scoring concrete cipher candidates.
- Any claimed progress must cite which F-findings it relies on and which
  C-checklist items it advances; claims that skip the checklist are noise.
