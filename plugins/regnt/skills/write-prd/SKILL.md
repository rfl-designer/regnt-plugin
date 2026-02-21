---
name: write-prd
description: |
  Cria PRDs (Product Requirements Documents) estruturados através de entrevista colaborativa.
  Usar quando o usuário quiser: criar um PRD, documentar requisitos de uma feature,
  planejar uma implementação, ou quando mencionar "PRD", "requisitos", "especificação".
  O resultado é uma issue GitHub com problema, solução, user stories e decisões técnicas.
---

# Write PRD

Cria PRDs estruturados através de entrevista colaborativa com o usuário.

## Processo

### 1. Coletar contexto inicial

Pedir ao usuário uma descrição detalhada do problema que quer resolver e ideias iniciais de solução.

### 2. Explorar o codebase

Verificar assertions do usuário e entender o estado atual do código relevante.

### 3. Entrevistar o usuário

Explorar cada aspecto do plano até alcançar entendimento compartilhado:

- Percorrer cada branch da árvore de decisões
- Resolver dependências entre decisões uma a uma
- Não avançar até haver clareza

### 4. Identificar módulos

Mapear módulos a construir ou modificar. Buscar oportunidades de extrair **deep modules** - módulos que encapsulam muita funcionalidade em interfaces simples e testáveis.

Validar com o usuário:
- Os módulos mapeados correspondem às expectativas?
- Quais módulos precisam de testes?

### 5. Escrever o PRD

Criar issue GitHub usando o template abaixo.

## Template do PRD

```markdown
## Problem Statement

[Problema que o usuário enfrenta, da perspectiva do usuário]

## Solution

[Solução proposta, da perspectiva do usuário]

## User Stories

[Lista EXTENSA e numerada. Cobrir todos os aspectos da feature]

1. As a <actor>, I want <feature>, so that <benefit>

## Implementation Decisions

[Decisões técnicas tomadas durante a entrevista]

- Módulos a construir/modificar
- Interfaces que mudam
- Decisões arquiteturais
- Schema changes
- API contracts

NÃO incluir file paths ou code snippets específicos.

## Testing Decisions

- Quais módulos serão testados
- Prior art (testes similares no codebase)
- Foco em comportamento externo, não detalhes de implementação

## Out of Scope

[O que NÃO faz parte deste PRD]

## Further Notes

[Notas adicionais relevantes]
```
