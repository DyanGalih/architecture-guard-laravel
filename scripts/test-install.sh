#!/usr/bin/env bash
# test-install.sh — Smoke tests for the architecture-guard-laravel adapter.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXT_ROOT="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

TESTS=0
FAILURES=0

assert_file_exists() {
  TESTS=$((TESTS + 1))
  if [ -f "$1" ]; then
    echo -e "  ${GREEN}✓${NC} $2"
  else
    echo -e "  ${RED}✗${NC} $2 — file not found: $1"
    FAILURES=$((FAILURES + 1))
  fi
}

assert_contains() {
  TESTS=$((TESTS + 1))
  if grep -q "$2" "$1" 2>/dev/null; then
    echo -e "  ${GREEN}✓${NC} $3"
  else
    echo -e "  ${RED}✗${NC} $3 — pattern not found in $1"
    FAILURES=$((FAILURES + 1))
  fi
}

# --- Test: Repo has required files ---
echo ""
echo "Test: Repository structure is valid"

assert_file_exists "$EXT_ROOT/extension.yml" "extension.yml exists"
assert_file_exists "$EXT_ROOT/README.md" "README.md exists"
assert_file_exists "$EXT_ROOT/LICENSE" "LICENSE exists"
assert_file_exists "$EXT_ROOT/CONTRIBUTING.md" "CONTRIBUTING.md exists"

# --- Test: Command file exists ---
echo ""
echo "Test: Command file exists"

assert_file_exists "$EXT_ROOT/commands/laravel-guidance.md" "laravel-guidance.md exists"

# --- Test: extension.yml references resolve ---
echo ""
echo "Test: extension.yml command files resolve"

while IFS= read -r line; do
  file_ref=$(echo "$line" | sed "s/.*file: *'\{0,1\}\([^']*\)'\{0,1\}/\1/")
  if [ -n "$file_ref" ]; then
    file_ref=$(echo "$file_ref" | tr -d '"' | tr -d "'")
    assert_file_exists "$EXT_ROOT/$file_ref" "extension.yml ref: $file_ref"
  fi
done < <(grep 'file:' "$EXT_ROOT/extension.yml")

# --- Test: Command is self-contained ---
echo ""
echo "Test: Command is self-contained"

TESTS=$((TESTS + 1))
if grep -rl "Use the rules from" "$EXT_ROOT/commands/" 2>/dev/null | grep -q .; then
  echo -e "  ${RED}✗${NC} Found commands referencing external rule files"
  FAILURES=$((FAILURES + 1))
else
  echo -e "  ${GREEN}✓${NC} No commands reference external rule files"
fi

# --- Test: Command has required sections ---
echo ""
echo "Test: Command has required content"

assert_contains "$EXT_ROOT/commands/laravel-guidance.md" "^---" "has YAML frontmatter"
assert_contains "$EXT_ROOT/commands/laravel-guidance.md" "Entry Boundary" "covers Entry Boundary"
assert_contains "$EXT_ROOT/commands/laravel-guidance.md" "Validation Boundary" "covers Validation Boundary"
assert_contains "$EXT_ROOT/commands/laravel-guidance.md" "Contract Boundary" "covers Contract Boundary"
assert_contains "$EXT_ROOT/commands/laravel-guidance.md" "Application Boundary" "covers Application Boundary"
assert_contains "$EXT_ROOT/commands/laravel-guidance.md" "Domain Boundary" "covers Domain Boundary"
assert_contains "$EXT_ROOT/commands/laravel-guidance.md" "Data Boundary" "covers Data Boundary"
assert_contains "$EXT_ROOT/commands/laravel-guidance.md" "Integration Boundary" "covers Integration Boundary"
assert_contains "$EXT_ROOT/commands/laravel-guidance.md" "Presentation Boundary" "covers Presentation Boundary"
assert_contains "$EXT_ROOT/commands/laravel-guidance.md" "Controller" "mentions Controllers"
assert_contains "$EXT_ROOT/commands/laravel-guidance.md" "Form Request" "mentions Form Requests"
assert_contains "$EXT_ROOT/commands/laravel-guidance.md" "API Resource" "mentions API Resources"
assert_contains "$EXT_ROOT/commands/laravel-guidance.md" "Eloquent" "mentions Eloquent"
assert_contains "$EXT_ROOT/commands/laravel-guidance.md" "Constitution" "references Constitution"

# --- Test: extension.yml declares dependency ---
echo ""
echo "Test: extension.yml declares architecture-guard dependency"

assert_contains "$EXT_ROOT/extension.yml" "architecture-guard" "requires architecture-guard"

# --- Summary ---
echo ""
if [ "$FAILURES" -eq 0 ]; then
  echo -e "${GREEN}All $TESTS smoke tests passed.${NC}"
  exit 0
else
  echo -e "${RED}$FAILURES of $TESTS tests failed.${NC}"
  exit 1
fi
