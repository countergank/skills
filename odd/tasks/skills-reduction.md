# Reducción de las skills al mínimo indispensable

- **Feature**: `skills-reduction`
- **Ticket**: COU-332 — https://linear.app/countergank/issue/COU-332/reducir-las-siete-skills-al-minimo-indispensable-de-reglas
- **Rama**: `feature/cou-332-reducir-las-siete-skills-al-minimo-indispensable-de-reglas`
- **Base**: `origin/develop`

## Specs

S1. *"otro mapeo completo de las skills actuales para reducirlas al minimo indispensable, actualmente
tienen demasiado texto y condiciones que los agentes no leen y no aplical"*. El recorte es de forma y
cantidad, no de contenido normativo: ninguna regla que sobrevive cambia de fondo en este ticket.

S2. *"a grandes rasgos tenemos actualmente en el repo de skills dos tipos de skills, procedurales y de
herramienta, por eso la distincion tan diferenciada con la estructura entre una y otra"*. La estructura
se elige por tipo, no por simetría: procedimental → un archivo con pasos; catálogo → un archivo por dominio.

S3. *"revisemos siempre en internet que es la recomendacion logrando un balance entre rendimiento y
costo"*. Toda decisión de forma se contrasta contra una fuente publicada, y el balance costo/rendimiento
se declara explícitamente: check determinista (cero tokens, corre en cada commit) contra regla en el
prompt (tokens en cada carga, cumplimiento probabilístico).

S4. *"si el archivo debe tener convenciones entonces lo tenemos que crear"*. Una referencia del
`SKILL.md` a un asset ausente se corrige creando el asset, no borrando la referencia.

S5. Una regla sobrevive solo si corrige una práctica no estándar que el agente no haría por default.
Si una herramienta ya la verifica, se mueve a la herramienta; si el modelo ya la cumple, se elimina.

S6. Ninguna regla se borra antes de que su check corra en CI del proyecto destino. Primero se habilita
el check, después se borra la regla.

S7. Cada archivo de dominio queda en ≤200 líneas, con ≤40 líneas por regla y un único par ✅/❌ por regla.
`SKILL.md` ≤60 líneas y ≤450 tokens, con tabla de dominios y un pitch por archivo.

S8. La prioridad se escribe una sola vez, como encabezado dentro del archivo de dominio. Nunca en el
path ni duplicada en frontmatter.

S9. Las reglas nuevas se escriben en positivo: declaran qué se hace o qué se documenta, no qué se prohíbe.

S10. Cada ticket derivado incluye un eval de tres prompts corridos **con el set original y con el set
reducido**, en ese orden. El criterio es que **ninguna métrica empeore**; que mejore no es requisito. Un
drop que degrada se revierte y vuelve al set.

S11. La medición antes/después usa este comando, idéntico en las dos versiones y sobre el mismo árbol, y
su resultado se registra en la tabla de auditoría de este documento:

```bash
find skills/<name> -name '*.md' | xargs wc -l    # líneas totales
find skills/<name>/rules -name '*.md' | wc -l    # cantidad de archivos de regla
grep -rc "si .* y no .* salvo" skills/<name>     # condicionales anidados
```

## Taxonomía

| Tipo | Skills | Estructura | Por qué |
|---|---|---|---|
| **Procedimental** | `kickoff` | Un archivo, pasos secuenciales, ≤200 líneas | Cada paso depende del anterior; partirlo crea referencias ciegas entre fragmentos del mismo procedimiento y cada fragmento falla S5 por separado |
| **Catálogo** | `react-frontend`, `nestjs-backend`, `kubernetes-best-practices`, `github-conventions`, `linear-tickets`, `git-environment-flow` | `rules/<dominio>.md`, un nivel | Las reglas son independientes entre sí; un solo archivo produce context bloat y un árbol por categoría produce navegación innecesaria |

## Estándar de forma

| Decisión | Valor | Respaldo |
|---|---|---|
| `SKILL.md` | ≤60 líneas, ≤450 tokens | Guía de autoría de Anthropic (≤500 líneas) y spec Agent Skills (~5000 tokens), más estricto |
| Archivo de dominio | ≤200 líneas | Único umbral documentado: >300 líneas exige tabla de contenidos |
| Regla | ≤40 líneas, una idea | Concisión: cada token compite con el resto del contexto |
| Ejemplos | Un par ✅/❌, código de 3 a 10 líneas | Los ejemplos calibran el nivel de detalle mejor que la prosa |
| Referencias | Un nivel de profundidad | Spec: evitar cadenas de referencia anidadas |
| Prohibido | Overviews, "When to Apply" largos, banners, condicionales anidados | Las instrucciones se siguen; las introducciones no aportan |
| Idioma | Inglés normativo; triggers del `description` en inglés y español | Consistencia con el ecosistema; el español queda en tickets y PRs |

## Auditoría

