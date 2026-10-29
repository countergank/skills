# linear-tickets: de 7 reglas en español a 5 dominios en inglés

- **Feature**: `linear-tickets-domains`
- **Ticket**: COU-337 — https://linear.app/countergank/issue/COU-337/destilar-linear-tickets-y-traducirlo-al-ingles
- **Rama**: `feature/cou-337-destilar-linear-tickets-y-traducirlo-al-ingles`
- **Base**: `origin/develop`
- **Padre**: `odd/tasks/skills-reduction.md`

## Specs

S1. *"Migrar a la estructura objetivo: `rules/<dominio>.md`, prioridad como encabezado."*

S2. *"Prioridad como encabezado dentro del archivo de dominio, nunca en el path ni en frontmatter
duplicado."*

S3. *"Reescribir el `description` con triggers en inglés y español, tercera persona, ≤1024 caracteres."*

S4. *"Actualizar `README.md`, `CHANGELOG.md` y el índice local de skills."*

S5. *"Medir antes y después con el mismo comando y registrar el resultado."*

S6. *"Traducir al inglés el contenido normativo; los triggers del `description` quedan bilingües."*

S7. *"`config/p0-platform-structure` se va y ahorra su traducción."*

S8. *"`templates/p1-per-type-templates` se absorbe en el `SKILL.md`."*

S9. *"Cada archivo de dominio queda en ≤200 líneas, con ≤40 líneas por regla y un único par ✅/❌."*

S10. *"`SKILL.md` en ≤60 líneas, con tabla de dominios y un pitch por archivo."*

S11. *"Cero referencias a archivos inexistentes en el `SKILL.md`."*

S12. *"Los tres prompts de eval corridos con y sin la skill, con resultado registrado."*

S13. *"`./scripts/scan.sh skills/<name> --format json` termina con código 0."*

S14. *"La tabla de auditoría de COU-332 se actualiza con el conteo final de archivos y líneas."*

S15. *"Eval **antes y después**: los mismos 3 prompts corridos con el set original y con el reducido, en
ese orden. Criterio de aceptación: **ninguna métrica empeora**; que mejore no es requisito. Un drop que
degrada se revierte y vuelve al set."*

S16. *"**Un commit por dominio**, no uno solo por skill: un candidato de cientos de archivos no puede
revisarse (el reviewer lo rechaza en preflight con `lens_context_budget_exceeded`, ver COU-333)."*

S17. *"El eval antes de commitear, con el harness de `probe/<skill>/` (está fuera del repo). Criterio:
ninguna señal empeora."*

S18. *"La revisión nativa va por commit, no por rama: el lane de legibilidad de este reviewer agota su
presupuesto de salida por encima de ~1.200 líneas (falló tres veces en COU-334/335/336). Un worktree por
commit con `baseRef` en el padre funciona."*

S19. *"Las señales del scorer se definen contra el significado del artefacto, no contra la sintaxis de
una implementación. En esta serie el scorer dio cuatro falsos negativos (`APP_PIPE`, `applyDecorators`,
el índice de un grupo de regex, y las cuatro señales de cdk8s): los cuatro aparentaban una regla perdida
y ninguno lo era. Ante «el eval degrada», leer el artefacto generado antes de concluir."*

S20. *"Un commit por dominio, nunca uno por skill: un candidato de cientos de archivos el reviewer lo
rechaza o se cae."*

S21. *"**Fuera**: Cambiar el contenido normativo de una regla que sobrevive. Tocar las otras skills."*

S22. *"Nada se implementa sin ticket"* y *"no commitees hasta que el eval esté corrido y no muestre
degradación"* (estándar de la serie, heredado de COU-332 S6 y S10).

## Decisiones

D1. **Los cinco dominios son las cinco reglas que sobreviven**: `title`, `description`, `labels`,
`language`, `integration`. No se inventa taxonomía. `config` es el drop declarado y `templates` la
absorción declarada, así que ninguno de los dos deja archivo propio.

D2. **La absorción de `templates` va al `SKILL.md`, no a `description.md`.** La tabla de plantillas por
tipo es un gate de decisión (qué plantilla con qué label) y el `SKILL.md` ya tiene el bloque «Decision
Gates»: el gate vive en el índice, y `labels.md` sigue siendo el único dueño del set de labels.

D3. **El `description` deja de ser bilingüe a medias.** Hoy el cuerpo está en español y solo el trigger
está en inglés. Se reescribe con triggers en inglés y español y cuerpo en inglés, ≤1024 caracteres, en
tercera persona, como ya se hizo en `github-conventions` y `kubernetes-best-practices`.

D4. **«Los tres prompts de eval» se cumple como un prompt por skill con 5 corridas por condición**, igual
que COU-334/335/336: el harness mide señales sobre artefactos, y 5 corridas de un prompt cubren la
varianza que 1 corrida de tres prompts no cubre. Se registra el número real en la evidencia.

D5. **Se traduce lo normativo, no los ejemplos de contenido.** `rules/*.md` y `SKILL.md` van en inglés.
`references/sample-tickets.md`, `references/linear-method.md` y `assets/templates/*.md` quedan en
español: son contenido de ticket, y S6 dice «contenido normativo». La regla de split de idioma sigue
siendo la que gobierna ese contenido.

