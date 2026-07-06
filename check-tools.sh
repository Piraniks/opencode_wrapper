#!/bin/sh
set -e

PASS=0
WARN=0
FAIL=0

print_result() {
  _label="$1"
  _msg="$2"
  case "$_label" in
    pass) printf "  [PASS] %s\n" "$_msg" ;;
    warn) printf "  [WARN] %s\n" "$_msg" ;;
    fail) printf "  [FAIL] %s\n" "$_msg" ;;
  esac
}

check_cmd() {
  _tool="$1"
  _hint="${2:-}"
  if command -v "$_tool" >/dev/null 2>&1; then
    PASS=$((PASS + 1))
    print_result pass "$_tool — found"
  else
    FAIL=$((FAIL + 1))
    print_result fail "$_tool — NOT FOUND${_hint:+ ($_hint)}"
  fi
}

check_file() {
  _path="$1"
  _hint="${2:-}"
  if [ -f "$_path" ]; then
    PASS=$((PASS + 1))
    print_result pass "file $_path — exists"
  else
    FAIL=$((FAIL + 1))
    print_result fail "file $_path — NOT FOUND${_hint:+ ($_hint)}"
  fi
}

check_dir() {
  _path="$1"
  _hint="${2:-}"
  if [ -d "$_path" ]; then
    PASS=$((PASS + 1))
    print_result pass "directory $_path — exists"
  else
    FAIL=$((FAIL + 1))
    print_result fail "directory $_path — NOT FOUND${_hint:+ ($_hint)}"
  fi
}

section() {
  echo ""
  echo "=== $1 ==="
}

echo "check-tools.sh — tooling availability audit"
echo "============================================"
echo "date: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"

section "APT packages (setup.sh + Dockerfile)"

check_cmd curl
check_cmd docker
check_cmd git
check_cmd jq
check_cmd rg "package: ripgrep"
check_cmd less
check_cmd make
check_cmd python3
check_cmd pipx
check_cmd yq
check_cmd node "package: nodejs"

section "npm (apt)"

check_cmd npm

section "pipx-installed tools (Dockerfile)"

check_cmd poetry
check_cmd uv

section "npm global tools (Dockerfile)"

check_cmd opencode

section "Docker tooling"

if command -v docker >/dev/null 2>&1; then
  if docker compose version >/dev/null 2>&1; then
    PASS=$((PASS + 1))
    print_result pass "docker compose — found"
  else
    WARN=$((WARN + 1))
    print_result warn "docker compose — not available"
  fi

  if docker info >/dev/null 2>&1; then
    PASS=$((PASS + 1))
    print_result pass "dockerd — reachable"
  else
    WARN=$((WARN + 1))
    print_result warn "dockerd — NOT reachable"
  fi
else
  FAIL=$((FAIL + 1))
  print_result fail "docker compose — skipped (docker not found)"
  FAIL=$((FAIL + 1))
  print_result fail "dockerd — skipped (docker not found)"
fi

section "Shell utilities (opencode.json allow rules)"

for _util in cat echo pwd mkdir touch mv wc uniq xargs tee file which rm ls grep find cp sed awk sort head tail diff; do
  check_cmd "$_util"
done

check_cmd wget

section "Python venv"

if command -v python3 >/dev/null 2>&1; then
  if python3 -m venv --help >/dev/null 2>&1; then
    PASS=$((PASS + 1))
    print_result pass "python3 -m venv — works"
  else
    FAIL=$((FAIL + 1))
    print_result fail "python3 -m venv — NOT available"
  fi
fi

section "Configuration files"

check_file /opencode_config/opencode/opencode.json "opencode configuration"
check_dir /opencode_config/opencode/agents "opencode agent definitions"

section "Script availability"

check_file /usr/local/bin/check-tools "check-tools.sh mounted via docker-compose"

section "Environment"

if [ -n "${OPENCODE_DISABLE_AUTO_UPDATE:-}" ]; then
  PASS=$((PASS + 1))
  print_result pass "OPENCODE_DISABLE_AUTO_UPDATE is set"
else
  WARN=$((WARN + 1))
  print_result warn "OPENCODE_DISABLE_AUTO_UPDATE is not set"
fi

if [ -n "${XDG_CONFIG_HOME:-}" ]; then
  PASS=$((PASS + 1))
  print_result pass "XDG_CONFIG_HOME=$XDG_CONFIG_HOME"
else
  WARN=$((WARN + 1))
  print_result warn "XDG_CONFIG_HOME is not set"
fi

echo ""
echo "============================================"
_total=$((PASS + WARN + FAIL))
echo "Results:  $PASS passed, $WARN warned, $FAIL failed  (total: $_total checks)"
echo ""

if [ "$FAIL" -gt 0 ]; then
  echo "Some required tools are missing. Review the FAIL lines above."
  exit 1
else
  echo "All required tooling is available."
  exit 0
fi
