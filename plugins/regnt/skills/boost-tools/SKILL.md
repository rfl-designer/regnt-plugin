---
name: boost-tools
description: |
  Guidelines para usar as ferramentas MCP do Laravel Boost. Ativar quando precisar debugar,
  consultar banco de dados, executar Artisan, buscar documentação ou gerar URLs do projeto.
---

# Laravel Boost Tools

## Quando Ativar

Ative esta skill quando:

- Precisar executar comandos Artisan
- Debugar código PHP ou queries
- Consultar banco de dados
- Buscar documentação de pacotes Laravel
- Gerar URLs do projeto

## Ferramentas Disponíveis

### Artisan

Use `list-artisan-commands` para verificar parâmetros disponíveis antes de executar comandos.

### URLs

Use `get-absolute-url` para gerar URLs corretas do projeto com scheme, domain e port.

### Debugging

| Ferramenta | Propósito |
|------------|-----------|
| `tinker` | Executar PHP para debug ou queries Eloquent |
| `database-query` | Consultar banco de dados (somente leitura) |
| `database-schema` | Inspecionar estrutura de tabelas |

Use `database-schema` antes de criar migrations ou models para entender a estrutura existente.

### Browser Logs

Use `browser-logs` para ler logs, erros e exceptions do browser. Apenas logs recentes são úteis.

## Busca de Documentação (Crítico)

Use `search-docs` **antes** de outras abordagens quando trabalhar com Laravel ou pacotes do ecossistema.

### Como Usar search-docs

1. **Queries simples e amplas**: Use múltiplas queries de uma vez.
2. **Não inclua nomes de pacotes**: A informação de versão já é passada automaticamente.
3. **Busque antes de codar**: Garanta que está usando a abordagem correta.

```
# Bom
queries: ["rate limiting", "routing rate limiting", "routing"]

# Ruim - não inclua nome do pacote
queries: ["filament 4 test resource table"]

# Bom
queries: ["test resource table"]
```

### Sintaxe de Busca

| Tipo | Exemplo | Descrição |
|------|---------|-----------|
| Palavras simples | `authentication` | Auto-stemming (encontra 'authenticate', 'auth') |
| Múltiplas palavras (AND) | `rate limit` | Ambas palavras devem existir |
| Frase exata | `"infinite scroll"` | Palavras adjacentes na ordem |
| Misto | `middleware "rate limit"` | Combina AND com frase exata |
| Múltiplas queries | `["authentication", "middleware"]` | Qualquer termo |

## Laravel Herd

Se o projeto usa Herd:

- A aplicação está disponível em `https://[nome-do-projeto].test`
- **Não rode comandos** para disponibilizar via HTTP - Herd já faz isso
- Use `get-absolute-url` para gerar URLs válidas

## Workflow Recomendado

1. Use `database-schema` para entender estrutura existente
2. Use `search-docs` para buscar padrões corretos
3. Use `list-artisan-commands` para verificar comandos disponíveis
4. Implemente seguindo a documentação
5. Use `tinker` para testar/debugar
6. Use `database-query` para verificar dados

## Erros Comuns

- Não usar `search-docs` antes de implementar
- Incluir nome de pacote nas queries de busca
- Usar `tinker` quando `database-query` (somente leitura) seria suficiente
- Não usar `database-schema` antes de criar migrations
