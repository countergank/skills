# nestjs-backend: 68 reglas a 6 archivos de dominio

- **Feature**: `nestjs-backend-domains`
- **Ticket**: COU-334 — https://linear.app/countergank/issue/COU-334/reducir-nestjs-backend-de-68-reglas-a-7-archivos-de-dominio
- **Rama**: `feature/cou-334-reducir-nestjs-backend-de-68-reglas-a-7-archivos-de-dominio`
- **Base**: `origin/develop`
- **Padre**: `odd/tasks/skills-reduction.md` (estándar S1-S11, taxonomía, presupuestos)

## Specs

S1. *"Cada archivo de dominio queda en ≤200 líneas, con ≤40 líneas por regla y un único par ✅/❌."*

S2. *"`SKILL.md` en ≤60 líneas, con tabla de dominios y un pitch por archivo."*

S3. *"Cero referencias a archivos inexistentes en el `SKILL.md`."*

S4. *"`./scripts/scan.sh skills/<name> --format json` termina con código 0."*

S5. *"Eval **antes y después**: los mismos 3 prompts corridos con el set original y con el reducido,
en ese orden. Criterio de aceptación: **ninguna métrica empeora**; que mejore no es requisito. Un drop
que degrada se revierte y vuelve al set."*

S6. *"**Un commit por dominio**, no uno solo por skill: un candidato de cientos de archivos no puede
revisarse (el reviewer lo rechaza en preflight con `lens_context_budget_exceeded`, ver COU-333)."*

S7. *"Gate de herramientas: las reglas que pasan a ESLint se habilitan ANTES de borrar su prosa. Si no
se pueden habilitar, la regla se queda y se reporta."*

S8. *"Si alguna empeora: NO commitear; buscar la regla perdida, corregir su presentación y repetir el
eval."*

S9. *"no commitees hasta que el eval esté corrido y no muestre degradación."*

S10. *"Prioridad como encabezado dentro del archivo de dominio, nunca en el path ni en frontmatter
duplicado."* + *"Reescribir el `description` con triggers en inglés y español, tercera persona, ≤1024
caracteres."*

S11. *"`p0-validation-pipe` y `p1-dto-validation` se unifican en `security.md`."* + *"La regla de
`csurf` se va: el paquete está deprecado."*

## Decisiones

D1. **Seis archivos de dominio**, los que nombra el ticket: `controllers`, `security`, `data`, `auth`,
`api`, `operations`. El "7" del título cuenta el `SKILL.md`. `architecture` y `testing` desaparecen.

D2. **Frontera `auth` / `security`**: `auth.md` responde *"¿quién está llamando?"* (`p0-guards`,
`p1-guard-composition`, `p1-jwt-auth`); `security.md` responde *"¿qué llega en el request?"*
(`p0-validation-pipe` absorbida con `p1-dto-validation`, `p0-helmet-cors`, `p1-rate-limiting`). Sin
esta separación las dos tareas caen en el archivo equivocado.

D3. **Baldes**: 20 keep, 10 merge, 1 tool, 37 drop. El plan padre cuenta 19/10/1/38; la diferencia es
`p1-guard-composition`, que sobrevive como el orden "autenticar antes de autorizar" dentro de
`auth.md`. El conteo final medido se registra en la tabla de auditoría del plan padre.

D4. **Tool gate**: `p2-coverage-targets` pasa a `assets/jest.config.js` (`coverageThreshold` +
`collectCoverageFrom`), que entra antes de borrar la prosa. La adopción en el CI del proyecto destino
no es verificable desde este repo y se declara como límite en el PR.

D5. `p1-fastify-adapter` no se borra: pasa al Quick Reference del `SKILL.md`.

D6. **Tamaño de slice.** Cada commit de dominio ronda las 300-460 líneas cambiadas contando
borrados, porque el borrado de la categoría entera viaja con su archivo nuevo. El ticket exige un
commit por dominio (S6) y el reviewer rechaza por `lens_context_budget_exceeded` un candidato de
cientos de archivos: el límite de ~400 líneas cedió ante la restricción explícita, y el PR declara
el conteo por commit para que el reviewer sepa qué esperar.

## Veredicto por dominio

Paths relativos a `skills/nestjs-backend/`. `k` = keep, `m` = merge dentro del dominio, `d` = drop.

