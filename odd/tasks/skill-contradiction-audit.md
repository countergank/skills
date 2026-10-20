# Auditoría de contradicciones en las skills

- **Feature**: `skill-contradiction-audit`
- **Ticket**: COU-314 — https://linear.app/countergank/issue/COU-314/reescribir-kickoff-y-corregir-las-contradicciones-de-las-siete-skills
- **Rama**: `feature/cou-314-reescribir-kickoff-y-corregir-las-contradicciones-de-las`
- **Base**: `origin/develop`

## Specs

S1. Se auditan las siete skills del repo (`kickoff`, `linear-tickets`, `github-conventions`,
`git-environment-flow`, `nestjs-backend`, `react-frontend`, `kubernetes-best-practices`),
archivo por archivo: `SKILL.md`, `rules/**`, `assets/**`, `references/**`.

S2. Cada contradicción se reporta con la cita textual de las dos afirmaciones que chocan y su
`path:line`. Sin cita no hay hallazgo.

S3. Cada hallazgo se clasifica como `auto` (una de las dos fuentes es la autoridad declarada, o
la práctica del repo lo decide) o `decisión` (las dos son defendibles y la elección es de la
persona).

S4. Se corrigen todos los `auto`. Los `decisión` se frenan y se presentan juntos, con
recomendación, antes de tocar nada.

S5. Después de corregir, ninguna afirmación del repo contradice a otra: grep dirigido sobre los
temas corregidos da cero, y los archivos tocados se releen completos.

S6. Un resumen (`SKILL.md`) no redefine una regla: la nombra y apunta al archivo que la define.

S7. `./scripts/scan.sh <skill>` queda en exit 0 para cada skill tocada.

S8. Nada se commitea sin autorización explícita de la persona.

## Tasks

| ID | Spec | Tarea | Ruta | Commit |
|----|------|-------|------|--------|
| T1 | S1-S2 | Auditar el cluster de gobierno: kickoff, linear-tickets, github-conventions, git-environment-flow | delegado | — |
| T2 | S1-S2 | Auditar nestjs-backend | delegado | — |
| T3 | S1-S2 | Auditar react-frontend | delegado | — |
| T4 | S1-S2 | Auditar kubernetes-best-practices | delegado | — |
| T5 | S3-S4 | Consolidar hallazgos y separar `auto` / `decisión` | inline | — |
| T6 | S4 | Corregir los `auto` | inline | — |
| T7 | S4 | Presentar las `decisión` con recomendación y frenar | inline | — |
| T8 | S5-S7 | Verificar: grep dirigido, relectura completa y scan | inline | — |

Los IDs de commit se completan cuando la persona los autorice.

## Log

L1 (pedido original, textual):
"creo que lo mejor seria usar ODD para hacer una verificacion formal de todas las contradicciones en cada una de las skills y corregir todo"

L2 (decisiones previas que enmarcan la auditoría, textuales de la persona):
- Rama: "branchName de Linear, tal cual".
- Estimación: "Habilitar estimaciones en Linear (fibonacci)".
- Commits: "AGENTS.md global + por repo + hook".
- Selección de ticket: "Continuidad → prioridad → preguntar".
- "todavia no commitees" (vigente).

L3 (evidencia que originó la auditoría): el flujo de promoción estaba definido de dos formas
incompatibles dentro de `git-environment-flow` (cadena lineal vs bifurcación). La práctica de
los repos lo resolvió: `api-user` #415 `release/1.2.0` → `staging` y #416 `release/1.2.0` →
`main`. Los PR #342 (`feat/...` → `main`) y #343 (`develop` → `main`) quedan como violaciones
históricas del modelo.

## Hallazgos

37 hallazgos: 21 `auto` corregidos, 16 `decisión` pendientes.

### Corregidos (`auto`)

| Skill | Hallazgo |
|---|---|
| linear-tickets | SKILL.md se contradecía sobre quién es la fuente única del contrato `COU-###` |
| linear-tickets | `sample-tickets.md` enseñaba ramas compuestas a mano (`fix/COU-042-...`) |
| git-environment-flow | `main` decía "multiple approvals" contra la tabla y el resto del skill (1 reviewer) |
| git-environment-flow | `assets/` se declaraba "reserved for future" con `release.sh` ya publicado |
| nestjs-backend | tabla de prioridades sin la fila P1 Architecture: 65 contra 68 archivos reales |
| nestjs-backend | ejemplo de error sin el campo `error` que el propio contrato declara |
| react-frontend | `next: { revalidate }` (Next.js) en un skill declarado Vite SPA |
| react-frontend | `const [a, b] = useDeferredValue(x)`: API inválida |
| react-frontend | `preload` en el `Do` contra `prefetch` en el ejemplo |
| react-frontend | `@media` con `var()`, mecanismo imposible en CSS |
| react-frontend | import `@/assets/RouteAnnouncer` que no resuelve en ninguna app |
| react-frontend | tabla P1 `react` nombraba reglas inexistentes (error boundaries, Suspense) |
| kubernetes | `cdk8s-construct.ts` armaba el límite de memoria desde el request (prop muerta) |
| kubernetes | el asset caía en `latest` cuando la imagen no tenía tag |
| kubernetes | SKILL.md prometía Ingress en un construct que no lo tiene |
| kubernetes | probes de liveness y readiness idénticos en MongoDB |
| kubernetes | asset MongoDB sin el hardening que sus propias reglas P0 exigen |
| kubernetes | header prometía backup sidecar que estaba comentado |
| kubernetes | referencia a `p0-run-as-non-root.md` en el ejemplo de SealedSecret |
| kubernetes | título "No Image Digest Pinning" contra el cuerpo que exige pinnear |
| kubernetes | fila P2 "image version comments" contra el archivo real (digests) |

