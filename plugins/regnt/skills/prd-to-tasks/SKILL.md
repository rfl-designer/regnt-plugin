---
name: prd-to-tasks
description: |
  Quebra um PRD em tasks independentes no SoloBoard usando vertical slices (tracer bullets).
  Usar quando o usuário quiser: transformar PRD em tasks, criar tasks a partir de PRD,
  quebrar feature em tasks para o SoloBoard, ou quando tiver um PRD pronto e quiser começar implementação.
  Cada task é um slice vertical end-to-end, não uma camada horizontal.
---

# PRD to Tasks

Transforma um PRD em tasks no SoloBoard usando vertical slices (tracer bullets).

## Processo

### 1. Localizar o PRD

Listar documentos do projeto com `list-documents project_id={ID}` e identificar o PRD. Ler com `get-document slug={slug}` e internalizar todo o conteúdo.

### 2. Explorar o codebase

Ler módulos e camadas de integração referenciados no PRD. Identificar:

- Camadas de integração (DB/schema, API/backend, UI, tests, config)
- Patterns existentes para features similares
- Seams naturais para paralelização

### 3. Criar vertical slices

Quebrar o PRD em tasks **tracer bullet**:

- Cada slice atravessa TODAS as camadas end-to-end (schema → API → UI → tests)
- Cada slice é demoável/verificável isoladamente
- Preferir muitos slices finos a poucos grossos
- Primeiro slice = caminho end-to-end mais simples ("hello world")
- Slices seguintes adicionam: edge cases, user stories adicionais, polish

### 4. Validar com usuário

Apresentar breakdown como lista numerada. Para cada slice:

- **Title**: nome descritivo curto
- **Layers touched**: camadas que o slice atravessa
- **Blocked by**: slices que precisam completar primeiro
- **User stories covered**: quais user stories do PRD

Perguntar:
- Granularidade está boa?
- Dependências estão corretas?
- Algum slice deve ser merged ou split?
- Ordem do primeiro tracer bullet está certa?
- Falta algum slice?

Iterar até aprovação.

### 5. Criar tasks no SoloBoard

Criar tasks com `create-task` em ordem de dependência (blockers primeiro).

**Campos da task:**

| Campo | Conteúdo |
|-------|----------|
| `title` | Nome descritivo curto do slice |
| `description` | Descrição do slice usando template abaixo |
| `project_id` | ID do projeto no SoloBoard |
| `priority` | `high` para primeiro slice, `medium` para demais |

**Template da description:**

```
## PRD

{slug-do-documento-prd}

## What to build

[Descrição concisa do slice vertical. Comportamento end-to-end, não layer-by-layer. Referenciar seções do PRD.]

## Acceptance criteria

- [ ] Critério 1
- [ ] Critério 2
- [ ] Critério 3

## Blocked by

- Task: {titulo-da-task-bloqueadora} (se houver)

Ou "None - can start immediately"

## User stories addressed

- User story 3
- User story 7
```

### 6. Summarizar

Após criar todas tasks, mostrar tabela:

| Task | Title | Blocked by | Priority |
|------|-------|------------|----------|
| 1 | Basic widget creation | None | high |
| 2 | Widget listing | Task 1 | medium |

Sugerir adicionar as tasks ao plano do dia com `add-to-plan` se o usuário quiser começar imediatamente.
