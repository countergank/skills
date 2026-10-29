# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Fixed

- **kubernetes-best-practices**: the RBAC example now shows the `RoleBinding` that joins the ServiceAccount and the Role, and the Role carries its `metadata.name`, so the trio can be pasted as written; the YAML eval holds at 12/12 runs on both sides

### Changed

- **kubernetes-best-practices**: an eighth domain file, `rules/cdk8s.md`, states how each decision is written when the repository authors with cdk8s — build on `plus.Deployment` and `addContainer` instead of raw `Kube*` objects, and the construct's vocabulary for the security context, the resources, the probes and the labels; anything the construct does not model keeps the YAML rule of its own domain. The cdk8s eval moves the `uses-plus` signal from 2/5 to 5/5 runs with no other signal changing
- **git-environment-flow**: reduce 6 rule files to 4 domain files (`rules/environment.md`, `promotion.md`, `hotfix.md`, `release.md`) — `p2-deployment-tracking` retires as generic, `p0-release-automation` collapses to a pointer at `assets/release.sh` with its real flags and its abort contract, and the exception "a hotfix skips the staging curation path but never the review" now has a single owner in `rules/hotfix.md`; the behavioral eval, five runs per condition and thirteen signals, shows no signal degrading and one improving — the staging-is-not-the-source-of-main rule, 3/5 to 4/5
- **linear-tickets**: reduce 7 rule files to 5 domain files (`rules/title.md`, `description.md`, `labels.md`, `language.md`, `integration.md`) — the normative content is translated to English, `p1-per-type-templates` folds into the `SKILL.md` decision gates, and `p0-platform-structure` retires as a speculative extension contract for platforms that do not exist; the behavioral eval, five runs per condition and twelve signals, shows no signal degrading
- **kubernetes-best-practices**: reduce 67 rule files to 7 domain files (`rules/<category>.md`) — 47 rules survive, 15 absorb a duplicate from another category, 5 retire, and the two contradicting limit-to-request ratios collapse into one rule (CPU 2-5x, memory 1.2-1.5x). The eleven rules a manifest linter could enforce stay as prose: the tool gate is reported, not enabled, because this repository ships no cluster and `references/polaris-default.yaml` documents checks rather than running them
- **github-conventions**: reduce 14 rule files to 3 domain files (`rules/commit.md`, `rules/branch.md`, `rules/pr.md`) — 7 rules distilled into the commit standard, 3 kept as their own domain rules, 4 dropped; `p1-changelog-automation` stays as prose because release-please is not adopted in this repository, so the tool gate is reported and not enabled
- **nestjs-backend**: reduce 68 rule files to 6 domain files (`rules/<domain>.md`, one level) — 37 rules dropped as model defaults or framework documentation, 10 merged into their targets, `p2-coverage-targets` moved to `assets/jest.config.js` and `p1-fastify-adapter` into the decision reference; `p1-csrf-protection` goes with the deprecated `csurf`, and `SKILL.md` is rewritten to a six-domain table plus the decision reference
- **react-frontend**: reduce 87 rule files to 10 domain files (`rules/<domain>.md`, one level) — 31 rules dropped as model defaults, 17 moved to `assets/eslint.config.js` as lint checks, 7 merged into their targets, and `forwardref-deprecated` rewritten as a React 19/18 version discriminator plus `advanced-caching` scoped to `staleTime`/`gcTime` and `Cache-Control`; `SKILL.md` rewritten to a ten-domain table

### Added

- **code-comments**: comment and JSDoc standard — no comments without the nesting or hidden-effect signal, classic typed JSDoc when it fires, and no ticket or priority-tag references in code

## [1.4.0] - 2026-10-20

### Added

- **kickoff**: gate the bootstrap on ticket, branch and ticket state

### Fixed

- **kubernetes-best-practices**: align assets with the skill's own P0 rules
- **react-frontend**: align SPA scope, examples and scan gate
- **nestjs-backend**: align priority table, error shape and platform notes
- **git-environment-flow**: define promotion as a fork and keep hotfix reviews
