#!/usr/bin/env python3
"""Statistics toolkit for the Noita eye-message ciphertext.

Operates on the canonical corpus format (see ../data/README.md):
    e1: 12 45 3 ...
Symbols are integers 0..82 (ALPHABET=83) in the orthodox reading order.

Subcommands:
    validate    sanity-check a corpus file (ids, range, coverage, no doubles)
    report      full statistical report (freq, IoC, entropy, doubles, gaps)
    gaps        repeated-symbol gap spectrum with z-scores (finding F5)
    isomorphs   find isomorphic segment pairs across messages (finding F6)
    selftest    run the suite against synthetic random data (no corpus needed)
"""

from __future__ import annotations

import argparse
import math
import random
import sys
from collections import Counter
from dataclasses import dataclass

ALPHABET = 83
EXPECTED_IDS = ["e1", "e2", "e3", "e4", "e5", "w1", "w2", "w3", "w4"]


@dataclass
class Corpus:
    messages: dict[str, list[int]]

    @property
    def all_symbols(self) -> list[int]:
        return [s for m in self.messages.values() for s in m]


def load_corpus(path: str) -> Corpus:
    messages: dict[str, list[int]] = {}
    with open(path) as f:
        for lineno, line in enumerate(f, 1):
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if ":" not in line:
                sys.exit(f"{path}:{lineno}: expected '<id>: <values>'")
            mid, _, rest = line.partition(":")
            messages[mid.strip()] = [int(t) for t in rest.split()]
    return Corpus(messages)


def validate(corpus: Corpus) -> list[str]:
    problems = []
    ids = list(corpus.messages)
    if sorted(ids) != sorted(EXPECTED_IDS):
        problems.append(f"expected ids {EXPECTED_IDS}, got {ids}")
    for mid, msg in corpus.messages.items():
        if not msg:
            problems.append(f"{mid}: empty message")
        bad = [s for s in msg if not 0 <= s < ALPHABET]
        if bad:
            problems.append(f"{mid}: values out of range 0..82: {bad[:5]}")
        doubles = [i for i in range(1, len(msg)) if msg[i] == msg[i - 1]]
        if doubles:
            problems.append(
                f"{mid}: adjacent repeats at {doubles[:5]} — violates F4; "
                "transcription is almost certainly wrong"
            )
    seen = set(corpus.all_symbols)
    missing = sorted(set(range(ALPHABET)) - seen)
    if missing:
        problems.append(f"corpus does not cover all 83 symbols; missing {missing}")
    return problems


def index_of_coincidence(seq: list[int]) -> float:
    n = len(seq)
    if n < 2:
        return float("nan")
    counts = Counter(seq)
    return sum(c * (c - 1) for c in counts.values()) / (n * (n - 1))


def shannon_entropy(seq: list[int]) -> float:
    n = len(seq)
    counts = Counter(seq)
    return -sum((c / n) * math.log2(c / n) for c in counts.values())


def chi2_flatness(seq: list[int]) -> tuple[float, float]:
    """Chi-square statistic against uniform, and its dof."""
    n = len(seq)
    expected = n / ALPHABET
    counts = Counter(seq)
    chi2 = sum(
        (counts.get(s, 0) - expected) ** 2 / expected for s in range(ALPHABET)
    )
    return chi2, ALPHABET - 1


def gap_spectrum(seq: list[int], max_gap: int = 30) -> dict[int, tuple[int, float, float]]:
    """For each gap g, count positions i where seq[i] == seq[i+g].

    Returns {gap: (observed, expected, z)} under a flat-random null where
    P(match) = 1/ALPHABET per comparison.
    """
    out = {}
    n = len(seq)
    for g in range(1, max_gap + 1):
        trials = n - g
        if trials <= 0:
            continue
        obs = sum(1 for i in range(trials) if seq[i] == seq[i + g])
        p = 1 / ALPHABET
        exp = trials * p
        sd = math.sqrt(trials * p * (1 - p))
        out[g] = (obs, exp, (obs - exp) / sd if sd else float("nan"))
    return out


def corpus_gap_spectrum(corpus: Corpus, max_gap: int = 30):
    """Pooled gap spectrum across messages (gaps never span messages)."""
    agg: dict[int, list[float]] = {}
    for msg in corpus.messages.values():
        for g, (obs, exp, _) in gap_spectrum(msg, max_gap).items():
            o, e = agg.get(g, [0.0, 0.0])
            agg[g] = [o + obs, e + exp]
    out = {}
    for g, (obs, exp) in sorted(agg.items()):
        p = 1 / ALPHABET
        trials = exp / p
        sd = math.sqrt(trials * p * (1 - p))
        out[g] = (int(obs), exp, (obs - exp) / sd if sd else float("nan"))
    return out


def gap_pattern(seq: list[int]) -> tuple[int, ...]:
    """Isomorph fingerprint: for each position, distance back to the previous
    occurrence of the same symbol (0 if none within the segment)."""
    last: dict[int, int] = {}
    pat = []
    for i, s in enumerate(seq):
        pat.append(i - last[s] if s in last else 0)
        last[s] = i
    return tuple(pat)