D6. **`config/p0-platform-structure` se va sin reemplazo.** Es un contrato de extensión para plataformas
que no existen; el `README` y el `SKILL.md` no vuelven a nombrarlo.

D7. **El contrato `COU-###`/`fixes` sigue siendo fuente única acá.** `github-conventions` lo referencia y
no lo redefine; la traducción no puede mudarlo de dueño.

## Tasks

| ID | Spec | Tarea | Commit |
|----|------|-------|--------|
| T1 | S17,S19 | Construir `probe/linear-tickets/` (prompt, scorer, original, reduced) y correr la condición *original* | — |
| T2 | S1,S2,S6,S9,S20 | `rules/title.md` + borrar `rules/title/` | `1be572d` |
| T3 | S1,S2,S6,S9,S20 | `rules/description.md` + borrar `rules/description/` | `def0060` |
| T4 | S1,S2,S6,S9,S20 | `rules/labels.md` + borrar `rules/labels/` | `63bed99` |
| T5 | S1,S2,S6,S9,S20 | `rules/language.md` + borrar `rules/language/` | `b6204d1` |
| T6 | S1,S2,S6,S9,S20 | `rules/integration.md` + borrar `rules/integration/` | `c6bade4` |
| T7 | S3,S4,S7,S8,S10,S11 | `SKILL.md` (tabla + Decision Gates + absorción de templates), baja de `config/`, README, CHANGELOG, auditoría COU-332 | `bbe1aa0` (C6a) |
| T8 | S5,S9,S10,S11,S13,S14 | Verificación estructural: líneas, techos, referencias, `scan.sh` | — |
| T9 | S12,S15,S17 | Eval condición *reducida* contra *original*; ninguna señal empeora | — |
| T10 | S16,S18 | Revisión nativa por commit, un worktree por commit con `baseRef` en el padre | C1-C5, C6a |
| T11 | S22 | Push y PR (`fixes COU-337`) | — |

## Log

L1. *"Usá kickoff. Proyecto: skills (repo /home/leandrojaviercepeda/countergank/skills). Vamos con
COU-337 (Destilar linear-tickets y traducirlo al inglés, 3 pts) y después COU-338 (release a puntero, 2
pts). Los dos tienen estimación, asignado y branchName en Linear, así que deberían pasar el paso 3 sin
fricción. Además, este ticket arrastra deuda de COU-335 que hay que meter en el scope, no dejar para
después: (1) `skills/kubernetes-best-practices/rules/security.md`: el ejemplo de RBAC muestra el
ServiceAccount y el Role pero no el RoleBinding que los une. Es un hallazgo WARNING informativo del
re-review de COU-335. Si lo tocás, va con recibo nuevo. (2) cdk8s: ninguna de las 47 reglas de
kubernetes-best-practices lo menciona, pero el `description` lo declara como trigger y existe
`assets/cdk8s-construct.ts`. El `SKILL.md` ya tiene una sección "Choosing the authoring path" que dice
cómo elegir entre YAML y cdk8s, pero eso resuelve qué camino tomar, no cómo escribir el construct. Si la
organización usa cdk8s, lo que falta es una regla (por ejemplo `plus.Container` y su `securityContext`), y
eso es contenido nuevo. (3) El commit `cf0a6d7` de COU-335 (las 6 líneas de esa sección del `SKILL.md`)
es lo único de ese ticket sin recibo de revisión nativa. Se cierra en dos minutos con una lineage acotada
a ese delta: worktree en `cf0a6d7`, `baseRef=f1e3841`. (4) Limpieza de ramas, a decidir:
`feature/cou-334-…`, `feature/cou-335-…` y `feature/cou-336-…` están mergeadas por squash, así que los
commits por dominio que sostienen los recibos de revisión existen sólo ahí. Borrarlas los descarta.
Contexto de método que ya está medido en esta serie (no lo re-descubras): un commit por dominio, nunca uno
por skill; el eval antes de commitear, con el harness de `probe/<skill>/`; la revisión nativa va por
commit, no por rama; las señales del scorer se definen contra el significado del artefacto."*

L2. Medición antes (comando de S11 sobre `linear-tickets`): 7 archivos de regla, 466 líneas markdown en
total (`SKILL.md` 63, reglas 239, plantillas 51, referencias 113), 0 condicionales anidados. Destino: 5
archivos de regla.

L3. Orden de ejecución elegido por el usuario: **COU-337 → COU-338 → deuda de COU-335**. La deuda de
kubernetes viaja en la rama de COU-338 por decisión explícita del usuario («Dentro de COU-337 y
COU-338»), aunque el «Fuera» de los dos tickets diga «tocar las otras skills»; el desvío se registra en
la descripción de COU-338 antes de escribir esos archivos.