**controllers.md** — k: `p0-route-organization` (estáticas antes que paramétricas), `p1-serialization`
(no filtrar entidades), `p1-decorator-composition` (absorbe `p2-controller-file-structure` y
`p2-endpoint-decorators`). out: `p1-response-types` → api, `p1-dto-validation` → security. d:
`p0-controller-decorators`, `p2-subdomain-routing`, `p3-redirects`, `p2-versioning`, `p1-custom-param-decorators`.

**security.md** — k: `p0-validation-pipe` + `p1-dto-validation` (una regla), `p0-helmet-cors`,
`p1-rate-limiting`. d: `p1-csrf-protection` (paquete deprecado), `p1-input-sanitization`,
`p2-encryption`, `p3-ip-filtering`, `p1-file-uploads`. out: `p2-audit-logging` → operations.

**data.md** — k: `p0-eager-lazy-loading`, `p0-n-plus-one-queries`, `p1-migrations`, `p1-transactions`,
`p1-batch-operations` + `p1-select-columns` (una regla de lote y columnas). d: `p0-repository-pattern`,
`p0-typeorm-entities`, `p1-prisma-setup`, `p2-multiple-databases`, `p2-read-replicas`,
`p3-seed-factories`.

**auth.md** — k: `p0-guards` (viene de security), `p1-guard-composition`, `p1-jwt-auth`. d:
`p1-passport-strategies`, `p2-api-keys`, `p2-oauth2`, `p3-mfa`.

**api.md** — k: `p1-openapi-swagger` (absorbe `p1-response-types`), `p1-error-formats`,
`p2-pagination`. d: `p2-graphql`, `p3-hateoas`.

**operations.md** — k: `p1-config-module`, `p1-logging` (absorbe `p2-audit-logging`),
`p2-health-checks`, `p2-fastify-plugins`. d: `p2-caching`, `p2-metrics`, `p3-distributed-tracing`,
`p1-docker`. out: `p1-fastify-adapter` → Quick Reference del `SKILL.md`.