def find_isomorphs(corpus: Corpus, min_len: int = 8):
    """Find aligned or unaligned segment pairs across (or within) messages
    whose gap patterns match and which contain at least one repeat (else the
    match is vacuous). Returns list of (len, idA, posA, idB, posB)."""
    results = []
    items = list(corpus.messages.items())
    for ai in range(len(items)):
        for bi in range(ai, len(items)):
            ida, a = items[ai]
            idb, b = items[bi]
            for pa in range(len(a) - min_len + 1):
                for pb in range(pa + 1 if ai == bi else 0, len(b) - min_len + 1):
                    # extend as long as gap patterns agree
                    length = 0
                    while (
                        pa + length < len(a)
                        and pb + length < len(b)
                        and gap_pattern(a[pa : pa + length + 1])
                        == gap_pattern(b[pb : pb + length + 1])
                    ):
                        length += 1
                    if length >= min_len:
                        seg = a[pa : pa + length]
                        if max(gap_pattern(seg)) > 0:  # non-vacuous
                            results.append((length, ida, pa, idb, pb))
    # keep maximal, deduplicated matches
    results.sort(reverse=True)
    kept = []
    covered = set()
    for length, ida, pa, idb, pb in results:
        key_cells = {(ida, pa + k) for k in range(length)} | {
            (idb, pb + k) for k in range(length)
        }
        if not key_cells & covered:
            kept.append((length, ida, pa, idb, pb))
            covered |= key_cells
    return kept


def report(corpus: Corpus) -> None:
    total = corpus.all_symbols
    print(f"messages: {len(corpus.messages)}   total symbols: {len(total)}")
    print(f"{'id':>4} {'len':>5} {'IoC':>8} {'H(bits)':>8} {'chi2':>9} {'doubles':>8}")
    for mid, msg in corpus.messages.items():
        chi2, _ = chi2_flatness(msg)
        doubles = sum(1 for i in range(1, len(msg)) if msg[i] == msg[i - 1])
        print(
            f"{mid:>4} {len(msg):>5} {index_of_coincidence(msg):>8.5f} "
            f"{shannon_entropy(msg):>8.4f} {chi2:>9.1f} {doubles:>8}"
        )
    chi2, dof = chi2_flatness(total)
    print(
        f"\ncorpus IoC {index_of_coincidence(total):.5f} "
        f"(uniform-random expectation {1 / ALPHABET:.5f}); "
        f"entropy {shannon_entropy(total):.4f}/{math.log2(ALPHABET):.4f} bits; "
        f"chi2 {chi2:.1f} (dof {dof})"
    )
    print("\npooled gap spectrum (gap: observed / expected / z):")
    for g, (obs, exp, z) in corpus_gap_spectrum(corpus, 12).items():
        if g == 1:
            flag = "  (adjacent repeats — F4 says 0)"
        else:
            flag = "  <-- excess, cf. F5" if abs(z) > 3 else ""
        print(f"  {g:>3}: {obs:>5} / {exp:>7.1f} / z={z:+.2f}{flag}")


def make_synthetic(seed: int = 0) -> Corpus:
    rng = random.Random(seed)
    msgs = {}
    for mid in EXPECTED_IDS:
        n = rng.randint(90, 160)
        seq: list[int] = []
        while len(seq) < n:
            s = rng.randrange(ALPHABET)
            if seq and seq[-1] == s:
                continue  # emulate the no-doubles property
            seq.append(s)
        msgs[mid] = seq
    return Corpus(msgs)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--data", help="corpus file (see data/README.md)")
    ap.add_argument(
        "command",
        choices=["validate", "report", "gaps", "isomorphs", "selftest"],
    )
    ap.add_argument("--min-len", type=int, default=8, help="isomorph min length")
    args = ap.parse_args()

    if args.command == "selftest":
        corpus = make_synthetic()
        problems = [p for p in validate(corpus) if "missing" not in p]
        print("selftest on synthetic no-doubles corpus")
        report(corpus)
        print(f"\nvalidation problems (expected none): {problems or 'none'}")
        return

    if not args.data:
        sys.exit("--data is required (run data/fetch-data.sh first)")
    corpus = load_corpus(args.data)

    if args.command == "validate":
        problems = validate(corpus)
        if problems:
            print("\n".join(problems))
            sys.exit(1)
        print("corpus OK: 9 messages, values 0..82, full coverage, no doubles")
    elif args.command == "report":
        report(corpus)
    elif args.command == "gaps":
        for g, (obs, exp, z) in corpus_gap_spectrum(corpus, 40).items():
            print(f"{g}\t{obs}\t{exp:.2f}\t{z:+.3f}")
    elif args.command == "isomorphs":
        for length, ida, pa, idb, pb in find_isomorphs(corpus, args.min_len):
            print(f"len={length}  {ida}@{pa}  ~  {idb}@{pb}")


if __name__ == "__main__":
    main()
