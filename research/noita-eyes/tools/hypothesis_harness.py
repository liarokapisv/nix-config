#!/usr/bin/env python3
"""Candidate-cipher test harness for the Noita eye messages.

Implements the constraint checklist C2–C6 from docs/05: a candidate cipher
is simulated on sample plaintexts and its ciphertext's statistical signature
is compared against the established findings F1–F7 (and, when the real
corpus is available, against its measured signature).

Usage:
    python hypothesis_harness.py --demo            # run built-in examples
    python hypothesis_harness.py --data ../data/messages.txt --demo

Writing your own candidate: subclass Cipher and implement encrypt();
register it in CANDIDATES. Keep the alphabet at 83 symbols.
"""

from __future__ import annotations

import argparse
import math
import random
from collections import Counter

from eyes_analysis import (
    ALPHABET,
    Corpus,
    chi2_flatness,
    corpus_gap_spectrum,
    find_isomorphs,
    index_of_coincidence,
    load_corpus,
)


class Cipher:
    """A keyed, stateful cipher over the 0..82 alphabet."""

    name = "abstract"

    def encrypt(self, plaintext: list[int], rng: random.Random) -> list[int]:
        raise NotImplementedError


class VigenereLike(Cipher):
    """Repeating-key addition mod 83 — a known-bad baseline that must FAIL."""

    name = "vigenere-mod83 (should fail)"

    def __init__(self, key_len: int = 7):
        self.key_len = key_len

    def encrypt(self, plaintext, rng):
        key = [rng.randrange(ALPHABET) for _ in range(self.key_len)]
        return [(p + key[i % self.key_len]) % ALPHABET for i, p in enumerate(plaintext)]


class DeckGAK(Cipher):
    """Toy deck cipher over S83 with a generalized-autokey shuffle and a
    period-4 component — the *shape* of CodeWarrior0's model (docs/04).

    Illustrative, not a solution claim: as-is it passes C2/C3/C5/C6 but its
    naive every-4th-step transposition does NOT reproduce the gap-4 excess
    (C4). Finding a hand-executable shuffle that also passes C4 is exactly
    the open problem described in docs/05.
    """

    name = "deck-GAK-S83 (model shape)"

    def encrypt(self, plaintext, rng):
        deck = list(range(ALPHABET))
        rng.shuffle(deck)
        out: list[int] = []
        for i, p in enumerate(plaintext):
            c = deck[p]
            if out and c == out[-1]:
                # state transition must never be the identity w.r.t. emission:
                # nudge the deck once more so no double is ever emitted (F4)
                deck = deck[1:] + deck[:1]
                c = deck[p]
            out.append(c)
            # plaintext/ciphertext-dependent cut: never the identity
            cut = (p + c) % (ALPHABET - 1) + 1
            deck = deck[cut:] + deck[:cut]
            # period-4 component: an extra fixed transposition every 4th step
            if i % 4 == 3:
                deck[0], deck[41] = deck[41], deck[0]
        return out


def sample_plaintexts(rng: random.Random, n_msgs: int = 9) -> list[list[int]]:
    """English-like plaintexts mapped onto 0..82 with skewed frequencies and
    a shared segment inserted into three of the messages (to probe C5)."""
    weights = [math.exp(-0.06 * s) for s in range(ALPHABET)]
    shared = rng.choices(range(ALPHABET), weights=weights, k=30)
    msgs = []
    for m in range(n_msgs):
        n = rng.randint(90, 160)
        msg = rng.choices(range(ALPHABET), weights=weights, k=n)
        if m < 3:
            msg[10:10] = shared
        msgs.append(msg)
    return msgs


def signature(msgs: dict[str, list[int]]) -> dict:
    corpus = Corpus(msgs)
    total = corpus.all_symbols
    gaps = corpus_gap_spectrum(corpus, 8)
    doubles = sum(
        1 for m in msgs.values() for i in range(1, len(m)) if m[i] == m[i - 1]
    )
    chi2, dof = chi2_flatness(total)
    return {
        "ioc": index_of_coincidence(total),
        "chi2_per_dof": chi2 / dof,
        "doubles": doubles,
        "gap4_z": gaps.get(4, (0, 0, 0.0))[2],
        "other_gap_z_max": max(
            (abs(z) for g, (_, _, z) in gaps.items() if g != 4 and g > 1),
            default=0.0,
        ),
        "isomorphs": len(find_isomorphs(corpus, min_len=8)),
        "distinct": len(set(total)),
    }


def evaluate(cipher: Cipher, seed: int = 1, real: Corpus | None = None) -> None:
    rng = random.Random(seed)
    pts = sample_plaintexts(rng)
    cts = {f"m{i}": cipher.encrypt(pt, rng) for i, pt in enumerate(pts)}
    sig = signature(cts)

    checks = {
        # C2: flat frequencies despite skewed plaintext
        "C2 flat freq (chi2/dof ≈ 1, IoC ≈ 1/83)": sig["chi2_per_dof"] < 1.5
        and abs(sig["ioc"] - 1 / ALPHABET) < 0.004,
        # C3: structurally no doubles
        "C3 no doubles": sig["doubles"] == 0,
        # C4: gap-4 excess present and specific to 4
        "C4 gap-4 excess (z>3, others quiet)": sig["gap4_z"] > 3
        and sig["other_gap_z_max"] < 3,
        # C5: shared plaintext yields detectable isomorphs
        "C5 isomorphs from shared plaintext": sig["isomorphs"] > 0,
        # C6 proxy: alphabet fully used (permutation-style mixing)
        "C6 full alphabet usage": sig["distinct"] == ALPHABET,
    }

    print(f"\n=== {cipher.name}")
    print(
        f"    IoC={sig['ioc']:.5f}  chi2/dof={sig['chi2_per_dof']:.2f}  "
        f"doubles={sig['doubles']}  gap4_z={sig['gap4_z']:+.2f}  "
        f"isomorphs={sig['isomorphs']}"
    )
    for label, ok in checks.items():
        print(f"    [{'PASS' if ok else 'FAIL'}] {label}")
    if real is not None:
        rsig = signature(real.messages)
        print(
            f"    real corpus reference: IoC={rsig['ioc']:.5f} "
            f"chi2/dof={rsig['chi2_per_dof']:.2f} doubles={rsig['doubles']} "
            f"gap4_z={rsig['gap4_z']:+.2f} isomorphs={rsig['isomorphs']}"
        )


CANDIDATES: list[Cipher] = [VigenereLike(), DeckGAK()]


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--data", help="real corpus for side-by-side signature")
    ap.add_argument("--demo", action="store_true", help="evaluate built-in candidates")
    ap.add_argument("--seed", type=int, default=1)
    args = ap.parse_args()

    real = load_corpus(args.data) if args.data else None
    if args.demo or not args.data:
        for cipher in CANDIDATES:
            evaluate(cipher, seed=args.seed, real=real)
    elif real is not None:
        sig = signature(real.messages)
        print("real corpus signature:")
        for k, v in sig.items():
            print(f"  {k}: {v if isinstance(v, int) else f'{v:.5f}'}")


if __name__ == "__main__":
    main()