**architecture/** — d: `p0-dependency-injection`, `p0-modules`, `p0-providers`, `p1-custom-providers`,
`p1-dynamic-modules`, `p2-lazy-loading`, `p3-circular-dependencies`. m: `p1-module-organization` →
controllers.

**testing/** — tool: `p2-coverage-targets` → `assets/jest.config.js`. d: `p1-unit-tests`,
`p1-e2e-tests`, `p1-testing-module`, `p2-contract-tests`, `p3-load-testing`.

## Forma de cada archivo de dominio

- Primera línea `# <Dominio> — Priority P0`, después una línea de alcance: cuándo se lee.
- Una regla por `##`, ≤40 líneas, título imperativo en inglés, un par ✅/❌ de 3-10 líneas, cero
  condicionales anidados. Normativo en positivo.
- Prioridad solo en el encabezado del archivo (S10). Sin frontmatter de `priority`/`category`.
- Sin `## When to Apply`, sin overviews, sin banners.

## Tasks

| ID | Spec | Tarea | Commit |
|----|------|-------|--------|
| T1 | S1,S10 | `rules/controllers.md` + borrar `rules/controllers/` y `rules/architecture/` | C1 |
| T2 | S1,S11 | `rules/security.md` + borrar `rules/security/` | C2 |
| T3 | S1 | `rules/data.md` + borrar `rules/data/` | C3 |
| T4 | S1,D2 | `rules/auth.md` + borrar `rules/auth/` | C4 |
| T5 | S1 | `rules/api.md` + borrar `rules/api/` | C5 |
| T6 | S1 | `rules/operations.md` + borrar `rules/operations/` | C6 |
| T7 | S7 | `assets/jest.config.js` + borrar `rules/testing/` | C7 |
| T8 | S2,S3,S10 | `SKILL.md`, `README.md`, `CHANGELOG.md`, assets referenciados | C8 |
| T9 | S1,S3,S4 | Verificación estructural: conteos, presupuestos, scan, huérfanas | — |
| T10 | S5,S6,S8,S9 | Eval 5+5 corridas, 12 señales, sin degradación | — |
| T11 | S6 | Commits por dominio, push, PR con el eval en el cuerpo | C1-C8 |

## Log

L1. *"Vamos con COU-334 (proyecto skills): reducir nestjs-backend de 68 reglas a 7 archivos de
dominio. ## Antes de tocar nada, leé 1. COU-334 en Linear (contexto, scope, criterios de aceptación).
2. odd/tasks/skills-reduction.md — el plan: taxonomía, estándar de forma (S1-S11) y el detalle por
skill con el veredicto de cada regla. 3. El PR #50 (mergeado) — el mismo trabajo sobre react-frontend:
referencia de forma y de commit. ## Restricciones ya decididas - Un commit por dominio, nunca uno para
toda la skill: un candidato de cientos de archivos el reviewer lo rechaza en preflight
(lens_context_budget_exceeded). - Gate de herramientas: las reglas que pasan a ESLint se habilitan
ANTES de borrar su prosa. Si no se pueden habilitar, la regla se queda y se reporta. - Presupuestos:
SKILL.md ≤60 líneas, archivo de dominio ≤200, regla ≤40 con un único par ✅/❌. ## Secuencia
obligatoria 1. Implementar la reducción en la rama (sale del branchName de Linear). 2. Verificar
estructura: conteo de archivos, presupuestos, scan.sh exit 0, referencias sin huérfanas. 3. Correr el
eval de comportamiento (abajo). Sin este paso no hay commit. 4. Si ninguna señal empeora: commitear
por dominio, pushear, abrir PR. Si alguna empeora: NO commitear; buscar la regla perdida, corregir su
presentación y repetir el eval. ## Cómo se corre el eval con pi Base:
/home/leandrojaviercepeda/countergank/probe/nestjs-backend/ (copiá el harness de probe/react-frontend/:
run.sh, score.py y prompt.txt, y adaptá las señales a NestJS). a) Dos copias de la skill: - original:
git -C <repo> archive origin/develop skills/nestjs-backend | tar -x -C original/pkg/ - reducida:
copiar skills/nestjs-backend del worktree a reduced/pkg/skills/ b) Cinco proyectos de corrida por
condición (original/r1..r5, reduced/r1..r5). En cada uno: cp -r <cond>/.agents <dir>/.agents
(después de instalar una vez) Instalación real, una sola vez por condición: (cd <cond> && npx -y
skills add ./pkg -y --copy) Eso deja la skill en .agents/skills/ del proyecto. c) Verificar
descubrimiento antes de gastar corridas. En un proyecto: pi -p -a \"List only the names of the skills
available to you, comma separated\" Tiene que aparecer nestjs-backend. d) Correr las diez en
background, tres a la vez: printf '%s\n' original/r{1..5} reduced/r{1..5} | xargs -P 3 -n 1 ./run.sh
run.sh usa: pi -p -a --thinking minimal --session-dir \"$PWD/.sessions\" \"$(cat prompt.txt)\" y
encadena --continue si el log dice truncated o hay menos de 3 archivos. e) Puntuar con score.py: 12
señales binarias, tabla por corrida y agregado por condición. Criterio: ninguna señal puede empeorar.
Que mejore no es requisito. ## Trampas ya encontradas - pi -p da UNA respuesta: sin --continue la
tarea no termina y quedan 0 archivos. - --session-dir va con espacio, no con \"=\". - El scorer puede
dar falsos negativos (ya pasó dos veces): antes de concluir que una regla se perdió, verificá esa
señal contra el código generado a mano. Empezá leyendo el plan y el ticket, proponeme el agrupamiento
en commits y las señales del eval, y no commitees hasta que el eval esté corrido y no muestre
degradación."*

L2. *"cual te parece la mas recomendada para que sea mas intuitivo para un agente de IA?"* → D1 y D2:
seis archivos, `auth` y `security` separados por pregunta (quién llama / qué llega), para que el agente
elija el archivo desde el enunciado de la tarea sin abrir el equivocado.

L3. Auditoría medida antes de tocar: 1537 líneas, 68 archivos de regla, `scan.sh` exit 0.
Herramientas verificadas: `pi 1.4.0`, `npx -y skills add ./pkg --copy` instala en `.agents/skills/`,
el descubrimiento lista `nestjs-backend`. Baseline del probe en `probe/nestjs-backend/original/pkg`.

L4. `assets/controller-template.ts` y `assets/module-template.ts` existen sin referencia en el
`SKILL.md` (fósil del mismo tipo que `COMMIT_TEMPLATE.txt` en `github-conventions`). Se referencian en
el `SKILL.md` nuevo en lugar de borrarse.
