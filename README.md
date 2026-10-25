# Countergank Skills

[![Security Scan](https://github.com/countergank/skills/actions/workflows/security-scan.yml/badge.svg)](https://github.com/countergank/skills/actions/workflows/security-scan.yml)

A collection of agent skills installable via the `npx skills` ecosystem.

## Install

```bash
npx skills add countergank/skills
```

This discovers all skills under `skills/` and installs them to your agent's skill directory.

## Commit Gate

This repository ships a `pre-commit` hook that refuses every commit until a person authorizes it:

```bash
git config core.hooksPath .githooks
```

The hook blocks unless `GIT_COMMIT_APPROVED=1` is set in the environment, which is the signal that
the person saw the diff and said yes. See `AGENTS.md`.

## Available Skills

| Skill | Description |
|-------|-------------|
| `nestjs-backend` | Production-ready NestJS backend development. Modules, controllers, DI, guards, pipes, TypeORM, Prisma, JWT auth, Swagger, testing, Docker. |
| `react-frontend` | Modern React 19 frontend development with TypeScript 5, Vite, and Vitest — 87 WCAG 2.2-compliant rules across 10 categories. |
| `github-conventions` | Authoritative GitHub conventions: conventional commits, branch naming, PR templates, issue linking, changelog. |
| `code-comments` | Comment and JSDoc standard: self-sufficient code carries no comments; JSDoc fires only for nesting or hidden effects, types must match the signature, and no ticket or priority-tag references in code. |
| `git-environment-flow` | Org-wide Git environment branch model, promotion flow, release lifecycle, and deployment tracking. |
| `kubernetes-best-practices` | Kubernetes and CDK8s infrastructure best practices: Deployments, Services, Ingress, NetworkPolicies, secrets. |
| `linear-tickets` | Org-standard Linear ticket authoring and integration: Spanish scannable titles, complete descriptions, testable AC, and `COU-###`/`fixes` GitHub linkage. |
| `kickoff` | Session bootstrap with hard gates: Linear project, ticket readiness (project, estimate, assignee), ticket state per moment, branch created from Linear's `branchName`, ODD tracking. Nothing is implemented without a ticket, and no commit happens without explicit authorization. Delegates every rule to `git-environment-flow`, `github-conventions` and `linear-tickets`. |

## Developer Tools

Scripts in `scripts/` are for local development and security scanning, not user-facing installers.

| Script | Purpose |
|--------|---------|
| `scripts/setup.sh` | Clone and install SkillSpector for local scanning |
| `scripts/scan.sh` | Scan a single skill directory with SkillSpector |
| `scripts/scan-all.sh` | Scan all skills in the repository |

### Setup

```bash
./scripts/setup.sh
./scripts/scan.sh skills/nestjs-backend --format json
./scripts/scan-all.sh --format json
```

## Skill Structure

Each skill follows the Vercel `react-best-practices` pattern:

- `SKILL.md` — Compact trigger-first entry point (~300-450 tokens)
- `rules/` — One rule per file, prioritized P0-P3 across categories
- `assets/` — Code templates and boilerplate

## Contributing

1. Create a skill directory under `skills/<name>/`
2. Write `SKILL.md` with trigger-first frontmatter and priority table
3. Add rule files under `rules/<category>/`
4. Run `./scripts/scan.sh skills/<name> --format json` — must exit 0
5. Submit a pull request

## Security

See [SECURITY.md](SECURITY.md) for vulnerability reporting, scanning policy, and trust model.
