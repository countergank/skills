# git-environment-flow: 6 reglas a 4 dominios, release como puntero

- **Feature**: `git-environment-flow-domains`
- **Ticket**: COU-338 — https://linear.app/countergank/issue/COU-338/colapsar-la-automatizacion-de-release-a-un-puntero-de
- **Rama**: `feature/cou-338-colapsar-la-automatizacion-de-release-a-un-puntero-de`
- **Base**: `origin/develop` (`174ba7f`)
- **Padre**: `odd/tasks/skills-reduction.md`
- **Arrastra**: deuda de COU-335 (items 1 y 2), por decisión del usuario; el scope quedó enmendado en la
  descripción de COU-338.

## Specs

S1. *"Migrar a la estructura objetivo: `rules/environment.md`, `promotion.md`, `hotfix.md`, `release.md`
y un solo dueño para la excepción de hotfix."*

S2. *"Prioridad como encabezado dentro del archivo de dominio, nunca en el path ni en frontmatter
duplicado."*

S3. *"Reescribir el `description` con triggers en inglés y español, tercera persona, ≤1024 caracteres."*

S4. *"Actualizar `README.md`, `CHANGELOG.md` y el índice local de skills."*

S5. *"Medir antes y después con el mismo comando y registrar el resultado."*

S6. *"La regla de release dice "ejecutá `release.sh`", no cómo hacer un release."*

S7. *"La excepción "hotfix salta staging pero no review" queda en un solo archivo y las demás la
referencian."*

S8. *"Cada archivo de dominio queda en ≤200 líneas, con ≤40 líneas por regla y un único par ✅/❌."*

S9. *"`SKILL.md` en ≤60 líneas, con tabla de dominios y un pitch por archivo."*

S10. *"Cero referencias a archivos inexistentes en el `SKILL.md`."*

S11. *"Los tres prompts de eval corridos con y sin la skill, con resultado registrado."*

S12. *"`./scripts/scan.sh skills/<name> --format json` termina con código 0."*

S13. *"La tabla de auditoría de COU-332 se actualiza con el conteo final de archivos y líneas."*

S14. *"Eval **antes y después**: los mismos 3 prompts corridos con el set original y con el reducido, en
ese orden. Criterio de aceptación: **ninguna métrica empeora**; que mejore no es requisito."*

S15. *"**Un commit por dominio**, no uno solo por skill."*

S16. *"El eval antes de commitear, con el harness de `probe/<skill>/` (está fuera del repo). Criterio:
ninguna señal empeora."*

S17. *"La revisión nativa va por commit, no por rama: ... Un worktree por commit con `baseRef` en el
padre funciona."*

S18. *"`skills/kubernetes-best-practices/rules/security.md`: el ejemplo de RBAC muestra el ServiceAccount
y el Role pero no el RoleBinding que los une. Es un hallazgo WARNING informativo del re-review de
COU-335. Si lo tocás, va con recibo nuevo."*

S19. *"cdk8s: ninguna de las 47 reglas de kubernetes-best-practices lo menciona, pero el `description` lo
declara como trigger y existe `assets/cdk8s-construct.ts`. ... lo que falta es una regla (por ejemplo
`plus.Container` y su `securityContext`), y eso es contenido nuevo."*

S20. *"Ante "el eval degrada", leer el artefacto generado antes de concluir."*

S21. *"**Fuera**: Cambiar el contenido normativo de una regla que sobrevive. Tocar las otras skills."* —
el segundo punto queda vencido por S18/S19 por decisión explícita del usuario.

## Decisiones

D1. **Cuatro archivos de dominio más el `SKILL.md` son los «5 archivos» del ticket.** `environment`,
`promotion`, `hotfix`, `release`. `release` absorbe los dos archivos que hoy cuelgan de `rules/release/`
y `rules/tracking/` se va. Mismo criterio que COU-334: el índice es el quinto archivo que lee un agente.

D2. **`rules/tracking/p2-deployment-tracking.md` se va.** Es genérico, P2, y su contenido normativo
—tags como marcador de deploy y rollback por tag— queda cubierto por el formato de tag de `release.md`.

D3. **La automatización de release se colapsa a un puntero.** `release.md` dice *ejecutá
`assets/release.sh`*, con sus banderas reales y su contrato de aborto; el procedimiento de siete pasos
deja de estar en prosa porque el script ya lo implementa. La bifurcación de SemVer sigue siendo de
`github-conventions/rules/commit.md`, que no se toca.

