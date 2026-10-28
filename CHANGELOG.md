# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Changed

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
