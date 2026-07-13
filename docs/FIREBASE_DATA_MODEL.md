# Firebase Realtime Database Model

```text
rooms/{roomCode}/
  metadata/
  settings/
  publicPlayers/{uid}/
  publicRound/
  privatePlayers/{uid}/
  clues/{roundNumber}/{uid}/
  votes/{roundNumber}/{uid}/
  results/{roundNumber}/
```

## Rules of ownership

- `metadata.hostUid`, room settings, phase changes, private-role writes, elimination, and results are host-only.
- A member may read public room state only while listed under `publicPlayers`.
- A member may read `privatePlayers/{theirUid}` only.
- The host may read private player state only where required by the initial Spark host-authoritative architecture.
- A player may write only their own public ready/presence fields, clue, vote, and mission claim.
- Joins use transactions and validate capacity, expiry, name uniqueness, and allowed room status.
- Votes and clues use the authenticated UID as their key and enforce phase-specific writes.
- Results are unreadable until the public phase reaches a reveal state.

## Timer synchronization

The host writes a single deadline using a server timestamp offset. Clients calculate visible countdowns locally. The database must never receive one write per second.

## Expiry

Spark rooms use client cleanup when the host closes a room, expiry rejection during join, and opportunistic stale-room cleanup. Scheduled cleanup belongs to the future Blaze migration.