D4. **`hotfix.md` es el único dueño de la excepción.** *Hotfix salta staging pero no review* se escribe
una sola vez ahí; `environment.md` y `promotion.md` la referencian sin repetirla.

D5. **El eval se corre con un prompt por skill y 5 corridas por condición**, igual que COU-334/335/336 y
que COU-337: 5 corridas cubren la varianza que 1 corrida de tres prompts no cubre. Se registra el número
real.

D6. **`probe/kubernetes/reduced` está atrasado** respecto del repo (difiere en `SKILL.md` y
`security.md`). Hay que resincronizarlo antes de medir la deuda de kubernetes, o el «después» mide una
versión que ya no existe.

D7. **El dominio nuevo de cdk8s es `rules/cdk8s.md`, octavo dominio**, con las decisiones de los siete
dominios mapeadas a cdk8s-plus. Elegido sobre expandir el `SKILL.md` (que ya está en 33 líneas y solo
resuelve **qué** camino tomar) y sobre meterlo en `security.md` (194/200 líneas, y no cubriría probes ni
PDB).

## Tasks

| ID | Spec | Tarea | Commit |
|----|------|-------|--------|
| T1 | S16,S20 | Construir `probe/git-environment-flow/` y correr la condición *original* | — |
| T2 | S1,S2,S8,S15 | `rules/environment.md` + borrar `rules/environment/` | C1 |
| T3 | S1,S2,S8,S15 | `rules/promotion.md` + borrar `rules/promotion/` | C2 |
| T4 | S1,S2,S7,S8,S15 | `rules/hotfix.md` + borrar `rules/hotfix/` | C3 |
| T5 | S1,S2,S6,S8,S15 | `rules/release.md` + borrar `rules/release/` | C4 |
| T6 | S3,S4,S9,S10,S13 | `SKILL.md`, baja de `rules/tracking/`, README, CHANGELOG, auditoría COU-332 | C5 |
| T7 | S8,S9,S10,S12 | Verificación estructural | — |
| T8 | S11,S14,S16 | Eval condición *reducida* contra *original* | — |
| T9 | S15,S17 | Seis recibos nativos, un worktree por commit | — |
| T10 | S18 | `RoleBinding` en el ejemplo ✅ de RBAC de `rules/security.md` + recibo nuevo | C6 |
| T11 | S19 | `rules/cdk8s.md` + fila en `SKILL.md` + resync y corrida de los dos probes k8s | C7 |
| T12 | — | Review nativo de `cf0a6d7` con `baseRef=f1e3841` (cierra el ledger de COU-335) | — |
| T13 | — | Push y PR (`fixes COU-338`) | — |

## Log

L1. *"Vamos con COU-337 (Destilar linear-tickets y traducirlo al inglés, 3 pts) y después COU-338
(release a puntero, 2 pts). ... Además, este ticket arrastra deuda de COU-335 que hay que meter en el
scope, no dejar para después"* — pedido original de la serie, del que este documento toma la parte de
COU-338 y la deuda.

L2. **Medición antes** (comando de S5 sobre `git-environment-flow`): 6 archivos de regla, 547 líneas
markdown en total, `SKILL.md` 49. Los seis: `environment/p0-environment-branches` (172),
`hotfix/p1-hotfix-flow` (53), `promotion/p0-promotion-flow` (49), `release/p0-release-automation` (130),
`release/p1-release-lifecycle` (53), `tracking/p2-deployment-tracking` (41).

L3. `git-environment-flow` es la única skill del catálogo sin harness de eval; `probe/` tiene
`github-conventions`, `kubernetes`, `kubernetes-cdk`, `nestjs-backend`, `react-frontend` y
`linear-tickets` (creado en COU-337). Construirlo es parte de T1.

L4. La rama se creó desde `origin/develop` con `--no-track`, con el `branchName` capturado de la API,
después de enmendar la descripción de COU-338 en Linear para que la deuda de kubernetes quede declarada
en el scope y el PR no mienta sobre lo que trae.

