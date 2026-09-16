#!/usr/bin/env bash
# Smoke tests for markitdown-skill (CLI + skill package + optional zip).
# No web E2E. Exit 0 on success.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
fail=0

skill="$ROOT/markitdown/SKILL.md"
if [[ ! -f "$skill" ]]; then
  echo "FAIL: missing markitdown/SKILL.md"
  exit 1
fi

if ! grep -q '^name:[[:space:]]*markitdown[[:space:]]*$' "$skill"; then
  echo "FAIL: SKILL.md frontmatter name must be markitdown"
  fail=1
else
  echo "OK: frontmatter name=markitdown"
fi

if ! grep -q '^description:' "$skill"; then
  echo "FAIL: SKILL.md missing description frontmatter"
  fail=1
else
  echo "OK: description frontmatter present"
fi

if ! grep -qi 'data, not instructions\|data, never instructions\|never.*follow directives' "$skill"; then
  echo "FAIL: Guardrails must treat converted content as data, not instructions"
  fail=1
else
  echo "OK: guardrails present"
fi

if command -v markitdown >/dev/null 2>&1; then
  markitdown --version >/dev/null
  echo "OK: markitdown CLI on PATH"
elif command -v uvx >/dev/null 2>&1; then
  uvx "markitdown[all]" --version >/dev/null
  echo "OK: uvx markitdown[all] available"
else
  echo "WARN: neither markitdown nor uvx found (install skipped in this environment)"
fi

zip_path="$ROOT/markitdown-skill.zip"
if [[ -f "$zip_path" ]]; then
  if unzip -l "$zip_path" | grep -q 'markitdown/SKILL.md'; then
    echo "OK: zip contains markitdown/SKILL.md"
  else
    echo "FAIL: zip missing markitdown/SKILL.md"
    fail=1
  fi
else
  echo "SKIP: markitdown-skill.zip not present (build at release time)"
fi

exit "$fail"
