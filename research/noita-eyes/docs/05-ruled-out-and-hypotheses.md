# Ruled Out, Surviving Hypotheses, and the Solution Checklist

## Ruled out (with reasons)

| Cipher / family | Why it's out |
| --- | --- |
| Simple / monoalphabetic substitution | Flat trigram frequencies (F1); frequency analysis produced nothing workable |
| Vigenère & repeating-key polyalphabetics | No period (F2); RmVw's key-length estimation behaves linearly in alphabet size — inconsistent with Vigenère |
| Polybius square (raw 5-digit reading) | Attractive since glyphs are base-5, but some messages have an **odd number of characters**, incompatible with fixed digit-pair decoding |
| Playfair | Some messages have an **odd number of digrams** — Playfair requires even digram structure |
| Classical ciphertext-autokey (CTAK) over cyclic groups, incl. Alberti | Alphabet chaining across isomorphs produces conflicts impossible in cyclic-group ciphers (F6) — despite Pyry's Alberti-autokey demo reproducing isomorph *generation* |
| Any cipher with identity state transitions | Absolute "no doubles" property (F4) |
| Any small finite-state machine (<~20 states) | State-count lower bounds (F7) |
| Game-mechanic "key" theories (a trigger/decoder in the engine) | Full Ghidra decompilation found no code that reads the eyes |

## Surviving hypotheses

1. **Novel deck cipher over S₈₃ with generalized autokey** — the leading
   model (see `04-codewarrior0-novel-cipher.md`): permutation state, per-step
   plaintext/ciphertext-dependent shuffle containing a period-4 component.
2. **Rotor-like non-commutative machine** — an Enigma-*like* (but
   non-catalogued) construction over 83 symbols with an odometer that has a
   4-cycle component; overlaps heavily with (1) in observable signature.
3. **Plaintext-autokey variants over S₈₃** — PTAK isn't excluded by the F6
   argument the way cyclic CTAK is, provided transformations are general
   permutations.
4. **Steganographic key material** — the deck's initial order / symbol table
   hidden in game assets (music, art, world-gen constants, the Cauldron).
   Weakly explored compared to pure cryptanalysis.

## What the plaintext is (payload hypotheses)

Distinct from *how* it's enciphered is *what* is encoded. Community
discussion (Discord `silmä-huone`, 2026) frames it as:

- **Natural language** (leading view). The isomorphs (F6) are the strong
  evidence: long segments with identical repeated-symbol gap patterns
  recurring **across different messages and at different positions** are the
  statistical fingerprint of **repeated words/phrases** — exactly what
  language produces and what high-entropy payloads (coordinates, telemetry)
  essentially never produce. The enumerated 83-symbol alphabet (contiguous
  0–82, ~the size of a letters+digits+punctuation character set) points the
  same way.
- **Non-language data as plaintext** (camera directions, map chunk
  positions, etc.). Not strictly excluded by ciphertext statistics alone,
  but it must still sit *behind* the cipher: it doesn't escape any of F1–F7,
  and it fails to explain the cross-message shared segments unless the data
  itself repeats phrase-like — at which point the hypothesis collapses into
  "structured text" anyway.
- **Direct translation** (glyph orientations *are* movement/camera
  directions, no cipher). Ruled out: raw directional telemetry would show
  strong autocorrelation, repeats (doubles), and skewed frequencies — the
  corpus shows flat frequencies (F1), zero doubles (F4), and a deliberate
  36→1 reading-order/alphabet enumeration (see docs/02). The messages are
  enciphered, not raw data.
- **Compatible middle ground**: the decrypted *language* may well instruct
  an in-game action (the "hint for another interaction mechanism" idea).
  Note the Ghidra result only rules out the *engine reading the eyes*; it
  does not rule out the plaintext directing the *player* to do something
  elsewhere. This keeps steganographic/asset searches (hypothesis 4)
  relevant even under the language-payload view.

## The finish line: constraint checklist

A proposed solution (mechanism + key + plaintexts) is credible only if:

- [ ] **C1** Encrypting the claimed plaintexts with the claimed mechanism/key
      reproduces **all 9 messages exactly**.
- [ ] **C2** The mechanism reproduces the flat frequency signature (F1) on
      generic plaintext, not just the claimed one.
- [ ] **C3** It emits **no doubles** structurally (F4).
- [ ] **C4** It shows the **gap-4 excess** at a comparable rate (F5).
- [ ] **C5** It naturally generates the observed **isomorph segments** from
      shared plaintext (F6), including shared sections after differing
      openings.
- [ ] **C6** Its transformation group is **non-commutative** (F6 chaining
      conflicts are representable).
- [ ] **C7** The claimed plaintexts are coherent messages (the devs confirmed
      real content), and the method is **reproducible end-to-end by a third
      party**.

`tools/hypothesis_harness.py` implements C2–C6 as automated statistical
comparisons between simulated ciphertext and the real corpus signature.

## Practical attack queue (prioritized)

1. Mine the **isomorph alignments** for constraints on the per-step
   permutation update (the only place related states are directly observable).
2. Enumerate **hand-executable shuffle rules with a period-4 component**
   (cut-every-4, move-card-every-4, 4-phase schedules); simulate; score
   against F1–F7.
3. Fit **hidden-state models** (HMM / deck simulations) to the corpus and
   compare likelihoods across update-rule families.
4. Sweep **game assets** for 83-length permutations / tables (initial deck or
   symbol map).
5. Re-verify the orthodox reading order assumptions periodically — all
   downstream work inherits them.
