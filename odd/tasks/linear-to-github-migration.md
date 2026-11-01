# linear-to-github-migration

Migrate countergank's ticketing from Linear (free plan, 250-issue cap) to GitHub
Issues + Projects (free, unlimited). Covers data migration, skill refactors, and
reinstalls in consumer repos.

## Specs

- S1: User: "tengo informacion de que hoy github en cuanto a features y limites free es mucho mas flexible que linear, veamos si esto es realmente correcto, quisiera saber cual en realidad es la mas recomendable a dia de hoy para usar de manera Free" — verified: GitHub Free wins (unlimited issues, unlimited boards, 50k items/project vs Linear 250 issues + 2 teams).
- S2: User: "si se decide por github, vamos a tener que realizar una migracion de datos de linear a github y un refactor de la skill kickoff y si aplica la de linear tickets tambien, pasaria a tener otro nombre y otras referencias" — decision taken in session: "Migrar a GitHub".
- S3: Issues live in each repo (homonymous with it, as Linear projects are today); each repo has a board via GitHub Projects.
- S4: Branch convention replaces Linear `branchName`: `feature/<issue-number>-<short-slug>` (e.g. `feature/262-auth-status-codes`).
- S5: `fixes #<number>` replaces `fixes COU-###` as the PR magic word. GitHub auto-close fires only when the PR merges into the repo's default branch; if work merges to a non-default branch (develop), an explicit close or automation is required — kickoff step 7 must account for this.
- S6: Estimate moves to a GitHub Projects custom number field; `kickoff` verifies project + estimate + assignee before touching code, as today.
- S7: Every behavior change updates the skill's README row and the installed copies (AGENTS.md).
- S8: No `git commit` without explicit per-commit authorization (AGENTS.md).

## Tasks

| ID | Spec | Task | Route | Commit |
|----|------|------|-------|--------|
| T1 | S2,S4,S5,S6 | Rewrite `skills/kickoff/SKILL.md` for GitHub Issues + Projects | inline | 11b9061 |
| T2 | S2,S4,S5 | Rename `linear-tickets` → `github-tickets`; rewrite SKILL, rules (title, description, labels, language, integration), references, templates | inline | 8bcac3f |
| T3 | S2,S4,S5 | Update `github-conventions` (SKILL.md, rules/branch.md, rules/pr.md, PR template) and `git-environment-flow` SKILL.md | inline | fd02af5 |
| T4 | S7 | Update README rows, CHANGELOG, `.atl/skill-registry.md` | inline | 896a84f |
| T5 | — | Validate changed skills with `./scripts/scan.sh skills/<name> --format json` | inline | done |
| T5b | — | Install GitHub issue templates in this repo (`.github/ISSUE_TEMPLATE/`) | inline | 204a193 |
| T6 | S2 | Migrate ALL Linear issues → GitHub issues (full history, all projects), script, mapping table, "Migrated from COU-###" bodies | inline | pending |
| T7 | S2,S7 | Reinstall refactored skills in api-user, backend-nosql-standard-project, frontend-standard-project, ui-user. For api-user and ui-user: work in same-clone worktrees (their main dirs have active feature work) and STOP before that stage for user check-in | inline | pending |

## Log

