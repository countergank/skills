# kubernetes-best-practices: de 67 reglas a 7 archivos de dominio

- **Feature**: `kubernetes-domains`
- **Ticket**: COU-335 — https://linear.app/countergank/issue/COU-335/reducir-kubernetes-best-practices-de-67-reglas-a-7-archivos
- **Rama**: `feature/cou-335-reducir-kubernetes-best-practices-de-67-reglas-a-7-archivos`
- **Base**: `origin/develop`
- **Padre**: `odd/tasks/skills-reduction.md`

## Specs

S1. *"Cada archivo de dominio queda en ≤200 líneas, con ≤40 líneas por regla y un único par ✅/❌."*

S2. *"`SKILL.md` en ≤60 líneas, con tabla de dominios y un pitch por archivo."*

S3. *"Cero referencias a archivos inexistentes en el `SKILL.md`."*

S4. *"`./scripts/scan.sh skills/<name> --format json` termina con código 0."*

S5. *"Eval **antes y después** ... ninguna métrica empeora."*

S6. *"**Un commit por dominio**."*

S7. *"Gate de herramientas: las reglas que pasan a una herramienta se habilitan ANTES de borrar su
prosa. Si no se pueden habilitar, la regla se queda y se reporta."*

S8. *"no commitees hasta que el eval esté corrido y no muestre degradación."*

## Decisiones

D1. **Los siete archivos son las siete categorías que ya existen**: `security`, `reliability`,
`mongodb`, `resource-management`, `observability`, `naming-labels`, `anti-patterns`. No se inventa
taxonomía ni se renombran directorios.

D2. **Ratios unificados**: CPU 2-5x y memoria 1.2-1.5x en una sola regla de `resource-management.md`.
Se van el 1.5-2x de CPU de `p1-target-cpu-memory-ratio` y el 1.5-2x de memoria de `p0-memory-limits`.
Motivo: CPU es compresible y el límite produce throttling, no muerte, así que un techo alto habilita
ráfagas; memoria no es compresible y un límite muy por encima del request solo retrasa el OOM kill.

D3. **Las 11 tool rules se quedan como prosa** y el gate se reporta como no habilitado.
`references/polaris-default.yaml` documenta los checks por defecto de Polaris, pero es una referencia,
no un gate que corra; este repo no tiene manifiestos ni cluster y un workflow que lintée la nada sería
ceremonia. Consecuencia: ningún drop sale de ese balde y los archivos quedan más grandes.

D4. **Cinco drops**, los tres que la auditoría marcó como duplicados literales más dos que un linter
cubre mejor que la prosa: `anti-patterns/p0-no-root-user` (≡ `security/p0-run-as-non-root`),
`anti-patterns/p1-missing-probes` (≡ las tres probes de reliability), `anti-patterns/p3-no-image-digest`
(≡ la regla de pinning), `anti-patterns/p1-no-default-namespace` (kube-linter lo verifica) y
`observability/p2-cost-allocation` (≡ la regla de labels).

D5. Assets y references no se tocan: los cinco assets y las tres references están referenciados desde
el `SKILL.md`. Si un archivo de dominio necesita un ejemplo, lo escribe; no agrega assets nuevos.

## Veredicto por archivo

**`rules/security.md`** — 11 reglas, todas sobreviven:
non-root (`p0-run-as-non-root`, absorbe `anti-patterns/p0-no-root-user`), drop capabilities,
no privilege escalation, read-only root fs, host namespaces off (absorbe
`anti-patterns/p0-no-privileged`), automount service token, seccomp profile, network policies,
RBAC least privilege, sealed secrets, pod security admission.

**`rules/reliability.md`** — 8 reglas:
todas las probes (liveness + readiness + startup, absorbe `anti-patterns/p1-missing-probes`);
dos réplicas mínimo; PodDisruptionBudget; repartir réplicas (absorbe `p1-topology-spread` y
`mongodb/p1-anti-affinity`); priority class; termination grace period; pinning por digest (absorbe
`anti-patterns/p0-no-latest-tag`, `anti-patterns/p3-no-image-digest` y
`resource-management/p1-image-pull-policy`); revision history limit.

**`rules/mongodb.md`** — 9 reglas: auth habilitada, PVC con Retain, StatefulSet obligatorio,
backup programado, TLS obligatorio, WiredTiger cache a la mitad del límite de memoria, número impar de
miembros sin árbitros en producción, pool de conexiones acotado, exporter de métricas.
(`p1-anti-affinity` se va a reliability.)

**`rules/resource-management.md`** — 5 reglas: requests y límites en cada contenedor (absorbe
`p0-resource-requests` y `p0-resource-limits`), ratio límite/request con los números de D2, HPA,
ResourceQuota por namespace, LimitRange.

**`rules/observability.md`** — 5 reglas: logs estructurados a stdout (absorbe
`p0-container-logging`), métricas en puerto nombrado y anotaciones de scrape (absorbe
`p0-pod-annotations-scrape`), ServiceMonitor con labels de selección, PrometheusRule con SLOs y
runbooks, propagación de contexto de trazas. (`p1-dashboard-labels` se va a naming-labels.)

**`rules/naming-labels.md`** — 6 reglas: `app.kubernetes.io/name` (absorbe
`observability/p1-dashboard-labels`), `app.kubernetes.io/instance`, namespaces por entorno y equipo,
selector del Service en sincronía con las labels del pod, `component`/`part-of`/`managed-by` en una
regla, `version`.

**`rules/anti-patterns.md`** — 3 reglas: nada de estado en `emptyDir`, nada de `hostPath`, nada de
`NodePort` en producción. Es el archivo de "esto no entra a producción nunca"; las tres restantes se
absorben o se van según D4.

Total: 47 reglas en 7 archivos, desde 67.

## Tasks

| ID | Spec | Tarea | Commit |
|----|------|-------|--------|
| T1 | S1 | `rules/security.md` + borrar `rules/security/` | C1 |
| T2 | S1 | `rules/reliability.md` + borrar `rules/reliability/` | C2 |
| T3 | S1 | `rules/mongodb.md` + borrar `rules/mongodb/` | C3 |
| T4 | S1,D2 | `rules/resource-management.md` + borrar `rules/resource-management/` | C4 |
| T5 | S1 | `rules/observability.md` + borrar `rules/observability/` | C5 |
| T6 | S1 | `rules/naming-labels.md` + borrar `rules/naming-labels/` | C6 |
| T7 | S1,D4 | `rules/anti-patterns.md` + borrar `rules/anti-patterns/` | C7 |
| T8 | S2,S3 | `SKILL.md`, `README.md`, `CHANGELOG.md`, auditoría | C8 |
| T9 | S1,S3,S4 | Verificación estructural | — |
| T10 | S5,S8 | Eval 5+5, 12 señales | — |
| T11 | S6 | Commits por dominio, push, PR | C1-C8 |

## Log

L1. *"ok vamos"* → kickoff eligió COU-335, el derivado más grande de COU-332.

L2. Decisiones D2 y D3 tomadas por el usuario antes de escribir: ratios CPU 2-5x / memoria 1.2-1.5x y
las 11 tool rules como prosa con el gate reportado como no habilitado.

L3. Auditoría previa: 67 reglas, 2.054 líneas de markdown, `SKILL.md` de 75, 5 assets y 3 references
todos referenciados. Siete exploradores mapearon duplicados entre categorías; el mapa confirma los
cinco drops de D4 y las absorciones de cada archivo.