L5. **Harness nuevo**: `probe/git-environment-flow/` no existía. Se construyó con el patrón de la serie:
`prompt.txt` (pide cinco artefactos: ramas, promoción, hotfix, release y rollback), `setup.sh` (original
desde `git archive origin/develop`, reduced desde el worktree), `run.sh` (5 corridas por condición) y
`score.py` con 13 señales sobre el significado de los cinco artefactos.

L6. **Cuatro falsos negativos del scorer, corregidos antes de comparar.** La baseline marcaba
`develop-default` 3/5, `promotion-order` 3/5, `no-staging-source` 2/5 y `rollback-tag` 4/5. Leídos los
artefactos, tres eran defectos del test: exigía `default` y `develop` en la misma línea cuando `r5` lo
ponía en una columna de tabla y `r4` en la línea siguiente; ordenaba por primera aparición cuando el
texto abre con «`staging` is never the source of `main`»; y penalizaba nombrar el SHA cuando la regla
justamente lo prohíbe. Corregidos: ventana de 200 caracteres con `DOTALL`, subsecuencia ordenada en vez
de primera aparición, y la señal de rollback quedó positiva (tag + checkout). El cuarto,
`no-staging-source`, **no era falso negativo**: `r4` y `r5` de verdad no enuncian que `staging` no sea el
origen de `main`, así que la señal mide una ausencia real de la skill vieja.

L7. **Eval, `probe/git-environment-flow`, 5 corridas por condición, 13 señales**: original 12 señales en
5/5 y `no-staging-source` en 3/5; reducida 12 señales en 5/5 y `no-staging-source` en 4/5. Ninguna
señal empeora y una mejora. Artefacto reducido leído a mano (`reduced/r3/hotfix.md`): enuncia la
excepción completa —salta la curación de `staging`, no el review ni el CI—, el patch tag anotado, el
backmerge y cómo `staging` se pone al día en el próximo `release/x.y.z`.

L8. **Medición después** (comando de S5): 6 archivos de regla → 4, 547 líneas markdown → 178, `SKILL.md`
49 → 27 (363 palabras, 671 caracteres de `description`), 0 condicionales anidados. Techos: dominio
máximo 46 líneas (≤200), una regla por archivo con un único par ✅/❌ (environment y release tienen dos
reglas cada uno), `SKILL.md` 27 (≤60). `scan.sh` → `"issues": []`, exit 0, después de sacar el bloque
`permissions:` que agregaba dos hallazgos LP4 sin respaldo: la skill es prosa y no ejecuta nada, y
`linear-tickets` quedó igual de limpia por la misma razón.

L5. **Deuda de kubernetes medida.** Los dos probes se rearmaron con `original` desde `origin/develop`
(el estado previo a la deuda) y `reduced` desde el worktree, y los datos de COU-335 se archivaron como
`.cou335-original` / `.cou335-reduced` en vez de pisarlos.
- `probe/kubernetes` (12 señales, 5 corridas por condición): **12/12 en las dos**. Agregar el
  `RoleBinding` no degrada nada; el ejemplo ✅ ahora es un trío completo y sus 22 bloques YAML parsean.
- `probe/kubernetes-cdk` (12 señales): original y reducida empatan en 11 señales en 5/5, y **`uses-plus`
  pasa de 2/5 a 5/5**. Eso es exactamente el agujero que el item 2 describía: sin la regla, el agente
  escribe `k8s.KubeDeployment` y nunca llega a `cdk8s-plus`; con `rules/cdk8s.md` llega siempre.

L6. **Recibos de git-environment-flow: los cinco, quemados.** C1 3 hallazgos, C2 3, C3 3, C4 2, C5 2 —
13 informativos, ninguno abrió corrección. Dos eran defectos reales y se arreglan en un commit aparte:
un bloque marcado ```json que contenía comentarios `//` (no es JSON válido) y una etiqueta en español
dentro del diagrama de `hotfix.md`, que es normativo en inglés. El resto son del mismo sesgo: el
reviewer extraña el frontmatter `priority:`/`category:` que S2 mandó sacar y las referencias que se
mudaron a otro archivo.

L7. **C2 necesitó la misma maniobra que C5 en COU-337.** El reviewer devolvió el `subject_hash`
truncado y rellenado con ceros (`319bb37a…` seguido de 40 ceros), el decoder lo rechazó por
`binding_mismatch` y el relay reemitió los mismos bytes en 174 ms. Abandonar la lineage y re-abrir dio
contexto y subject-hash nuevos, y aprobó.
