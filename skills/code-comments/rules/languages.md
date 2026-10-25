# Same threshold in every language

**Do**: apply the identical two-signal threshold — nesting and hidden effects — to Go doc comments, Python docstrings, and YAML manifest comments.
**Avoid**: treating a language switch as license for banners, restating comments, or tracker references.

## Equivalents

- **JS/TS** — classic JSDoc with `{Type}` values matching the signature (`rules/jsdoc.md`).
- **Go** — doc comment directly above the exported declaration; an unannounced side effect is the only reason to go beyond one sentence.
- **Python** — docstring with the same two signals; state writes, deletes, or sends outside the return value.
- **YAML** — comment only what the manifest cannot say, such as why a replica count is pinned below the quota.

## Examples

```python
# ✅ Hidden effect: mutates the queue in place
def flush_metrics(queue):
    """Drains the queue and POSTs each batch to the collector.

    Side effect: empties `queue`; returns only the shipped count.
    """
```

```go
// ❌ Restates the signature: no comment
func GetUser(id string) (*User, error)

// ✅ Nesting: the inner guard is invisible from the signature
func (c *Client) Fetch(ctx context.Context, id string) (*User, error) {
	for attempt := 0; attempt < maxAttempts; attempt++ {
		if err := c.limiter.Wait(ctx); err != nil {
			// A rate-limit error must not consume the remaining retries
			return nil, err
		}
	}
}
```
