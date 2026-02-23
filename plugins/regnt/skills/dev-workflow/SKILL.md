---
name: dev-workflow
description: Workflow estruturado de desenvolvimento para implementar tasks do SoloBoard. Orquestra 3 fases (Intake, Implementacao, Entrega) com integracao ao SoloBoard MCP. Usar quando receber task_id ou quando o usuario pedir para implementar/desenvolver uma task do SoloBoard.
---

# Development Workflow

Workflow de 3 fases para implementar tasks do SoloBoard.

## Regras

- **NUNCA** pular testes
- **SEMPRE** iniciar timer antes de codar
- **SEMPRE** registrar commits via `log-commits`
- Commits em ingles, UI em portugues
- Se a task tem `spec` ou `session_prompt`: ler como User Story
- Se a task tem `session_result`: ler como trabalho anterior ja feito

## Fase 1: Intake

Executar imediatamente ao receber `task_id`:

```
get-task task_id={ID}
start-timer task_id={ID}
update-task task_id={ID} status=doing
```

```bash
git checkout main && git pull
git checkout -b feature/{slug-descritivo}
```

Depois:
1. Confirmar compreensao da task (titulo, descricao, spec, session_prompt)
2. Se houver documentos relacionados: `list-documents` → `get-document`
3. Se spec nao estiver clara, perguntar antes de prosseguir

### Decisao: Fast Track ou Plano?

| Criterio | Fast Track | Plano |
|----------|------------|-------|
| Complexidade | Baixa (bug fix, ajuste UI, CRUD simples) | Alta (nova feature, refactor, integracao) |
| Arquivos | 1-3 arquivos | 4+ arquivos |
| Duvidas | Nenhuma | Precisa explorar codebase |

**Fast Track**: Pular para Fase 2 direto.

**Plano**: Explorar codebase e apresentar plano resumido ao usuario:

```markdown
## Plano: {titulo}

**Arquivos a modificar:**
- {path}: {o que fazer}

**Ordem de execucao:**
1. {passo}
2. {passo}

**Testes necessarios:**
- {teste}
```

Apos aprovacao: `add-to-plan task_id={ID} description="Resumo"`

## Fase 2: Implementacao

Seguir ordem Laravel:

1. **Migration + Model** - casts, relationships, scopes
2. **Policy** - gates e policies (se necessario)
3. **Action** - logica de negocio isolada
4. **Livewire** - componentes reativos
5. **UI** - views com Flux

Commits incrementais a cada camada relevante.

### Agentes e Skills Disponiveis

Delegar quando apropriado:

| Recurso | Quando usar |
|---------|-------------|
| `frontend-laravel` agent | Implementacao de UI complexa |
| `laravel-simplifier` agent | Revisar codigo antes de entregar |
| `pest-testing` skill | Escrever testes (obrigatorio) |
| `livewire-development` skill | Componentes reativos |
| `fluxui-development` skill | UI components |

## Fase 3: Entrega

### Checklist Obrigatorio

```bash
php artisan test --compact  # todos os testes passando
vendor/bin/pint --dirty     # codigo formatado
```

Verificar:
- [ ] Testes escritos e passando
- [ ] N+1 queries resolvidos (eager loading)
- [ ] Validacao: Rules Livewire + Constraints DB
- [ ] Error handling: flash messages + wire:loading

### Finalizar

```bash
git add -A && git commit -m "feat: descricao-em-ingles"
git push -u origin HEAD
```

```
log-commits task_id={ID} commits=[hash1,hash2] pr_url={URL_se_houver}
update-task task_id={ID} status=done session_result="O que foi implementado"
stop-timer task_id={ID} notes="Resumo do trabalho"
```

## Referencia: Tools MCP

<details>
<summary>Expandir lista de tools</summary>

| Tool | Uso |
|------|-----|
| `get-task` | Obter detalhes da task |
| `update-task` | Atualizar status/session_result |
| `start-timer` | Iniciar timer |
| `stop-timer` | Parar timer com notas |
| `log-commits` | Registrar commits e PR |
| `add-to-plan` | Adicionar ao plano do dia |
| `list-documents` | Listar docs do projeto |
| `get-document` | Ler documento |

</details>
