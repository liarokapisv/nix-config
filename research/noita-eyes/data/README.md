# Ciphertext Data

## Canonical format: `messages.txt`

One message per line, `<id>: <trigram values>`; values are base-10 integers
0–82 in the **orthodox reading order** (see `../docs/02`):

```
e1: 12 45 3 82 0 7 ...
e2: ...
e3: ...
e4: ...
e5: ...
w1: ...
w2: ...
w3: ...
w4: ...
```

Lines starting with `#` are comments. `e` = East parallel world, `w` = West.

## Obtaining the data

`messages.txt` is **not committed** here: this workspace was assembled in a
sandbox whose network policy blocks the source hosts, and committing a
from-memory transcription would risk silently corrupting the corpus — for
cryptanalysis the data must be bit-exact. Instead:

```sh
./fetch-data.sh          # clones the community research repos into external/
                         # (gitignored) and tells you which files to convert
```

Sources of truth for transcriptions, in order of preference:

1. `codewarrior0/noita-eye-glyph-analyses` — data used by the Analytical
   Overview.
2. `SirCapybar/NoitaEyeGlyphResearch` — trigram CSVs consumed by its C++
   toolkit.
3. `ngraham20/NoitaCryptographyResearch` — trigram data + analysis.
4. The wiki page's message images (ultimate ground truth; transcribe with the
   orthodox reading order and cross-check against 1–3).

Cross-check at least two sources; historical transcription errors are a known
hazard in this puzzle's research.

## Validation

After producing `messages.txt`:

```sh
python ../tools/eyes_analysis.py --data messages.txt validate
```

checks: 9 messages with the expected ids, all values within 0–82, all 83
values present corpus-wide, and **no adjacent repeats in any message** (a
transcription with doubles is definitionally wrong — see finding F4).