- L1: User: "Buenas chat, necesito que analicemos los siguiente, en funcion de las limitaciones de la ticketera, para el caso hoy estamos usando linear y tengo informacion de que hoy github en cuanto a features y limites free es mucho mas flexible que linear, veamos si esto es realmente correcto, quisiera saber cual en realidad es la mas recomendable a dia de hoy para usar de manera Free y en funcion de esto, si se decide por github, vamos a tener que realizar una migracion de datos de linear a github y un refactor de la skill kickoff y si aplica la de linear tickets tambien, pasaria a tener otro nombre y otras referencias"
- L2: User follow-up: "uan cosita mas que me gustaria saber antes de terminar de decidir, en la parte de gestion de proyectos que permite armar tableros, hasta cuantos se pueden crear?" — answered: GitHub Projects unlimited boards (50k items, 50 fields each); Linear Free 2 teams / 250 shared issues.
- L3: User decision (questionnaire): "Migrar a GitHub".
- L4: Evidence: linear.app/pricing (Free: 250 issues, 2 teams), GitHub changelog 2025-04-09 (50,000 items/project GA), docs.github.com projects limits (50 fields). Session memory: 298 Linear issues had to be deleted to free quota (250 cap counts completed issues).
- L5: User: "1. Para cuando lleguemos a la etapa de migracion a los repos de ui-user y api-user, como actualmente estan trabajando en el directorio principal en otras features, voy a necesitar que trabajes en worktrees, pero quiero que frenes cuando llegue ese momento. 2. Vamos a tener que hacer un recap de todos los proyectos y tickets asociados que hoy en dia tenemos en Linear y vamos a tener que proceder a realizar una migracion completa de ellos" — migration scope: ALL projects, ALL tickets (full history); T7 stop-point before api-user/ui-user stage.
- L6: Migration executed: 48/48 issues created (api-user #455-464 area, infrastructure #9-24, ui-user #43-64), cross-refs rewritten to "#N (COU-###)" in 15 issues, COU-358 closed. Migration script /tmp/migrate.py, export /tmp/linear-export.json, map /tmp/cou-map.json. BLOCKED Pass 3 (Projects v2 boards + Estimate field): neither GITHUB_TOKEN (fine-grained PAT) nor gh OAuth token has read:project/project scope. User must grant token scopes.
- L7: User granted scopes via gh device flow (code 18E9-A9B9, approved). Pass 3 completed (script /tmp/pass3.py, mutation createProjectV2Field — addProjectV2Field does not exist): org boards api-user (10 items), infrastructure (16), ui-user (22) created and verified via API counts; Status set (Todo/In Progress/Done), Estimate number field set on COU-348=3, COU-349=3, COU-293=2, COU-358=1. T6 DONE.
- L8: T1-T5 executed inline. kickoff 3.0.0 (gh CLI + GraphQL board queries, convention branch, develop-merge close caveat); linear-tickets renamed github-tickets 3.0.0 (git mv, all rules/references rewritten, templates untouched); github-conventions 2.1.0 + git-environment-flow boundary updated; README/CHANGELOG/registry updated. scan.sh: all LOW/SAFE; github-conventions 2 findings are pre-existing false positives (`--force` substring of `--force-with-lease`, untouched P1 section). Net diff 196+/178- across 22 files. T7 blocked at user stop-point (worktrees for api-user/ui-user). Commits NOT made — awaiting per-commit authorization (AGENTS.md).
- L9: Wave 2 executed (/tmp/wave2.py, background job): 236 with-project non-SDD archived/completed issues migrated closed (created=170, linked=66 pre-existing twins by title; state_reason completed/not_planned), 10 new org boards (portfolio skipped: repo countergank/portfolio does not exist, 1 issue logged in /tmp/wave2-skipped.json), 80 issues had cross-refs rewritten, Estimate field set where present. GitHub dedupes project items by issue → boards hold unique issues (api-timegank 30 of 38 adds, etc.).
- L10: Board split executed: old board timegank-countergank (#1, 64 items = 55 issues + 9 DraftIssues incl. CREDENTIALS/.env notes) re-homed with exact parity (55/55 issues + 9/9 drafts; drafts backup /tmp/timegank-drafts-backup.json; PLAN/CREDENTIALS/Files went to api-timegank, .env.frontend to ui-timegank), then board deleted (user-authorized). Final org boards: api-user 71, infrastructure 28, ui-user 54, skills 19, api-timegank 41, ui-timegank 36, backend-nosql 22, frontend-standard 16, 5× single-issue boards, @task-management-system untouched. Migration of all with-project non-SDD Linear issues is COMPLETE (284 issues mapped in /tmp/cou-map2.json).
- L11: Full kickoff flow executed on issue #79 (Migrar la ticketera de Linear a GitHub Issues + Projects, chore+infra, est=3, assignee Leandro): board In Progress → branch feature/79-migrar-ticketera-github from origin/develop (no-track) → 5 authorized commits (11b9061 kickoff, 8bcac3f github-tickets+templates, fd02af5 conventions, 896a84f docs, 204a193 .github/ISSUE_TEMPLATE install) → pushed → PR #80 with fixes #79 → board In Review (added the missing In Review option to the skills board Status field via updateProjectV2Field). First commit attempt wrongly included pre-staged renames; reset (mixed, no worktree loss) and re-split correctly. NOTE for kickoff skill follow-up: boards created from defaults lack the In Review option — the skill's resolve-by-name rule covers it, but flagging it here.