| Skill | Tipo | `SKILL.md` | Palabras | Reglas | keep | tool | merge | drop | Destino |
|---|---|---|---|---|---|---|---|---|---|
| `react-frontend` | catálogo | 76 | ~12.100 | 87 | 32 | 17 | 7 | 31 | 10 archivos |
| `nestjs-backend` | catálogo | 67 | ~6.200 | 68 | 19 | 1 | 10 | 38 | 7 archivos |
| `kubernetes-best-practices` | catálogo | 75 | ~6.900 | 67 | 24 | 11 | 20 | 5 | 7 archivos |
| `github-conventions` | catálogo | 51 | ~5.000 | 14 | 3 | 1 | 0 | 10 | 3 archivos |
| `linear-tickets` | catálogo | 63 | ~2.750 | 7 | 6 | 0 | 1 | 1 | 5 archivos |
| `git-environment-flow` | catálogo | 49 | ~4.000 | 6 | 5 | 1 | 0 | 1 | 5 archivos |
| `kickoff` | procedimental | 161 | ~1.195 | 0 | — | — | — | — | 1 archivo |

Los baldes no suman la columna Reglas en tres filas, y se deja dicho en lugar de forzar el número:
`kubernetes-best-practices` clasifica 60 de 67 archivos (7 sin clasificar), y `linear-tickets` y
`git-environment-flow` cuentan la fila del `SKILL.md` dentro de keep, por eso suman uno más. Cada ticket
derivado vuelve a contar antes de borrar con el comando de S11, y ese conteo es el que vale.

### Detalle por skill

Los paths son relativos a `skills/<skill>/`. Las reglas que sobreviven son el complemento de las listadas.

**react-frontend** — 31 drops: `reduced-data-prefers`, `compound-components`, `single-responsibility`,
`custom-hooks`, `state-lifting`, `fluid-typography`, `layout-shift`, `react-cache-dedup`,
`serialization-minimal`, `activity-component`, `hoist-static-jsx`, `server-client-boundary`,
`lazy-state-init`, `naming-conventions`, `refs-mutable-state`, `esm-imports`, `as-const`,
`readonly-props`, `declaration-merging`, `i18n-ready`, `url-reflects-state`, `design-token-system`,
`env-variables`, `path-aliases`, `hmr-config`, `proxy-config`, `test-structure`, `testing-library`,
`test-colocation`, `user-event`, `integration-tests`.
17 tools: `alt-text`, `eslint-a11y-ci`, `labels-controls`, `no-accesskey-autofocus`, `lang-attribute`,
`autocomplete-valid`, `click-keyboard`, `conditional-rendering`, `hooks-rules`, `displayname`,
`no-dangerously-set-html`, `strict-mode`, `error-instances`, `nullish-coalescing`,
`no-non-null-assertions`, `optional-chaining`, `coverage-thresholds`.
7 merges: `landmarks`→`semantic-html`, `code-splitting-routes`→`dynamic-imports`,
`preconnect-hints`→`preload-strategies`, `extract-components`→`single-responsibility`,
`touch-friendly`→`target-size`, `concurrent-features`→`transitions-deferred`,
`build-optimization`→`vite.md`.
2 reescrituras: `forwardref-deprecated` (discriminador React 19 vs ≤18) y `advanced-caching` (acotada a
`staleTime`/`gcTime` y `Cache-Control`, sin `React.cache`).

**nestjs-backend** — 38 drops, 10 merges, 1 tool (`coverage-thresholds` → Jest + CI, adopción a verificar).
Fusiones: `dto-validation`+`validation-pipe`→`security.md`; `batch-operations`, `select-columns`→`data.md`;
`response-types`→`openapi-swagger`; `module-organization`, `controller-file-structure`,
`endpoint-decorators`→`controllers.md`; `audit-logging`→`logging`; `fastify-adapter`→Quick Reference.
Se va `csrf-protection`: recomienda `csurf`, deprecado.

**kubernetes-best-practices** — 5 drops, 20 merges, 11 tools (Polaris, kubeconform, checkov, PSS:
**adopción no verificada**). Contradicción a resolver: `cpu-limits` (ratio 2-5x) contra
`target-cpu-memory-ratio` (1.5-2x).

**github-conventions** — 10 drops, 3 keeps (`branch-naming`, `branch-lifecycle`, `issue-linking`),
1 tool (`changelog-automation` → release-please). Las cinco reglas de commit descartadas se destilan en
`rules/commit.md` con lo que es decisión del repo (tipos, scopes, 50/72) y se crea
`assets/COMMIT_TEMPLATE.txt`, hoy referenciado y ausente. Fuentes: Conventional Commits v1.0.0 y las
siete reglas de Chris Beams.

**linear-tickets** — 1 drop (`config/platform-structure`, especulativa), 1 merge
(`per-type-templates`→Decision Gates del `SKILL.md`), 6 keeps. Traducción: ~235 líneas en scope después
del recorte.

