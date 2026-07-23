---
name: cryptanalysis
description: >
  General classical-cryptanalysis workflow: identify cipher class from
  ciphertext statistics, then apply the right attacks. Use for any
  substitution/transposition/polyalphabetic/state-machine cipher work —
  frequency analysis, IoC, Kasiski, isomorphs, autokey, hill-climbing.
---

# Classical cryptanalysis workflow

Work top-down: **measure → classify → attack → verify**. Never start with an
attack before the statistics justify the cipher class.

## 1. Measure (always first)

For alphabet size *m* and ciphertext length *n*:

- **Frequency distribution** + chi-square vs. uniform and vs. expected
  plaintext language. Flat ≈ 1/m → polyalphabetic/state-driven or
  transposition of uniform data; skewed → mono-substitution or transposition
  of natural text.
- **Index of coincidence**: natural-language-like → transposition or
  monoalphabetic; ≈ 1/m → polyalphabetic/stream.
- **Entropy** per symbol; **doubles** (adjacent repeats); **repeated-symbol
  gap spectrum** with per-gap z-scores (peaks reveal periods/rotors);
  **Kasiski** repeated n-gram distances (GCD structure → key length);
  **periodic IoC** (split into k cosets, IoC per coset peaks at true period).
- **Isomorph search** across multiple messages (matching gap patterns =
  shared plaintext under related keys/states).

For the Noita eyes corpus these are implemented in
`research/noita-eyes/tools/eyes_analysis.py`; reuse them for other ciphers by
changing `ALPHABET`.

## 2. Classify

| Signature | Class | Attacks |
| --- | --- | --- |
| Skewed freq matching language | monoalphabetic substitution | frequency matching, pattern words, hill-climb with n-gram fitness |
| Language-like IoC, wrong freq order | transposition | anagramming, columnar period search |
| Periodic IoC peaks | repeating-key polyalphabetic (Vigenère family) | Kasiski + per-coset frequency; Friedman |
| Flat, aperiodic, has doubles | running key / long keystream | crib dragging, keystream reuse tests |
| Flat, aperiodic, **no doubles** | machine/state cipher with non-identity transitions (rotor, deck) | isomorph mining, state-model fitting, known-plaintext |
| Gap-spectrum spike at g | period-g component (odometer/schedule) | model the g-cycle explicitly |

## 3. Attack

- Prefer **structure-exploiting** attacks (isomorphs, cribs, key reuse) over
  brute force; use hill-climbing/simulated annealing with n-gram fitness only
  once the class is pinned down.
- For state ciphers: hypothesize the update rule, simulate on skewed sample
  plaintext, and compare the full statistical signature — see
  `research/noita-eyes/tools/hypothesis_harness.py` for the harness pattern.
- Track and honour **known impossibilities** (e.g. non-commutative chaining
  conflicts rule out cyclic-group autokeys) before spending compute.

## 4. Verify

A solution requires: mechanism + key reproduce the ciphertext exactly;
the mechanism reproduces the corpus statistics on generic plaintext; a third
party can replay it end-to-end. Partial matches are leads, not solutions.

## Tooling

`nix develop .#noita-eyes` (python + numpy/scipy/sympy/pandas, `ent`,
`gnuplot`, `hexyl`) or one-offs via `nix shell nixpkgs#<pkg> -c <cmd>`.
