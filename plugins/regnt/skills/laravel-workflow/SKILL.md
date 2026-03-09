---
name: laravel-workflow
description: |
  Workflow completo end-to-end para desenvolvimento Laravel com SoloBoard e Superpowers.
  Orquestra 5 fases: Discovery, Planning, Implementation (Ralph Loop), Verification, Delivery.
  Usar quando o usuario quiser iniciar um projeto completo, "workflow completo", "do zero ao deploy",
  "nova feature end-to-end", ou quando mencionar "laravel-workflow", "workflow laravel".
  Comando: /workflow <project_slug> [--from=idea|prd|feature|task] [--mode=full|fast]
---

# Laravel Workflow

Workflow end-to-end que orquestra Superpowers + Laravel + SoloBoard + Ralph Loop.

## Visao Geral

```
Idea → Discovery → Planning → Implementation → Verification → Delivery
       (Phase 1)   (Phase 2)   (Phase 3)        (Phase 4)      (Phase 5)
```

Cada fase usa skills especializados:

| Fase | Skills Utilizados | SoloBoard MCP |
|------|-------------------|---------------|
| 1. Discovery | `regnt:brainstorming` + `regnt:write-prd` | `get-project-context`, `create-document` |
| 2. Planning | `regnt:prd-to-tasks` | `create-task`, `create-feature`, `add-task-to-feature` |
| 3. Implementation | `regnt:ralph-loop` + agents | `start-timer`, `update-task`, `stop-timer` |
| 4. Verification | `regnt:verification-before-completion` | `update-feature` |
| 5. Delivery | `regnt:finishing-a-development-branch` | `update-feature`, `log-commits` |

## Comando

```
/workflow <project_slug> [--from=idea|prd|feature|task] [--mode=full|fast]
```

- `project_slug`: Slug do projeto no SoloBoard (obrigatorio)
- `--from`: Ponto de entrada (default: `idea`)
  - `idea` — Comecar do zero (brainstorming → PRD → tasks → implementacao)
  - `prd` — PRD ja existe no SoloBoard (pular Discovery, ir para Planning)
  - `feature` — Feature ja existe com tasks (pular Planning, ir para Implementation)
  - `task` — Task unica para implementar (usar dev-workflow em vez de ralph-loop)
- `--mode`: Modo de execucao (default: `full`)
  - `full` — Todas as fases com checkpoints de aprovacao
  - `fast` — Minimo de interacao, maximo de autonomia

## Regras Globais

- **NUNCA** pular verificacao de testes
- **SEMPRE** iniciar timer antes de codar
- **SEMPRE** registrar progresso no SoloBoard
- **SEMPRE** carregar skills antes de implementar
- Commits em ingles, UI/docs em portugues
- Seguir ordem Laravel: Migration+Model → Policy → Action → Livewire → UI → Testes

---

## Phase 1: Discovery

> **Objetivo**: Transformar uma ideia em um PRD validado.
> **Pular se**: `--from=prd|feature|task`

### 1.1 Obter contexto do projeto

```
get-project-context project_slug={slug}
```

Internalizar: documentos, features ativas, tasks pendentes, padroes existentes.

### 1.2 Brainstorming (Superpowers)

Invocar `regnt:brainstorming` com adaptacao Laravel:

1. **Explorar contexto** — Ler codebase, documentos SoloBoard, padroes existentes
2. **Perguntas clarificadoras** — Uma por vez, preferir multipla escolha
3. **Propor 2-3 abordagens** — Com trade-offs e recomendacao
   - Considerar: stack Laravel (Livewire 4, Flux UI, Alpine.js)
   - Considerar: padroes existentes no codebase
   - Considerar: integracao com features existentes
4. **Apresentar design** — Secao por secao, aprovacao incremental
5. **Escrever design doc** — Salvar em `docs/plans/YYYY-MM-DD-<topic>-design.md`

<HARD-GATE>
NAO prosseguir para Planning sem design aprovado pelo usuario.
</HARD-GATE>

### 1.3 Escrever PRD (regnt)

Invocar `/regnt:write-prd` para criar o PRD:

1. Usar o design aprovado como base
2. Entrevistar usuario para preencher gaps
3. Criar PRD como documento no SoloBoard:

```
create-document project_slug={slug} title="PRD: {feature}" slug="prd-{feature-slug}" content="{PRD completo}"
```

**Transicao**: Ao concluir o PRD, informar e prosseguir para Phase 2.

---

## Phase 2: Planning

> **Objetivo**: Transformar PRD em tasks executaveis no SoloBoard.
> **Pular se**: `--from=feature|task`

### 2.1 Localizar PRD

Se `--from=prd`:
```
list-documents project_slug={slug}
get-document slug={prd-slug}
```

Se veio da Phase 1: usar PRD recem-criado.

### 2.2 Explorar codebase

Antes de quebrar em tasks, explorar o codebase para entender:
- Padroes existentes para features similares
- Camadas de integracao (DB, API, UI, testes)
- Seams naturais para vertical slices

