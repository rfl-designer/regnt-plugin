---
name: pint-formatting
description: |
  Guidelines para formatação de código com Laravel Pint. Ativar após modificar arquivos PHP
  para garantir que o código segue o style guide do projeto.
---

# Laravel Pint Formatting

## Quando Ativar

Ative esta skill quando:

- Finalizar modificações em arquivos PHP
- Verificar formatação do código
- Corrigir issues de code style

## Uso Básico

Após modificar arquivos PHP, **sempre** rode Pint antes de finalizar:

```bash
# Formatar apenas arquivos modificados (dirty)
./vendor/bin/pint --dirty

# Formatar arquivo específico
./vendor/bin/pint app/Models/User.php

# Formatar diretório
./vendor/bin/pint app/Actions/
```

## Comandos

| Comando | Propósito |
|---------|-----------|
| `./vendor/bin/pint --dirty` | Formatar arquivos modificados |
| `./vendor/bin/pint --test` | Verificar sem modificar |
| `./vendor/bin/pint --dirty --format agent` | Formato para agentes (se suportado) |

## Regras Importantes

1. **Não rode** `./vendor/bin/pint --test` para corrigir - ele apenas verifica.
2. **Sempre rode** `./vendor/bin/pint` (sem `--test`) para aplicar correções.
3. Use `--dirty` para formatar apenas arquivos modificados (mais rápido).

## Workflow

1. Faça suas modificações no código PHP
2. Rode `./vendor/bin/pint --dirty`
3. Verifique as mudanças
4. Commit

## Configuração

Pint usa `pint.json` na raiz do projeto para configuração:

```json
{
    "preset": "laravel",
    "rules": {
        "simplified_null_return": true,
        "braces": {
            "allow_single_line_closure": true
        }
    }
}
```

## Erros Comuns

- Rodar `--test` esperando que corrija o código
- Esquecer de rodar Pint antes de commit
- Não usar `--dirty` e formatar todo o projeto desnecessariamente