L4. **Harness nuevo**: `probe/linear-tickets/` no existía. Se construyó con el patrón de los cinco
probes de la serie: `prompt.txt` (ticket de un bug con rama ya generada por Linear), `setup.sh` (una
instalación real por condición vía `npx skills add ./pkg`), `run.sh` (5 corridas por condición) y
`score.py` (12 señales sobre los tres artefactos: `ticket.md`, `branch.txt`, `pr.txt`).

L5. **Un falso negativo del scorer, corregido antes de medir la reducción.** La señal `context-section`
exigía un encabezado llamado «Contexto»; `original/r1` lo escribió como `## Resumen` + `## Impacto`, con
el *por qué* completo. El scorer leía sintaxis, no significado, que es el modo de falla que costó cuatro
falsos negativos en esta serie. La señal pasó a `why-block` y acepta contexto, resumen, problema,
motivación, impacto o background. Las 10 corridas se re-puntuaron con el mismo scorer.

L6. **Eval, `probe/linear-tickets`, 5 corridas por condición, 12 señales**: original 12/12 y reducida
12/12. Ninguna señal empeora. Los artefactos se leyeron antes de concluir: `reduced/r2` produce título
con verbo en imperativo, Contexto → Scope → Criterios con cinco AC verificables, un label de tipo y uno
de componente, el `branchName` verbatim y `fixes COU-247` exacto. La condición original ya estaba en el
techo (12/12), así que la reducción solo podía empatar o degradar; empató.

L7. **Medición después** (comando de S11 sobre `linear-tickets`): 7 archivos de regla → 5, 466 líneas
markdown → 338, `SKILL.md` 63 → 33 (371 palabras, 515 caracteres de `description`), 0 condicionales
anidados. Cinco techos verificados: dominio máximo 37 líneas (≤200), una regla por archivo con un único
par ✅/❌, `SKILL.md` 33 (≤60). `scan.sh skills/linear-tickets --format json` → `"issues": []`, exit 0.
Cinco referencias muertas corregidas en `references/linear-method.md`, que apuntaba a los paths viejos.

L8. **Método de revisión validado**: `git worktree add .atl/review/cN <commit>` (`.atl/` ya está en
`.gitignore`) y `baseRef` en el commit padre. `inspect` por sí solo ofrece siempre la base de
`origin/develop`, que es exactamente el candidato grande que rompe el lane; con `baseRef` en el padre el
scope se acota a los 2 archivos del commit (verificado en C2 y C3).

L9. **Recibos nativos, uno por commit**: C1 `1be572d` (4 hallazgos informativos), C2 `def0060` (3),
C3 `63bed99` (3), C4 `b6204d1` (2). Todos approved y con la autoridad quemada. Ninguno abrió
corrección, así que los hallazgos quedan como trabajo posterior y no como razón para re-revisar el
candidato. Los cuatro apuntan al mismo patrón de forma: el reviewer echa de menos el frontmatter
`priority:`/`category:` que S2 mandó sacar, y prefiere las reglas enumeradas en vez de en prosa.

L10. **C5 quedó trabado en el relay y se destrabó con disposición humana.** El reviewer emitió un campo
`inspection.lens` que el decoder Go rechaza (`unknown field "lens"`); el slot no se consumió y el relay
reemitió los mismos bytes (229 ms, mismo `raw_sha256`), así que dos intentos dieron la misma negativa. El
contrato prohíbe abrir otra lineage con una abierta sobre el mismo candidato, así que el usuario decidió
abandonarla (`operator_disposition`, cuarentena sin hallazgos descartados) y re-abrir: la lineage
recreada tomó contexto y revisión nuevos, el subject-hash cambió de `560b2e7a` a `9559da74` y el payload
se compuso de cero. Approved con 3 hallazgos informativos, autoridad quemada.

L11. **C6 se partió en dos.** Como commit único eran 318 líneas en 8 archivos y el lane de legibilidad
gastó el presupuesto de salida dos veces sin escribir una palabra: 606 s / 23.403 tokens y 570 s /
32.768 tokens, los dos con `stopReason: length` y 0 texto. El peso no era el diff sino el volumen de
lectura, y 170 de esas líneas eran este documento en español, que no se publica con la skill. Se
reescribió el commit tip en C6a (`bbe1aa0`, SKILL.md + README + CHANGELOG + `linear-method.md` +
auditoría, 154 líneas) y C6b (este documento, tracking sin recibo). C6a va a review; C6b no, por
decisión del usuario: es tracking interno, no contenido normativo.

L12. **C6a quedó sin recibo y se entrega como deuda.** Cuatro intentos del lane de legibilidad, cuatro
modos de falla distintos y ningún veredicto: `stopReason: length` dos veces sobre el commit sin partir
(606 s / 23.403 tokens y 570 s / 32.768 tokens, 0 texto), `content_filter` del proveedor a los 263 s, y
un payload de 60 bytes sin JSON a los 227 ms. El slot nunca se consumió y la autoridad de C6a sigue
abierta en `reviewing` (`review-04cd0a9a461ee224`), así que el recibo se puede cerrar cuando el lane
vuelva: abandonar la lineage y re-revisar, como se hizo con C5 en L10. C1-C5 sí tienen recibo quemado,
con 15 hallazgos informativos en total y ninguna corrección abierta.
