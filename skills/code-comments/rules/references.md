# No tickets, PRs, or priority tags inside code comments

**Do**: Keep comments about the code itself: the non-obvious constraint or decision they protect.
**Avoid**: Ticket IDs (`COU-331`), PR and issue references (`#123`), tracker links, and priority tags such as `(P0)` inside code comments.

## Why

Tickets and PRs age, move between trackers, and mean nothing to a reader six months later. Priority tags belong to the issue tracker and the review checklist, not to the line of code they grade. If the surrounding context matters, put it in the commit message or the PR description, where history keeps it findable.

## Examples

```
❌ Bad:
// (P0) Fixed in COU-331, see PR #412
await invalidateCache(user.id);

✅ Good:
// Stale cache here serves deleted profiles for up to an hour
await invalidateCache(user.id);
```
