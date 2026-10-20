# AGENTS.md — countergank/skills

Instructions for AI agents and human contributors working in this repository.

## Read first

- `skills/<name>/SKILL.md` — the skill you are about to change.
- `README.md` — install model and skill inventory.

## Commits

- **No `git commit` without an explicit authorization for that exact commit**, given by a
  human in this session after seeing the diff. "Let's work on X", an approved plan, or an
  authorized ODD feature does not authorize any commit.
- Before asking: show `git status --short` and `git diff --stat`, state the exact message,
  then stop and wait for a yes.
- Never chain `git commit` with other commands; never `--amend`, `--no-verify` or `-a`
  without authorization.
- If a commit lands without authorization, report it immediately. Do not amend or hide it.

This repository ships a tripwire for that rule. Enable it once per clone:

```bash
git config core.hooksPath .githooks
```

`.githooks/pre-commit` rejects every commit unless `GIT_COMMIT_APPROVED=1` is set. Set that
variable only on the exact command that executes an explicit human yes for that commit; never
set it to get past the question. A rejection is not an obstacle to work around: it means the
authorization step has not happened.

## Skills conventions

- Frontmatter: `name`, `description` starting with `Trigger:`, `license`, `metadata.author`,
  `metadata.version`.
- `description` is the discovery contract: list the trigger phrases (English and Spanish,
  as the installed skills do) and what the skill does.
- Step-based skills (like `kickoff`) carry ordered steps with the commands and queries to run.
  Rule-based skills carry `rules/<category>/pX-*.md` and a priority table.
- Every behavior change updates the `README.md` row of the skill and the installed copies.
- Run `./scripts/scan.sh skills/<name> --format json` before claiming a skill is ready.
