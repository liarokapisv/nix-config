# Noita Eye Messages — Research Workspace

A self-contained research workspace for the unsolved **Eye Messages**
cryptography puzzle in [Noita](https://noitagame.com/), assembled from the
[Noita wiki page](https://noita.wiki.gg/wiki/Eye_Messages) (including the
*CodeWarrior0's Novel Cipher* section) and the community research documents it
references.

## Layout

| Path | Contents |
| --- | --- |
| `docs/01-overview.md` | What the messages are, where they appear, history, current status |
| `docs/02-encoding-and-structure.md` | Glyphs, rows, trigrams, the orthodox reading order, the 83-symbol alphabet |
| `docs/03-statistical-findings.md` | Every established statistical property of the ciphertext |
| `docs/04-codewarrior0-novel-cipher.md` | Deep dive on the *CodeWarrior0's Novel Cipher* analysis |
| `docs/05-ruled-out-and-hypotheses.md` | Cipher families ruled out, surviving hypotheses, and the constraint checklist any solution must pass |
| `docs/06-bibliography.md` | Every referenced document with URL and access notes |
| `data/` | Ciphertext data — format spec + `fetch-data.sh` to obtain canonical transcriptions |
| `tools/eyes_analysis.py` | Statistics toolkit: frequencies, IoC, doubles, gap spectrum, isomorph search |
| `tools/hypothesis_harness.py` | Test a candidate cipher implementation against the puzzle's statistical signature |

## Quick start

```sh
# Enter the analysis dev shell (python + numpy/scipy/sympy/pandas, ent, gnuplot, …)
nix develop .#noita-eyes

# Fetch canonical ciphertext transcriptions (needs normal network access)
./research/noita-eyes/data/fetch-data.sh

# Run the statistics suite over the messages
python research/noita-eyes/tools/eyes_analysis.py --data research/noita-eyes/data/messages.txt report
```

## Claude Code integration

- **Agents** (`.claude/agents/`): `noita-crypto-analyst` (statistical
  cryptanalysis, hypothesis evaluation) and `noita-cipher-implementer`
  (implements & simulates candidate ciphers against the constraint harness).
- **Skills** (`.claude/skills/`): `/noita-eyes` (orients a session on this
  workspace) and `/cryptanalysis` (general classical-cryptanalysis workflow).

## Ground rules established by prior research

Any proposed solution must be validated against `docs/05`'s constraint
checklist before being taken seriously — the community standard is that
*claims without a reproducible method are disregarded*.
