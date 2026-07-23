# Encoding & Structure

> Sources: Noita wiki `Eye_Messages` page; SirCapybar/NoitaEyeGlyphResearch;
> unsolved-puzzles.github.io eye-puzzle page. See `06-bibliography.md`.

## Physical layout

- Each message is drawn as **rows of eye glyphs, up to 39 glyphs per row**,
  with **every second row offset** so adjacent rows mesh into a triangular
  lattice.
- The paired rows of a message **never differ in length by more than one
  glyph**.
- The **total glyph count of every message is divisible by 3** — the
  foundational hint that glyphs group into threes.

## The glyph alphabet

- Every eye glyph takes **one of 5 orientations** (pupil positions). A single
  glyph is therefore a **base-5 digit** (0–4).

## Trigrams

- Pairing up the rows and cutting the lattice into triangular groups of three
  adjacent glyphs yields **trigrams**. A trigram read as a 3-digit base-5
  number spans **000₅–444₅ = 0–124**.
- There are **36 plausible standard reading orders** (choices of glyph order
  within the triangle × traversal direction conventions). **Exactly one** of
  the 36 produces an **unbroken, gap-free range of values 0–82** across the
  whole corpus.
- That reading order is the **orthodox reading order**, accepted by the
  community precisely because a contiguous 0–82 range from 125 possibilities
  is overwhelmingly unlikely by chance — it strongly suggests the encoder
  enumerated an **83-symbol alphabet** and mapped it to consecutive trigram
  values.

## The effective ciphertext

After applying the orthodox reading order, the corpus is:

- **9 sequences** (messages `e1..e5`, `w1..w4`) of symbols drawn from an
  **83-symbol alphabet** (values 0–82).
- 83 is prime. Note 83 ≈ upper/lowercase Latin + digits + punctuation-sized
  alphabets; no confirmed symbol→character mapping exists.

## Why 83 matters

- All 83 values occur; the **frequency distribution is nearly flat** (see
  `03-statistical-findings.md`), so the trigram→plaintext map cannot be a
  simple substitution of a natural-language alphabet.
- The count 83 recurs in the state-space analysis: the cipher behaves as if
  it carries **at least ~83 internal states**, consistent with a deck/permutation
  cipher over the same alphabet (see `04-codewarrior0-novel-cipher.md`).

## Data conventions used in this workspace

`data/messages.txt` (produced by `data/fetch-data.sh`, format spec in
`data/README.md`) stores one message per line:

```
e1: 12 45 3 82 ...
```

with trigram values in the orthodox reading order. All tools in `tools/`
consume this format.
