# Countergank Skills

[![Security Scan](https://github.com/countergank/skills/actions/workflows/security-scan.yml/badge.svg)](https://github.com/countergank/skills/actions/workflows/security-scan.yml)

A collection of agent skills installable via the `npx skills` ecosystem.

## Install

```bash
npx skills add countergank/skills
```

This discovers all skills under `skills/` and installs them to your agent's skill directory.

## Available Skills

| Skill | Description |
|-------|-------------|
| `nestjs-backend` | Production-ready NestJS backend development. Modules, controllers, DI, guards, pipes, TypeORM, Prisma, JWT auth, Swagger, testing, Docker. |

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