**git-environment-flow** — 1 drop (`deployment-tracking`, genérico), 1 tool
(`release-automation` → puntero a `assets/release.sh`, que ya implementa el procedimiento), 5 keeps.

**kickoff** — sin cambios de estructura. Sus 161 líneas están dentro del techo del tipo procedimental.

## Conflictos y duplicados

Los conflictos de esta lista no se repiten en el detalle por skill: ahí solo constan las fusiones que no
implican contradicción.

1. `kubernetes-best-practices`: ratios de CPU contradictorios entre `p0-cpu-limits` y
   `p1-target-cpu-memory-ratio`. Dueño propuesto: `resource-management.md`, unificado.
2. `nestjs-backend`: `p1-dto-validation` duplica `p0-validation-pipe`. Dueño: `security.md`.
3. `kubernetes-best-practices`: `p3-no-image-digest` ≡ `p2-image-version-comments`; `p0-no-root-user` ≡
   `p0-run-as-non-root`; `p1-missing-probes` ≡ probes de reliability. Un dueño por familia.
4. `github-conventions`: `p0-type-definitions` duplica la tabla de tipos del `SKILL.md`.
5. `linear-tickets`: `p1-per-type-templates` duplica la tabla Decision Gates.
6. `git-environment-flow`: la excepción "hotfix salta staging pero no review" está en tres archivos.
   Dueño: `rules/hotfix.md`.
7. Fósil: `github-conventions/SKILL.md` referencia `assets/COMMIT_TEMPLATE.txt`, que no existe.

## Evidencia medida

Eval de `code-comments` (COU-331), 9 corridas en tres condiciones: sin skill 33 comentarios y 0/3 con
JSDoc completo; con skill 12 y 3/3; sin la regla de referencias 11,3 y 3/3. Respalda S5 con una
medición propia, con límites explícitos: un modelo, una tarea, tres corridas por condición.


## Riesgo abierto

El plan borra 86 reglas apoyado en un juicio —"está en la doc del framework, el agente ya lo hace"— que
solo se validó en un caso medido (`references.md`, ablación de tres corridas). Las otras 85 son hipótesis.
Por eso S10 exige el eval antes/después con criterio de no degradación: es la única forma de que un drop
equivocado se detecte antes de mergear y no seis meses después. Donde el riesgo es bajo por cantidad de
drops (`linear-tickets` 1, `git-environment-flow` 1, `kubernetes` 5) el eval puede acotarse; donde es alto
(`react-frontend` 31, `nestjs-backend` 38) no.

## Tickets derivados

| Ticket | Skill | Est. |
|---|---|---|
| COU-333 | `react-frontend` | 5 |
| COU-334 | `nestjs-backend` | 5 |
| COU-335 | `kubernetes-best-practices` | 5 |
| COU-336 | `github-conventions` | 3 |
| COU-337 | `linear-tickets` | 3 |
| COU-338 | `git-environment-flow` | 2 |

## Tasks

| ID | Spec | Tarea | Estado |
|----|------|-------|--------|
| T1 | S1 | Auditar `react-frontend` (87 reglas) | hecho |
| T2 | S1 | Auditar `nestjs-backend`, `kubernetes-best-practices`, `github-conventions` | hecho |
| T3 | S1 | Auditar `linear-tickets`, `git-environment-flow`, `kickoff` | hecho |
| T4 | S3 | Contrastar el estándar contra las fuentes publicadas | hecho |
| T5 | S1-S4 | Resolver los cuatro casos dudosos y la taxonomía | hecho |
| T6 | S7-S10 | Escribir este documento y emitir los seis tickets derivados | hecho |
| T7 | S6 | Declarar el gate de adopción en cada ticket derivado | hecho |

## Log

L1. *"Posterior a esta skill vamos a tener que hacer otro mapeo completo de las skills actuales para
reducirlas al minimo indispensable, actualmente tienen demasiado texto y condiciones que los agentes no
leen y no aplical, esto va en otro ticket pero ya lo emciono"* (sic).

L2. *"a grandes rasgos tenemos actualmente en el repo de skills dos tipos de skills, procedurales y de
herramienta, por eso la distincion tan diferenciada con la estr uctura entre una y otra"* (sic).

L3. *"1. revisemos siempre en internet que es la recomendacion logrando un balance entre rendimiento y
costo / 2. ok esto lo tenemos que corregir, si el archivo debe tener convenciones entonces lo tenemos
que crear, a grandes rasgos esta skill se creo a partir de convenciones de github que son publicas,
buscalas en internet"* (sic).

L4. `forwardRef` y `advanced-caching` se reescriben en lugar de eliminarse: en React ≤18 pasar `ref` como
prop no adjunta nada y rompe en silencio; `advanced-caching` mezclaba RSC con caché HTTP y tenía una
referencia rota.

L5. La auditoría recomendó no partir `kickoff`; la decisión original se revirtió con ese argumento.
