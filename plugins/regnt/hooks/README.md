# Hooks do Plugin regnt

## orchestrator.sh

Injeta contexto do orquestrador no inicio de cada sessao do Claude Code.

### O que faz

1. Le o `CLAUDE.md` do projeto atual (se existir)
2. Lista todos os agents disponiveis do plugin
3. Lista todas as skills disponiveis do plugin
4. Injeta as instrucoes do orquestrador

### Instalacao

Adicione ao seu `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.claude/plugins/marketplaces/regnt-marketplace/plugins/regnt/hooks/orchestrator.sh"
          }
        ]
      }
    ]
  }
}
```

### Variaveis de Ambiente

O script usa esta variavel (definida pelo Claude Code):

- `CLAUDE_PROJECT_DIR`: Diretorio do projeto atual

### Testando

```bash
# Simula as variaveis e executa
CLAUDE_PROJECT_DIR=/path/to/your/project \
  ~/.claude/plugins/marketplaces/regnt-marketplace/plugins/regnt/hooks/orchestrator.sh
```
