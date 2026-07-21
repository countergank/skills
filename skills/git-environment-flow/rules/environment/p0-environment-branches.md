---
priority: P0
category: environment
---

# Maintain three permanent environment branches

**Do**: Maintain `develop` (default HEAD, integration), `staging` (pre-production mirror), and `main` (production, always deployable, protected) in every Countergank repository.
**Avoid**: Direct pushes to `main`, using `main` as the default branch, or omitting any of the three branches.
**Reference**: [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow)

## Branch Purposes

| Branch | Role | Default HEAD | Required Reviewers |
|--------|------|:---:|:---:|
| `develop` | Integration branch — all features merge here first | Yes | 1 |
| `staging` | Pre-production mirror — curation testing before production | No | 1 |
| `main` | Production source — always deployable, protected | No | 2 |

## Branch Protection Settings

| Setting | `develop` | `staging` | `main` |
|---------|-----------|-----------|--------|
| Require pull request | Yes | Yes | Yes |
| Required reviewers | 1 | 1 | 2 |
| Dismiss stale reviews | Yes | Yes | Yes |
| Require last push approval | Yes | Yes | Yes |
| Require status checks | Yes | Yes | Yes |
| Require branches up to date (strict) | No | Yes | Yes |
| Restrict who can push | No | Yes (release/* only) | Yes (release/* and hotfix/* only) |
| Allow force pushes | No | No | No |
| Allow deletions | No | No | No |
| Include administrators | Yes | Yes | Yes |
| Admin bypass (pull request) | Yes | No | No |

> **GitHub note**: These settings map to "Branch protection rules" in repository settings. "Include administrators" enforces all rules for admins too. "Admin bypass (pull request)" uses `bypass_pull_request_allowances` to let admins skip PR requirements on `develop` only — remove this when the team grows.

### GitHub API Reference

```json
{
  "required_status_checks": { "strict": false, "contexts": ["<repo-specific>"] },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true,
    "require_last_push_approval": true
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
```

> **Status check names are repo-specific.** Each repository defines its own checks (lint, test, build) based on its stack. This skill requires that checks exist, not which ones.

### `develop` Protection

**Intent**: Integration branch — fast iteration with basic quality gates.

- **Required reviewers**: 1 (one approval required)
- **Status checks**: Required (CI must pass — lint, test, build per repo config)
- **Dismiss stale reviews**: Yes (re-approve after new commits)
- **Require last push approval**: Yes (last push must be approved by someone else)
- **Force push**: Blocked (history preservation)
- **Admin bypass**: Pull request bypass allowed (for solo work; remove when team grows)
- **Direct push**: Blocked (PR-only workflow)

**Why**: `develop` needs fast iteration but not zero quality. One reviewer catches obvious issues; status checks ensure code compiles and passes basic validation. Admin bypass allows self-merge when working solo — remove it when the team grows.

**Allowed merge paths**: Feature branches (squash merge) → `develop`

### `staging` Protection

**Intent**: Pre-production mirror — requires validation before production.

- **Required reviewers**: 1 (at least one approval)
- **Status checks**: Required (CI must pass)
- **Dismiss stale reviews**: Yes
- **Require last push approval**: Yes
- **Force push**: Blocked
- **Admin bypass**: No (no pull request bypass — admins must follow the flow)
- **Direct push**: Blocked (only release branches merge here)

**Why**: Staging is the last gate before production. A single review catches obvious issues; status checks ensure CI validation before curation testing begins. No admin bypass — even admins must go through the release flow.

**Allowed merge paths**: `release/*` branches only → `staging`

### `main` Protection

**Intent**: Production source — highest protection, multiple approvals required.

- **Required reviewers**: 2 (two distinct approvals)
- **Status checks**: Required (CI + staging validation)
- **Dismiss stale reviews**: Yes
- **Require last push approval**: Yes
- **Force push**: Blocked
- **Admin bypass**: No (no pull request bypass — admins must follow the flow)
- **Direct push**: Blocked (only release/hotfix branches merge here)

**Why**: `main` is production. Two distinct reviewers catch different perspectives; status checks ensure the code was validated in staging first. No admin bypass — this is the safety net for all production deployments.

**Allowed merge paths**: `release/*` branches → `main`, `hotfix/*` branches → `main`

### Hotfix Exception

**Rule**: `hotfix/*` branches bypass staging protection and merge directly to `main`.

**Rationale**: Hotfixes are emergency production fixes that cannot wait for staging curation. The tradeoff is acceptable because hotfixes are small, targeted, and already reviewed before merge.

**Enforcement**: GitHub branch protection rules must allow `hotfix/*` to bypass required reviews/status checks on `staging` and `main`.

**Cross-reference**: See `rules/hotfix/p1-hotfix-flow.md` for hotfix lifecycle details.

## Protection and Flow Interaction

Branch protection enforces the promotion chain by controlling which branches can merge into protected branches:

| Merge Path | Protection Effect |
|------------|-------------------|
| Feature → `develop` | PR required, squash merge. 1 reviewer + CI checks. Admin can bypass PR when working solo. |
| `release/*` → `staging` | PR required from `release/*` only. 1 reviewer + CI checks. No admin bypass. |
| `release/*` → `main` | PR required from `release/*` only. 2 reviewers + CI/staging checks. No admin bypass. |
| `hotfix/*` → `main` | PR required from `hotfix/*` only. Bypasses staging entirely — emergency path. |
| `main` → `develop` | Backmerge allowed. Protected branch pushing to less-protected branch — no conflict. |

> **Key insight**: Protection flows left to right. `develop` has basic gates (1 reviewer + CI) with admin bypass for solo work. `staging` adds gates and removes admin bypass. `main` has the highest protection with 2 reviewers and no bypass. This mirrors the promotion chain: risk increases as code moves toward production.

## Rules

1. **All three branches MUST exist** in every Countergank repository from initialization.
2. **`develop` is the default branch** — new PRs target `develop` by default.
3. **All branches are protected** — see "Branch Protection Settings" above. Direct pushes are rejected; only PRs from allowed source branches are permitted.
4. **`staging` is a mirror** — it receives code only through the promotion flow (release branch merge), never from feature branches directly.

## Concrete Examples

```
✅ Good: New repo created with develop, staging, main; develop set as default
✅ Good: PR targets develop for a feature branch — squash merge, 1 reviewer, CI must pass
✅ Good: Solo dev merges to develop using admin bypass — temporary, remove when team grows
✅ Good: release/1.2.0 PR targets staging — 1 reviewer required, CI must pass, no admin bypass
✅ Good: release/1.2.0 PR targets main — 2 reviewers required, CI + staging validation
✅ Good: hotfix/critical-fix PR targets main — bypasses staging, 2 reviewers (or admin merge)
✅ Good: main backmerged to develop — protected pushing to less-protected, allowed
✅ Good: All branches have "Include administrators" enabled
✅ Good: Stale review dismissed after new commits — re-approval required
❌ Bad:  Repo has only main branch
❌ Bad:  main is the default branch
❌ Bad:  Feature branch PR targets staging directly
❌ Bad:  Direct push to main bypasses PR
❌ Bad:  staging has 0 reviewers — curation is unvalidated
❌ Bad:  force push to main destroys production history
❌ Bad:  Admin bypasses protection on staging or main — bypass only allowed on develop
❌ Bad:  Merged PR with stale approval after new commits — dismiss_stale_reviews must be ON
```
