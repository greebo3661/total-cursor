#!/usr/bin/env bash
# Install total-cursor bundle to user-scope Cursor directory (~/.cursor).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUNDLE_CURSOR="$REPO_ROOT/bundle/cursor"
USER_CURSOR="${HOME}/.cursor"
OVERWRITE=0
SKIP_MCP=0
SKIP_HOOKS=0

usage() {
  cat <<EOF
Usage: $(basename "$0") [options]

Options:
  --overwrite   Overwrite existing skills/rules/agents/hooks
  --skip-mcp    Do not create or merge mcp.json
  --skip-hooks  Skip hooks installation
  -h, --help    Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --overwrite) OVERWRITE=1; shift ;;
    --skip-mcp) SKIP_MCP=1; shift ;;
    --skip-hooks) SKIP_HOOKS=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "Required command not found: $1" >&2; exit 1; }
}

copy_tree_merge() {
  local src="$1"
  local dst="$2"
  local force="$3"
  mkdir -p "$dst"
  shopt -s nullglob
  for item in "$src"/*; do
    local name
    name="$(basename "$item")"
    if [[ -d "$item" ]]; then
      copy_tree_merge "$item" "$dst/$name" "$force"
    elif [[ "$force" -eq 1 || ! -e "$dst/$name" ]]; then
      cp -f "$item" "$dst/$name"
    fi
  done
}

require_cmd git
require_cmd node
[[ -d "$BUNDLE_CURSOR" ]] || { echo "Bundle not found: $BUNDLE_CURSOR" >&2; exit 1; }

echo "==> Installing to $USER_CURSOR"
mkdir -p "$USER_CURSOR"

echo "==> Skills"
copy_tree_merge "$BUNDLE_CURSOR/skills" "$USER_CURSOR/skills" "$OVERWRITE"

echo "==> Agents"
copy_tree_merge "$BUNDLE_CURSOR/agents" "$USER_CURSOR/agents" "$OVERWRITE"

echo "==> Rules"
copy_tree_merge "$BUNDLE_CURSOR/rules" "$USER_CURSOR/rules" "$OVERWRITE"

if [[ "$SKIP_HOOKS" -eq 0 ]]; then
  echo "==> Hooks"
  copy_tree_merge "$BUNDLE_CURSOR/hooks" "$USER_CURSOR/hooks" "$OVERWRITE"
fi

if [[ "$SKIP_MCP" -eq 0 && -f "$BUNDLE_CURSOR/mcp.json.example" ]]; then
  echo "==> MCP config (merge via python)"
  python3 - <<'PY' "$BUNDLE_CURSOR/mcp.json.example" "$USER_CURSOR/mcp.json"
import json, sys
from pathlib import Path

example_path, target_path = Path(sys.argv[1]), Path(sys.argv[2])
example = json.loads(example_path.read_text(encoding="utf-8"))
merged = {"mcpServers": {}}

if target_path.exists():
    existing = json.loads(target_path.read_text(encoding="utf-8"))
    merged["mcpServers"].update(existing.get("mcpServers", {}))

for name, cfg in example.get("mcpServers", {}).items():
    if name not in merged["mcpServers"]:
        merged["mcpServers"][name] = cfg
        continue
    current = merged["mcpServers"][name]
    incoming_env = cfg.get("env", {})
    current_env = current.setdefault("env", {})
    for key, val in incoming_env.items():
        if not current_env.get(key) or current_env.get(key) == "YOUR_TOKEN_HERE":
            current_env[key] = val

target_path.write_text(json.dumps(merged, indent=2) + "\n", encoding="utf-8")
PY
fi

skills=$(find "$USER_CURSOR/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
rules=$(find "$USER_CURSOR/rules" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
agents=$(find "$USER_CURSOR/agents" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')

echo "Installed/merged at $USER_CURSOR"
echo "  skills: $skills"
echo "  rules:  $rules"
echo "  agents: $agents"
echo
echo "Next steps:"
echo "  1. Restart Cursor"
echo "  2. Set GITHUB_PERSONAL_ACCESS_TOKEN in ~/.cursor/mcp.json"
echo "  3. Run bootstrap-project.ps1 (Windows) or copy bundle/specify + hooks.user.json manually"
echo "  4. Run verify.ps1 on Windows or hook smoke tests manually"
