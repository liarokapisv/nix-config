# Statistical Findings

Every property below is an established community result about the trigram
ciphertext (orthodox reading order, 83-symbol alphabet). Together they form
the **signature** any candidate cipher must reproduce —
`tools/hypothesis_harness.py` automates that check.

> Attribution: most results are due to CodeWarrior0 ("Noita Eye Glyphs:
> Analytical Overview" + companion repo), with contributions from Lymm, Pyry,
> RmVw and others in the Discord `silmä-huone` community. See
> `06-bibliography.md`.

## F1 — Flat frequency distribution

The frequency of the 83 symbols is **approximately uniform**, across each
message and the corpus. This is *not* compatible with monoalphabetic
substitution of natural-language text (which preserves letter-frequency
skew). Frequency analysis on trigrams was tried early and produced no
workable result.

**Implication:** the cipher is **polyalphabetic or state-driven** — each
ciphertext symbol depends on more than the single underlying plaintext
character.

## F2 — No periodicity

Standard period analysis (Kasiski-style examination) finds **no usable
period**. The ciphertext is **not periodic**, ruling out fixed-length
repeating-key schemes at face value.

RmVw's result: key-length estimation produces an **almost linear
distribution of estimated key length vs. plaintext alphabet length** —
behaviour inconsistent with a Vigenère-family cipher.

## F3 — Position-dependent alphabets

Positional analysis across messages shows that letters at the **same position
in different messages are likely enciphered by different alphabets**. So the
keystream is not simply a function of position (not a shared running key
applied identically to each message from its start — but see F6's shared
openings caveat).

## F4 — No doubles

**No ciphertext symbol ever appears twice in a row, in any message.** With a
flat distribution, adjacent repeats should occur regularly by chance; their
total absence is structural.

**Implication:** the enciphering transformation's state **never maps two
consecutive (possibly equal) plaintext letters through an identity
transition**. In a deck-cipher model this is automatic: every enciphered
letter perturbs the deck, so the "current alphabet" always changes.

## F5 — The gap-4 anomaly (period-4 structural cycle)

Identical symbols recur at a **gap of exactly 4 at nearly double the expected
rate** (z = 4.04, p < 0.001). No other gap shows such an excess.

**Implication:** some component of the cipher **cycles with period 4** —
e.g. a rotor advancing every 4 characters, a 4-track interleave, or a
4-step key schedule — superimposed on the aperiodic mechanism of F2.

## F6 — Isomorphs / shared segments (Lymm's "gap patterns")

Segments of different messages are **isomorphs** of each other: their
internal patterns of repeated-symbol gaps match exactly. Notably, **six
segments (conservatively four plus two) of the first three messages are
isomorphs of one another**, and messages with **different first characters can
still share identical subsequent sections**.

Identical sequences appearing at the same positions across messages imply
**shared plaintext enciphered under the same key/mechanism**, with the state
re-synchronising after divergent starts.

Pyry demonstrated that an **autokey Alberti cipher** (rings rotating by an
amount depending on the previous plaintext character) reproduces
isomorph-generation on English plaintext — proof that this class of
behaviour arises naturally from autokey mechanisms.

**However** (crucial refinement): **alphabet-chaining across the isomorphs
produces conflicts that are impossible in any cyclic-group cipher**. All
classical **ciphertext-autokey (CTAK)** mechanisms over a cyclic group —
Alberti included — are therefore **ruled out**. The transformation group must
be **non-commutative** (e.g. the symmetric group S₈₃ acting by general
permutations, as in a deck cipher).

## F7 — Internal state count

From ciphertext-dependency counting: the cipher has **no fewer than 20
distinct internal states**, statistically **at least ~88**, most plausibly
**exactly 83** visible states (matching the alphabet size) — with the *hidden*
state space far larger, plausibly **S₈₃ / on the order of 82!** (see
`04-codewarrior0-novel-cipher.md`).

## Summary table

| # | Property | Strength | Kills |
|---|----------|----------|-------|
| F1 | Flat symbol frequencies | strong | monoalphabetic substitution |
| F2 | No period; linear key-length estimates | strong | Vigenère family, repeating keys |
| F3 | Different alphabets at same positions | strong | pure positional keystream reuse |
| F4 | No adjacent repeats | absolute (structural) | any cipher with identity state-transitions |
| F5 | Gap-4 excess, z=4.04 | strong | any model with no period-4 component |
| F6 | Isomorph conflicts under chaining | strong | all cyclic-group CTAK (incl. Alberti) |
| F7 | ≥20, ~≥88, likely 83 internal states | statistical | small-state machines |
