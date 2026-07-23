# CodeWarrior0's Novel Cipher

This documents the wiki section
[`Eye_Messages#CodeWarrior0's_Novel_Cipher`](https://noita.wiki.gg/wiki/Eye_Messages#CodeWarrior0's_Novel_Cipher)
and the underlying research:

- **"Noita Eye Glyphs: Analytical Overview"** — Google Doc:
  <https://docs.google.com/document/d/1QeagH8TklJsd8iribMtT5LIRL91laOUU_tFcVl7OOqA/>
- Companion source code: <https://github.com/codewarrior0/noita-eye-glyph-analyses>
- A related progress write-up circulates as *"Noita Eye Glyphs — Progress"*
  (PDF copies exist on Course Hero / Scribd; see `06-bibliography.md`).

## Framing

The analysis assumes the messages are **ciphertext from an unknown
classical-style cipher** (pen-and-paper era mechanics rather than modern
cryptographic primitives), and asks: *what class of machine could emit
ciphertext with exactly the observed statistics?*

## The evidence chain

1. **Flat frequency, not monoalphabetic** (F1) — some form of polyalphabetic
   or state-machine encipherment.
2. **Not periodic** (F2) — not a repeating-key polyalphabetic.
3. **Positional analysis** (F3) — same positions in different messages use
   different alphabets, so the keystream is not a fixed function of position.
4. **No doubles** (F4) — the state transition is never the identity; the
   "current alphabet" changes on every character.
5. **Gap-4 excess** (F5) — something in the machine cycles every 4 steps.
6. **Isomorphs with chaining conflicts** (F6) — the per-step alphabet
   transformations cannot all live in a cyclic group; the group must be
   non-commutative.
7. **State counting** (F7) — ≥20 observable internal states, statistically
   ~≥88, best-fit **83** = alphabet size; hidden state far larger.

## The model: a deck cipher over S₈₃ ("GAK with S83")

The synthesis that satisfies all seven constraints is a **deck cipher** — the
family that includes Schneier's Solitaire/Pontifex: the key/state is a
permutation (a "deck") of the 83 symbols, the top of the deck (or an
equivalent pointer) selects the ciphertext symbol, and **each enciphered
character shuffles the deck** by a plaintext-and/or-ciphertext-dependent
permutation (a **generalized autokey**, "GAK").

Why it fits:

- **Hidden state**: with the top card visible, the hidden state is the order
  of the **82 unseen cards → 82! possible hidden states**. This explains the
  key observation that **messages with different first characters can still
  share identical subsequent sections** — different visible prefixes can
  converge to the same internal deck order (or two decks can transiently
  agree on the cards that surface).
- **No doubles for free** (F4): every step shuffles, so the emitted symbol
  source always moves.
- **Non-commutative** (F6): deck shuffles are general permutations in S₈₃,
  not rotations in ℤ/83 — exactly the non-cyclic structure the isomorph
  chaining conflicts demand.
- **State count** (F7): the *observable* state (which symbol surfaces) has 83
  values, matching the best-fit estimate.
- **Gap-4** (F5): a hand-designed shuffle schedule naturally admits a
  4-cycle component (e.g. a move performed every 4th step) — a strong hint
  about the shuffle's concrete structure, and the most exploitable known
  regularity.

## Why "novel"

No catalogued classical cipher matches this signature; the conclusion is that
the developers (Nolla Games) **invented their own cipher** — hence the wiki
section title. The cipher is *novel but classical in spirit*: 83 symbols,
permutation state, hand-executable steps.

## Consequences for attack strategy

- Attacks on textbook ciphers (Vigenère, Playfair, Enigma catalogues,
  Solitaire-as-published) are expected to fail and have failed.
- Productive directions:
  1. **Reconstruct the shuffle**: hypothesize concrete deck-update rules
     honouring the period-4 component; simulate; compare full statistical
     signatures (`tools/hypothesis_harness.py`).
  2. **Exploit isomorphs**: shared-plaintext segments give aligned
     ciphertext pairs under related states — the strongest known leverage
     for recovering the update rule's structure.
  3. **Search the game's assets/code** for the deck's initial order or the
     symbol→character table (nothing found so far via Ghidra decompilation,
     but asset-level steganography is less exhaustively excluded).
- Any candidate mechanism **must reproduce F1–F7 simultaneously**; matching a
  subset is the historical failure mode of proposed solutions.
