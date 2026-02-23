---
name: dev-workflow
description: Workflow estruturado de desenvolvimento para implementar tasks do SoloBoard. Orquestra 5 fases (Intake, Planejamento, Implementacao, Qualidade, Entrega) com integracao ao SoloBoard MCP (timers, tasks, documentos, plano do dia). Usar quando receber o contexto do prompt `development-workflow` com task_id, ou quando o usuario pedir para implementar/desenvolver uma task do SoloBoard. Ativa automaticamente skills complementares (livewire, fluxui, pest-testing, tailwindcss, fortify, mcp) conforme a natureza da task.
---

# Development Workflow

Workflow de 5 fases para implementar tasks do SoloBoard. Seguir cada fase na ordem, sem pular nenhuma.

## Regras

- **NUNCA** pular testes (fase 4)
- **SEMPRE** iniciar timer antes de codar e parar ao finalizar
- **SEMPRE** registrar commits e PR URL via `log-commits`
- Commits em ingles, UI em portugues
- Se a task tem `session_prompt`: ler como User Story. Se tem `session_result`: ler como trabalho anterior ja feito
- Ao finalizar session task, preencher `session_result` no `update-task`

## Fase 1: Intake e Analise

Executar imediatamente ao receber a task:

```
start-timer task_id={ID}
update-task task_id={ID} status=doing
```

```bash
git checkout main||develop && git pull
git checkout -b feature/{slug-descritivo-da-task}
```

Depois:
1. Ler e confirmar compreensao da task (titulo, descricao, session_prompt)
2. Listar documentos disponíveis no projeto `list-documents project_id={ID}`
3. Ler documentos relacionados com `get-document slug={doc-slug}` (PRDs, Specs)
4. Se spec nao estiver clara, listar perguntas antes de prosseguir

## Fase 2: Planejamento

### Passo 1: Entrar no Plan Mode

Chamar a ferramenta `EnterPlanMode` para iniciar o modo de planejamento estruturado:

```
Ferramenta: EnterPlanMode
Parâmetros: {} (nenhum parâmetro necessário)
```

O Plan Mode permite explorar o codebase sistematicamente usando Glob, Grep e Read antes de implementar.

### Passo 2: Explorar e Documentar

Dentro do Plan Mode, explorar o código existente e criar o plano seguindo o template abaixo.
O plano será salvo em um arquivo (por padrão em `~/.claude/plans/` ou conforme `plansDirectory` nas settings).

### Template do Plano

```markdown
# Plano: {titulo-da-task}

## 1. Contexto
- Task ID: {id}
- Descrição: {resumo da task}
- Documentos consultados: {lista de docs lidos}

## 2. Análise do Código Existente
- Models relacionados: {lista com paths}
- Componentes Livewire: {lista}
- Policies/Gates: {lista}
- Migrations relevantes: {lista}

## 3. Arquitetura Proposta

### 3.1 Migration + Model
- [ ] {arquivo}: {descrição do que criar/modificar}

### 3.2 Policy / Authorization
- [ ] {arquivo}: {descrição}

### 3.3 Action / Service
- [ ] {arquivo}: {descrição}

### 3.4 Componentes Livewire
- [ ] {arquivo}: {descrição}

### 3.5 UI com Flux
- [ ] {arquivo}: {descrição}

## 4. Skills a Ativar
- [ ] livewire-development: {sim/não - motivo}
- [ ] fluxui-development: {sim/não - motivo}
- [ ] tailwindcss-development: {sim/não - motivo}
- [ ] pest-testing: sim (obrigatório)
- [ ] developing-with-fortify: {sim/não - motivo}
- [ ] mcp-development: {sim/não - motivo}

## 5. Testes Necessários
- [ ] {teste 1}
- [ ] {teste 2}

## 6. Riscos e Dependências
- {risco ou dependência identificada}
```

### Critérios para Ativar Skills