### Decisiones aplicadas (`decisión`)

Las 16 se aplicaron con las recomendaciones; el detalle del cierre está en L4.

| ID | Skill | Conflicto | Recomendación |
|---|---|---|---|
| D1 | github-conventions | Asunto de commit: mayúscula inicial vs minúscula | Minúscula (Conventional Commits 1.0.0) |
| D2 | git-environment-flow | Hotfix: bypass de reviews en `main` vs PR + 1 reviewer | Mantener PR + 1 reviewer en `main` |
| D3 | nestjs-backend | ValidationPipe global (P0) vs `@UsePipes` por ruta (P1 y asset) | Global normativo; por ruta como excepción documentada |
| D4 | nestjs-backend | Fastify recomendado, ejemplos de helmet/logging con `app.use` de Express | Nota de plataforma + equivalentes Fastify |
| D5 | nestjs-backend | P0 evita `@Inject()`; P3 lo exige para `forwardRef` | Excepción explícita para `forwardRef` |
| D6 | nestjs-backend | QueryBuilder permitido o no en servicios | Aclarar que los ejemplos viven en el repositorio |
| D7 | react-frontend | Target táctil 44px vs 24px (WCAG 2.5.5 AAA vs 2.5.8 AA) | 24 normativo, 44 recomendado |
| D8 | react-frontend | Skill dice SPA Vite; tres reglas son RSC-only | Mantener SPA y etiquetar las RSC como condicionales |
| D9 | react-frontend | Cobertura 75/85 istanbul vs asset 80/80 v8 | El asset es la fuente; la regla lo referencia |
| D10 | react-frontend | Import `ReactComponent` de svgr sin `exportType: 'named'` | Documentar la config o usar export default |
| D11 | kubernetes | `pullPolicy: Always` con "e.g. latest" leído como aval del tag mutable | Reformular sin nombrar `latest` como aceptable |
| D12 | kubernetes | MongoDB 4Gi/4Gi (límite = request) vs P0 1.5-2x | Igualdad con nota explícita para bases de datos |
| D13 | kubernetes | `--wiredTigerCacheSizeGB` exigido y ausente en el asset | Setearlo explícito |
| D14 | kubernetes | Ejemplos con `mongo:7.0` crudo vs asset con operador MongoDBCommunity | Unificar en operador + imagen community-server |
| D15 | kubernetes | Readiness de Mongo sin auth; merge de securityContext depende del operador | Definir secretos y chequeo autenticado, o documentar que el operador maneja probes |
| D16 | repo (verificación) | El gate del repo exige `scan.sh` en 0, pero `react-frontend` sale 1 ya en `origin/develop` (91/CRITICAL, mismas 4 issues: `permissions` ausente, `analytics.example.com`, dos `dangerouslySetInnerHTML` del archivo que los prohíbe) | Agregar `permissions` al frontmatter o reformular los ejemplos que disparan el escáner; decidir si el gate se relaja |

## Estado

T1-T4 hechos (cuatro auditorías delegadas). T5-T6 hechos (21 `auto` corregidos). T7-T8 hechos
(D1-D16 presentadas, verificadas y aplicadas). Scan final de las siete skills en exit 0;
`react-frontend` bajó de 91/CRITICAL a 13/LOW. Nada commiteado.

L4 (cierre de decisiones):
- D1-D2 aplicadas: asunto de commit en minúscula; hotfix mantiene PR + 1 reviewer en `main` y
  solo saltea el camino de staging.
- D3-D6 aplicadas: pipe global normativo, notas de plataforma Fastify, excepción `forwardRef`,
  QueryBuilder dentro del repositorio.
- D7-D10 aplicadas: 24px normativo / 44px recomendado, reglas RSC marcadas como condicionales,
  cobertura con el asset como fuente única, config `exportType: "named"` documentada.
- D11-D15 aplicadas: pull policy sin avalar `latest`, nota de límites para bases de datos,
  WiredTiger 1Gi, imagen `mongodb/mongodb-community-server:7.0` en las seis reglas, y notas de
  readiness sin auth y del merge del operador.
- D16 aplicada: `permissions: [read-files, write-files]` (no `network`: era un falso positivo
  del comentario "requests" en `assets/vite.config.ts`, rewordeado), ejemplos reformulados y
  scan en 0.
- Ajustes de coherencia del cierre: la imagen vieja aparecía también en `p1-tls-required.md` y
  `p2-mongodb-exporter.md` (corregidas), y el titulo de la sección de hotfix pasó a "What
  Hotfixes Skip".

L5 (corrección de configuración, posterior a L2): la escala quedó en `linear` 1-5, no fibonacci,
con `issueEstimationAllowZero: false` y `defaultIssueEstimate: 1`. COU-314 quedó estimado en 5.
Vaciar `defaultIssueEstimate` por API falla (`defaultIssueEstimate should not be null`): solo se
puede dejar sin valor desde la UI de Linear. Decisión: el agente propone la estimación con una
línea de fundamento y la persona la confirma; nunca la autoasigna.

L6 (ticket y rama alineados al alcance real): el ticket se retituló a "Reescribir kickoff y
corregir las contradicciones de las siete skills" con la descripción reescrita (Contexto → Scope
→ Criterios, 9 criterios cumplidos y 2 pendientes). Linear recalculó `branchName`, así que la rama
local se renombró al nuevo valor; la anterior ya no existe. Sin commits ni push, el cambio no
afecta historial.
