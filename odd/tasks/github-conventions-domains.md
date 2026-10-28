# github-conventions: de 14 reglas a 3 archivos de dominio

- **Feature**: `github-conventions-domains`
- **Ticket**: COU-336 — https://linear.app/countergank/issue/COU-336/destilar-github-conventions-y-crear-la-plantilla-de-commit
- **Rama**: `feature/cou-336-destilar-github-conventions-y-crear-la-plantilla-de-commit`
- **Base**: `origin/develop`
- **Padre**: `odd/tasks/skills-reduction.md` (estándar, taxonomía, presupuestos)

## Specs

S1. *"Cada archivo de dominio queda en ≤200 líneas, con ≤40 líneas por regla y un único par ✅/❌."*

S2. *"`SKILL.md` en ≤60 líneas, con tabla de dominios y un pitch por archivo."*

S3. *"Cero referencias a archivos inexistentes en el `SKILL.md`."*

S4. *"`./scripts/scan.sh skills/<name> --format json` termina con código 0."*

S5. *"Eval **antes y después**: los mismos 3 prompts corridos con el set original y con el reducido,
en ese orden. Criterio de aceptación: **ninguna métrica empeora**; que mejore no es requisito."*

S6. *"**Un commit por dominio**, no uno solo por skill: un candidato de cientos de archivos no puede
revisarse (el reviewer lo rechaza en preflight con `lens_context_budget_exceeded`, ver COU-333)."*

S7. *"Crear `assets/COMMIT_TEMPLATE.txt` con el esqueleto de subject, body y footers, alineado a
Conventional Commits v1.0.0 y a las siete reglas de Chris Beams."*

S8. *"`rules/commit.md` lleva solo lo que es decisión de este repo: tipos permitidos, nombres de
scope, 50/72."*

S9. *"Gate de herramientas: las reglas que pasan a una herramienta se habilitan ANTES de borrar su
prosa. Si no se pueden habilitar, la regla se queda y se reporta."*

S10. *"no commitees hasta que el eval esté corrido y no muestre degradación."*

## Decisiones

D1. **release-please no se adopta.** `p1-changelog-automation` es la única tool rule y su destino era
release-please. Este repo tiene un solo workflow (`security-scan.yml`), el `CHANGELOG.md` se mantiene
a mano y las versiones se cortan manualmente; activarlo cambia el proceso de release del repo y
colisiona con COU-338, que es el ticket de la automatización de release. Por S9 la regla **se queda**:
entra como quinta regla de `commit.md` (mapeo tipo → sección de CHANGELOG, Keep a Changelog) sin
nombrar herramienta, y el gate se reporta como no habilitado.

D2. **Los assets ya existen.** `assets/COMMIT_TEMPLATE.txt` (verificado: `type(scope)`, 50 caracteres,
wrap 72, footers) y `assets/PULL_REQUEST_TEMPLATE.md`. El criterio S7 está satisfecho; `pr.md` y
`commit.md` los referencian en vez de recrearlos.

D3. **Referencias cruzadas.** `git-environment-flow/rules/release/p0-release-automation.md` apunta a
`github-conventions/rules/meta/p0-type-definitions.md` y `.../p1-changelog-automation.md`, los dos
archivos que este ticket borra. Se actualizan a `github-conventions/rules/commit.md` en el commit de
`commit.md`, no después.

D4. Los cinco `.gitkeep` de `rules/*/` y `assets/` se borran junto con sus directorios vacíos.

D5. **Corte real**: 3 reglas keep + 7 absorbidas en `commit.md` + 4 drops = 14. La tabla del plan padre
cuenta 10 drops y 1 tool porque suma las 7 absorbidas al balde de drops y trata el changelog como
herramienta; el conteo medido reemplaza ese número en la auditoría.

## Veredicto por archivo

**`rules/commit.md`** — 5 reglas, en este orden:
1. `## P0 — Open every commit with one of the eleven Conventional Commit types` (absorbe
   `meta/p0-type-definitions` y la forma del header de `commit/p0-conventional-commits`).
2. `## P0 — Write the subject in the imperative, lowercase, in 50 characters` (absorbe
   `commit/p0-subject-line` y el nombre de scope de `commit/p1-scope-rules`: kebab, corto, consistente,
   omitido si no aplica).
3. `## P1 — Explain why in the body and keep footers on their own lines` (`commit/p1-body-footers`).
4. `## P1 — Mark a breaking change with ! and a BREAKING CHANGE footer`
   (`commit/p2-breaking-changes`).
5. `## P2 — Map commit types to CHANGELOG sections` (`meta/p1-changelog-automation`, sin nombrar
   herramienta).

**`rules/branch.md`** — 2 reglas: `p0-branch-naming` (el `branchName` de Linear verbatim, `type/description`
sin ticket, tipos permitidos) y `p1-branch-lifecycle` (desde `develop` con `--no-track`, rebase, borrar
después del merge).

**`rules/pr.md`** — 2 reglas: título conventional + descripción llenada desde
`assets/PULL_REQUEST_TEMPLATE.md`; y linkeo de issues (`fixes COU-###` para Linear, `Closes/Fixes/Refs`
para GitHub), absorbiendo `pr/p0-pr-description` y `pr/p0-pr-template`.

**Drops**: `pr/p1-review-checklist` (un agente no ejecuta checklists leyéndolas) y
`pr/p2-status-labels` (el repo no usa labels de estado).

## Forma

Primera línea `# <Dominio> — Priority P0`, después una frase de alcance. Una regla por `##`, ≤40 líneas,
un par ✅/❌ de 3-10 líneas, normativo en positivo, sin condicionales anidados, sin frontmatter.

## Tasks

| ID | Spec | Tarea | Commit |
|----|------|-------|--------|
| T1 | S1,S8 | `rules/commit.md` + borrar `rules/commit/` y `rules/meta/` + actualizar la referencia de `git-environment-flow` | C1 |
| T2 | S1 | `rules/branch.md` + borrar `rules/branch/` | C2 |
| T3 | S1 | `rules/pr.md` + borrar `rules/pr/` | C3 |
| T4 | S2,S3 | `SKILL.md`, `README.md`, `CHANGELOG.md`, tabla de auditoría, `.gitkeep` | C4 |
| T5 | S1,S3,S4 | Verificación estructural: conteos, presupuestos, scan, huérfanas | — |
| T6 | S5,S10 | Eval 5+5 corridas, 12 señales, sin degradación | — |
| T7 | S6 | Commits por dominio, push, PR | C1-C4 |

## Log

L1. *"listo mergeado, con que seguimos? usa kickoff y vemos"* → kickoff eligió COU-336 entre los
cuatro derivados de COU-332; el ticket nombra `commit.md` (destilado), `branch.md` y `pr.md`.

L2. Gate de herramientas resuelto por D1: la regla del CHANGELOG se queda como prosa y el gate se
reporta como no habilitado, en lugar de adoptar release-please en este repo.

L3. Auditoría medida antes de tocar: 14 archivos de regla, `SKILL.md` 51 líneas, `scan.sh` exit 0.
`assets/COMMIT_TEMPLATE.txt` y `assets/PULL_REQUEST_TEMPLATE.md` ya existen y están alineados.