| Skill | Quando ativar |
|-------|---------------|
| `livewire-development` | Componentes reativos, wire:, real-time |
| `fluxui-development` | Modal, form, input, button, table, chart, UI components |
| `tailwindcss-development` | Layout, grid, flex, dark mode, responsive, estilizacao |
| `pest-testing` | **Sempre obrigatorio** |
| `developing-with-fortify` | Auth, login, registro, 2FA, password |
| `mcp-development` | Tools MCP, resources, prompts, routes/ai |

### Passo 3: Solicitar Aprovação

Após preencher o template do plano, chamar a ferramenta `ExitPlanMode` para solicitar aprovação do usuário:

```
Ferramenta: ExitPlanMode
Parâmetros: {} (nenhum parâmetro necessário)
```

O usuário revisará o plano e aprovará ou solicitará ajustes.

### Passo 4: Registrar no SoloBoard

Após aprovação do plano, registrar no SoloBoard:

```
add-to-plan task_id={ID} description="Resumo do plano aprovado"
```

## Fase 3: Implementacao

Seguir esta ordem de execucao:

1. **Migration + Model** - casts, relationships, scopes
2. **Policy / Authorization** - gates e policies
3. **Action / Service** - logica de negocio isolada
4. **Componentes Livewire** - usando skill `livewire-development`
5. **UI com Flux** - usando skill `fluxui-development`

!IMPORTANTE: a cada implementação relevante feita, faça o commit das mudanças.

Ativar as skills identificadas na fase 2 conforme cada camada for implementada.

## Fase 4: Qualidade

Invoque o agent laravel-simplifier para analisar o codigo implementado.

Verificar antes de entregar:

- [ ] Validacao: Rules Livewire + Constraints DB
- [ ] Error Handling: Flash messages + wire:loading states
- [ ] Testes com Pest (skill `pest-testing`) - **obrigatorio**
- [ ] N+1 queries (usar eager loading)
- [ ] Componente pesado (extrair sub-componentes se necessario)
- [ ] SRP (Single Responsibility) respeitado

Rodar testes: `php artisan test --compact`

## Fase 5: Entrega

Executar na ordem:

```bash
php artisan test --compact
vendor/bin/pint --dirty
git add . && git commit -m "feat: descricao-em-ingles"
```

```
log-commits task_id={ID} commits=[...] pr_url={URL}
update-task task_id={ID} status=done session_result="Resumo do que foi implementado"
stop-timer task_id={ID} notes="Resumo do trabalho realizado"
```

## Tools MCP Disponiveis (SoloBoard)

### Tarefas
| Tool | Descricao |
|------|-----------|
| `list-tasks` | Listar tarefas |
| `get-task` | Obter detalhes de uma tarefa |
| `create-task` | Criar tarefa |
| `update-task` | Atualizar tarefa (status, session_result) |
| `delete-task` | Deletar tarefa |

### Timer
| Tool | Descricao |
|------|-----------|
| `start-timer` | Iniciar timer |
| `stop-timer` | Parar timer com notas |
| `timer-status` | Status do timer atual |

### Planejamento
| Tool | Descricao |
|------|-----------|
| `today-plan` | Plano do dia |
| `suggest-tasks` | Sugerir tarefas |
| `add-to-plan` | Adicionar ao plano do dia |

### Projetos
| Tool | Descricao |
|------|-----------|
| `list-projects` | Listar projetos |
| `get-project-context` | Contexto completo do projeto |

### Documentos
| Tool | Descricao |
|------|-----------|
| `list-documents` | Listar documentos do projeto |
| `get-document` | Ler documento por slug |
| `create-document` | Criar documento |
| `update-document` | Atualizar documento |
| `delete-document` | Deletar documento |

### Outros
| Tool | Descricao |
|------|-----------|
| `log-commits` | Registrar commits e PR URL |
| `get-analytics` | Obter analytics |
| `list-templates` | Listar templates |
| `apply-template` | Aplicar template |
| `list-recurring-tasks` | Listar tarefas recorrentes |
| `create-recurring-task` | Criar tarefa recorrente |
| `toggle-recurring-task` | Ativar/desativar tarefa recorrente |
