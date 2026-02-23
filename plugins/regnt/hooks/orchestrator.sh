#!/bin/bash
# Orchestrator Hook - Injeta contexto no inicio da sessao

PLUGIN_DIR="$HOME/.claude/plugins/marketplaces/regnt-marketplace/plugins/regnt"

if [ ! -d "$PLUGIN_DIR" ]; then
  echo "Plugin regnt nao encontrado em $PLUGIN_DIR"
  exit 0
fi

echo "<!-- orchestrator-context -->"
echo ""

# === CLAUDE.md do Projeto ===
if [ -n "$CLAUDE_PROJECT_DIR" ]; then
  # Tenta diferentes locais do CLAUDE.md
  for claude_file in "$CLAUDE_PROJECT_DIR/CLAUDE.md" "$CLAUDE_PROJECT_DIR/.claude/CLAUDE.md"; do
    if [ -f "$claude_file" ]; then
      echo "## Regras do Projeto"
      echo ""
      cat "$claude_file"
      echo ""
      echo "---"
      echo ""
      break
    fi
  done
fi

# === Agents Disponiveis ===
if [ -d "$PLUGIN_DIR/agents" ]; then
  echo "## Agents Disponiveis"
  echo ""
  echo "Use \`Task\` tool com \`subagent_type\` para delegar."
  echo ""

  for agent in "$PLUGIN_DIR"/agents/*.md; do
    [ -f "$agent" ] || continue

    name=$(grep -m1 "^name:" "$agent" 2>/dev/null | sed 's/^name:[[:space:]]*//')
    desc=$(grep -m1 "^description:" "$agent" 2>/dev/null | sed 's/^description:[[:space:]]*//')

    if [ -n "$name" ]; then
      echo "- **$name**: $desc"
    fi
  done

  echo ""
  echo "---"
  echo ""
fi

# === Skills Disponiveis ===
if [ -d "$PLUGIN_DIR/skills" ]; then
  echo "## Skills Disponiveis"
  echo ""
  echo "Use \`Skill\` tool para ativar."
  echo ""

  for skill in "$PLUGIN_DIR"/skills/*/SKILL.md; do
    [ -f "$skill" ] || continue

    name=$(grep -m1 "^name:" "$skill" 2>/dev/null | sed 's/^name:[[:space:]]*//')

    # Extrai description (pode ser single-line ou multi-line com |)
    desc_line=$(grep -m1 "^description:" "$skill" 2>/dev/null)
    if echo "$desc_line" | grep -q "|"; then
      # Multi-line: pega a proxima linha nao-vazia
      desc=$(awk '/^description:/{getline; gsub(/^[[:space:]]+/, ""); print; exit}' "$skill")
    else
      # Single-line
      desc=$(echo "$desc_line" | sed 's/^description:[[:space:]]*//')
    fi

    if [ -n "$name" ]; then
      # Trunca descricao se muito longa
      desc_short=$(echo "$desc" | cut -c1-120)
      [ ${#desc} -gt 120 ] && desc_short="$desc_short..."
      echo "- **$name**: $desc_short"
    fi
  done

  echo ""
  echo "---"
  echo ""
fi

# === Instrucoes do Orchestrator ===
if [ -f "$PLUGIN_DIR/orchestrator.md" ]; then
  cat "$PLUGIN_DIR/orchestrator.md"
fi

echo ""
echo "<!-- /orchestrator-context -->"