### 2.3 Criar vertical slices (regnt)

Invocar `/regnt:prd-to-tasks` com adaptacao:

1. Quebrar PRD em **tracer bullets** (vertical slices end-to-end)
2. Cada slice atravessa TODAS as camadas: Migration → Model → Policy → Action → Livewire → UI → Testes
3. Primeiro slice = caminho end-to-end mais simples
4. Slices seguintes adicionam complexidade incremental

### 2.4 Validar com usuario

Apresentar breakdown e perguntar:
- Granularidade esta boa?
- Dependencias estao corretas?
- Ordem do primeiro tracer bullet esta certa?

### 2.5 Criar no SoloBoard

Apos aprovacao:

1. **Criar tasks** com `create-task` (em ordem de dependencia):

```
create-task title="{slice title}" project_slug={slug} priority={priority} session_prompt="{user story completa}"
```

2. **Criar feature** agrupando as tasks:

```
create-feature title="{feature title}" project_slug={slug} description="{resumo}"
```

3. **Vincular tasks a feature**:

```
add-task-to-feature feature_id={ID} task_id={task_ID}
```

4. Mostrar tabela final:

| # | Task | Priority | Blocked by |
|---|------|----------|------------|
| 1 | ... | high | None |
| 2 | ... | medium | Task 1 |

**Transicao**: Perguntar se quer iniciar implementacao agora.

---

## Phase 3: Implementation

> **Objetivo**: Implementar todas as tasks da feature de forma autonoma.
> **Pular se**: `--from=task` (usar dev-workflow)

### 3.1 Decisao: Ralph Loop ou Dev Workflow?

| Criterio | Ralph Loop | Dev Workflow |
|----------|------------|--------------|
| Escopo | Feature completa (multiplas tasks) | Task unica |
| Autonomia | Alto (loop autonomo) | Medio (interativo) |
| Quando | `--from=idea\|prd\|feature` | `--from=task` |

### 3.2 Se Ralph Loop (default para features)

Invocar `/regnt:ralph-loop` com o `feature_id`:

```
/ralph {feature_id} --run
```

O Ralph Loop ira:

1. **Arquivar** sessao anterior (se existir)
2. **Buscar** feature e tasks do SoloBoard via `ralph-export`
3. **Criar** estrutura local (prd.json, CLAUDE.md, progress.txt)
4. **Criar branch**: `ralph/{feature-slug}`
5. **Loop por story**:
   - Carregar skills: `/regnt:laravel-development`, `/regnt:php-development`, `/regnt:pint-formatting`
   - Start timer → Update status → Implementar → Testar → Commit → Stop timer
   - Seguir ordem Laravel com agents especializados
   - Uma story por iteracao
6. **Completar** quando todas as stories passam

### 3.3 Se Dev Workflow (para task unica)

Invocar `/regnt:dev-workflow` com o `task_id`:

1. **Intake**: get-task → start-timer → criar branch
2. **Implementacao**: Seguir ordem Laravel
3. **Entrega**: Testes + lint → commit → update SoloBoard

### Agents e Skills disponiveis durante implementacao

#### Agents (delegar quando apropriado)

| Agent | Escopo |
|-------|--------|
| `regnt:laravel-core` | Models, Migrations, Factories, Enums, DTOs, Policies, Form Requests, Observers, Events |
| `regnt:frontend-laravel` | Livewire 4, Flux UI, Alpine.js, Blade, componentes interativos |
| `regnt:pest-tester` | Feature tests, unit tests, browser tests, testes Livewire |
| `regnt:ai-workflows` | Laravel AI SDK, Laravel MCP, agents, tools, structured output |
| `laravel-simplifier` | Revisar e simplificar codigo PHP/Laravel |

#### Skills (invocar antes de implementar)

| Skill | Quando |
|-------|--------|
| `/regnt:laravel-development` | Conventions Laravel 12, controllers, models, migrations |
| `/regnt:php-development` | PHP 8.x moderno, tipagem, enums, constructors |
| `/regnt:pint-formatting` | Formatacao com Pint apos modificar PHP |
| `/regnt:boost-tools` | Debug, DB, Artisan, docs, URLs |

---

## Phase 4: Verification

> **Objetivo**: Garantir que tudo funciona antes de entregar.

### 4.1 Quality Checks (obrigatorio)

Invocar `regnt:verification-before-completion`:

```bash
php artisan test --compact    # TODOS os testes passando
vendor/bin/pint --dirty       # Codigo formatado
```

<HARD-GATE>
NAO prosseguir para Delivery sem EVIDENCIA de testes passando.
Rodar o comando. Ler o output. SO ENTAO declarar resultado.
</HARD-GATE>

### 4.2 Checklist de qualidade

Verificar CADA item:

