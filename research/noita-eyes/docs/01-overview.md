# Overview: The Noita Eye Messages

> Primary source: <https://noita.wiki.gg/wiki/Eye_Messages> (mirror:
> <https://noita.fandom.com/wiki/Eye_Messages>). See `06-bibliography.md` for
> all sources and per-claim attribution notes.

## What they are

The Eye Messages are a series of **9 messages written in eye-shaped glyphs**
hidden in Noita's parallel worlds. They are one of the game's two major
unsolved secrets (the other being the Cauldron room) and are widely believed
to be a **pure cryptography puzzle** left by the developers for the community.

Key facts:

- **9 messages total**: **5 in the East parallel world, 4 in the West**
  parallel world.
- Each message has a **counterpart in the mirrored location of the opposite
  parallel world** — with **one exception**: one East message has no Western
  counterpart (hence 5 vs 4).
- Messages **only generate after the player has travelled to a parallel
  world**, and their in-world positions are **randomly determined by the world
  seed** (no fixed landmark mapping).
- They are **only visible when playing with mods disabled** — one of the few
  pieces of content gated this way, underscoring that they are meant to be
  found "legitimately".

## Provenance and developer signals

- The messages have been present since (at least) early 2021 builds; the
  community effort to decode them dates from **March 2021** — any proposed
  theory must explain observations from that period onward.
- The **developers have confirmed the messages contain a real message** (they
  are not decorative noise).
- The Noita codebase has been **decompiled with Ghidra**: there is **no
  trigger, interaction, spell, or boss mechanic** attached to the eyes. Nothing
  in the engine reads them back. They are a standalone cryptogram that could,
  in principle, be solved on paper.
- No successful translation has ever been made public. The community's
  standing rule: *anyone claiming to have solved the eyes without presenting a
  reproducible method should not be believed.*

## Where research happens

- The hub is the **Official Noita Discord**, channel **`silmä-huone`**
  ("eye room" in Finnish) — access is granted by moderators on request. The
  channel's pinned messages link the up-to-date research documents.
- An index document (the "**Emerald Tablet Document**") catalogues research
  documents for the Eye Messages, the Cauldron room, and other mysteries.
- The most rigorous public statistical treatment is **CodeWarrior0's
  "Noita Eye Glyphs: Analytical Overview"** (Google Doc) with companion code
  in the `codewarrior0/noita-eye-glyph-analyses` GitHub repository — see
  `04-codewarrior0-novel-cipher.md`.

## Status (as of mid-2026)

**Unsolved.** The alphabet, message segmentation, and reading order are
considered settled (see `02-encoding-and-structure.md`); a rich set of
statistical constraints is established (see `03-statistical-findings.md`);
entire families of classical ciphers are ruled out (see
`05-ruled-out-and-hypotheses.md`). The leading view — argued in the wiki's
*CodeWarrior0's Novel Cipher* section — is that the developers used a
**novel, hand-designed cipher** with a large hidden internal state (on the
order of permutations of the 83-symbol alphabet), rather than any textbook
cipher.