- [ ] Testes escritos e passando (feature + unit)
- [ ] N+1 queries resolvidos (eager loading)
- [ ] Validacao: Rules Livewire + Constraints DB
- [ ] Error handling: flash messages + wire:loading
- [ ] Migrations reversiveis
- [ ] Policies aplicadas onde necessario
- [ ] Commits seguem conventional commits

### 4.3 Code Review (opcional em modo full)

Se `--mode=full`, invocar `regnt:requesting-code-review`:

1. Dispatch code-reviewer subagent
2. Avaliar feedback
3. Corrigir issues Critical e Important
4. Re-verificar testes

### 4.4 Atualizar SoloBoard

```
update-feature feature_id={ID} status=done
```

---

## Phase 5: Delivery

> **Objetivo**: Integrar o trabalho e finalizar.

### 5.1 Finishing Branch (Superpowers)

Invocar `regnt:finishing-a-development-branch`:

1. **Verificar testes** — Rodar suite completa
2. **Apresentar 4 opcoes**:
   1. Merge local para main
   2. Push e criar PR
   3. Manter branch como esta
   4. Descartar trabalho
3. **Executar** escolha do usuario
4. **Cleanup** worktree (se aplicavel)

### 5.2 Registrar no SoloBoard

```
log-commits task_id={ID} commits=[hashes] pr_url={URL}
```

### 5.3 Resumo Final

Apresentar ao usuario:

```markdown
## Workflow Completo

**Feature**: {titulo}
**Projeto**: {nome}
**Tasks**: {total} completadas
**Commits**: {quantidade}
**Branch**: {nome} → {destino}
**Status**: Entregue ✓

### O que foi implementado
- {resumo por task}

### Proximos passos sugeridos
- {sugestao baseada no contexto}
```

---

## Fluxo de Decisao por Entry Point

```
/workflow project --from=idea
  └→ Phase 1 (Discovery) → Phase 2 (Planning) → Phase 3 (Ralph Loop) → Phase 4 → Phase 5

/workflow project --from=prd
  └→ Phase 2 (Planning) → Phase 3 (Ralph Loop) → Phase 4 → Phase 5

/workflow project --from=feature --feature_id=42
  └→ Phase 3 (Ralph Loop) → Phase 4 → Phase 5

/workflow project --from=task --task_id=99
  └→ Phase 3 (Dev Workflow) → Phase 4 → Phase 5
```

## Modo Fast vs Full

| Aspecto | Full | Fast |
|---------|------|------|
| Brainstorming | Completo com aprovacoes | Minimo, 1 abordagem |
| Planning | Validacao com usuario | Auto-aprovacao |
| Code Review | Sim (subagent) | Nao |
| Checkpoints | Entre cada fase | Apenas no final |
| Autonomia | Baixa (interativo) | Alta (autonomo) |

---

## Troubleshooting

### SoloBoard nao conectado
```bash
claude mcp add --transport http soloboard https://regnt.sophostech.com.br/mcp
```

### Feature nao encontrada
```
list-features project_slug={slug}
```

### Testes falhando no loop
O Ralph Loop para automaticamente. Corrigir manualmente e re-executar:
```bash
./scripts/ralph.sh --tool claude
```

### Skills nao carregando
Verificar que o plugin regnt esta instalado:
```bash
claude plugin list
```

---

## Referencia Completa: Tools MCP

<details>
<summary>Expandir lista de tools</summary>

### Projeto e Contexto
| Tool | Uso |
|------|-----|
| `get-project-context` | Contexto completo do projeto (docs, tasks, features) |
| `list-projects` | Listar projetos ativos |

### Documentos
| Tool | Uso |
|------|-----|
| `list-documents` | Listar documentos do projeto |
| `get-document` | Ler documento por slug |
| `create-document` | Criar documento (PRD, spec, etc.) |
| `update-document` | Atualizar documento existente |

### Features
| Tool | Uso |
|------|-----|
| `list-features` | Listar features do projeto |
| `get-feature` | Detalhes da feature |
| `create-feature` | Criar nova feature |
| `update-feature` | Atualizar status (draft/backlog/todo/doing/done) |
| `add-task-to-feature` | Vincular task a feature |

### Tasks
| Tool | Uso |
|------|-----|
| `list-tasks` | Listar tasks (filtrar por status/projeto) |
| `get-task` | Detalhes da task |
| `create-task` | Criar task com session_prompt |
| `update-task` | Atualizar status/session_result |

### Timers
| Tool | Uso |
|------|-----|
| `start-timer` | Iniciar timer para task |
| `stop-timer` | Parar timer com notas |
| `timer-status` | Verificar timer ativo |

### Plano do Dia
| Tool | Uso |
|------|-----|
| `today-plan` | Ver plano do dia |
| `add-to-plan` | Adicionar task ao plano |

### Commits
| Tool | Uso |
|------|-----|
| `log-commits` | Registrar commits e PR |

### Ralph Loop
| Tool | Uso |
|------|-----|
| `ralph-export` | Exportar feature como PRD JSON |

</details>
