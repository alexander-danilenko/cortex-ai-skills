#!/usr/bin/env bash
set -euo pipefail

# ── Configuration ─────────────────────────────────────────────
PLAN_FILE="${1:-audit-plan.md}"
ALLOWED_TOOLS="${2:-Read,Glob,Grep,Edit}"
COMPLETION_MARKER="RALPH_DONE"
LOG_FILE="ralph-$(date +%Y%m%d-%H%M%S).log"

# ── Colors ────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

divider="════════════════════════════════════════════════════════════════"
subdiv="────────────────────────────────────────────────────────────────"

# ── Helpers ───────────────────────────────────────────────────
count_remaining() { grep -c '^\- \[ \]' "$PLAN_FILE" || true; }
count_done()      { grep -c '^\- \[x\]' "$PLAN_FILE" || true; }

next_item() {
  grep '^\- \[ \]' "$PLAN_FILE" | head -1 | sed 's/^- \[ \] //' || echo "(none)"
}

# ── Banner ────────────────────────────────────────────────────
iteration=0
remaining_init=$(count_remaining)
done_init=$(count_done)
total_items=$(( ${remaining_init:-0} + ${done_init:-0} ))
# Extra passes for wrap-up/retries
BUFFER=3
MAX_ITERATIONS=$(( ${remaining_init:-0} + BUFFER ))

echo -e "${BOLD}${CYAN}${divider}${RESET}"
echo -e "${BOLD}${CYAN}  Ralph Loop${RESET}"
echo -e "${BOLD}${CYAN}${divider}${RESET}"
echo -e "  Plan:            ${BOLD}${PLAN_FILE}${RESET}"
echo -e "  Items:           ${BOLD}${total_items}${RESET} (${done_init} done, ${remaining_init} remaining)"
echo -e "  Max iterations:  ${BOLD}${MAX_ITERATIONS}${RESET}"
echo -e "  Allowed tools:   ${BOLD}${ALLOWED_TOOLS}${RESET}"
echo -e "  Log:             ${BOLD}${LOG_FILE}${RESET}"
echo -e "  Started:         ${BOLD}$(date '+%Y-%m-%d %H:%M:%S')${RESET}"
echo -e "${CYAN}${divider}${RESET}"
echo ""

# ── Main loop ─────────────────────────────────────────────────
while [ $iteration -lt $MAX_ITERATIONS ]; do
  iteration=$((iteration + 1))
  remaining=$(count_remaining)
  done_count=$(count_done)
  next=$(next_item)

  echo -e "${BOLD}${YELLOW}── Iteration ${iteration}/${MAX_ITERATIONS} ${subdiv:0:40}${RESET}"
  echo -e "  Progress:  ${GREEN}${done_count}${RESET}/${total_items}  (${remaining} remaining)"
  echo -e "  Next:      ${BOLD}${next}${RESET}"
  echo -e "  Time:      $(date '+%H:%M:%S')"
  echo -e "${DIM}${subdiv}${RESET}"
  echo ""

  start_time=$(date +%s)
  output=$(cat "$PLAN_FILE" | claude --print --allowedTools "$ALLOWED_TOOLS" 2>&1 | tee -a "$LOG_FILE")
  end_time=$(date +%s)
  elapsed=$(( end_time - start_time ))

  echo ""
  echo -e "${DIM}  Iteration took ${elapsed}s${RESET}"

  # ── Completion: marker found in output ──
  if echo "$output" | grep -q "$COMPLETION_MARKER"; then
    echo ""
    echo -e "${BOLD}${GREEN}${divider}${RESET}"
    echo -e "${BOLD}${GREEN}  COMPLETE${RESET}"
    echo -e "${BOLD}${GREEN}${divider}${RESET}"
    echo -e "  Finished in ${BOLD}${iteration}${RESET} iterations"
    echo -e "  Time:  $(date '+%Y-%m-%d %H:%M:%S')"
    echo -e "  Log:   ${LOG_FILE}"
    echo -e "${GREEN}${divider}${RESET}"
    exit 0
  fi

  # ── Completion: all checkboxes checked ──
  if ! grep -q '^\- \[ \]' "$PLAN_FILE"; then
    echo ""
    echo -e "${BOLD}${GREEN}${divider}${RESET}"
    echo -e "${BOLD}${GREEN}  CHECKLIST COMPLETE${RESET}"
    echo -e "${BOLD}${GREEN}${divider}${RESET}"
    echo -e "  All items checked after ${BOLD}${iteration}${RESET} iterations"
    echo -e "  Running final pass for wrap-up..."
    echo -e "${GREEN}${divider}${RESET}"
    echo ""
    cat "$PLAN_FILE" | claude --print --allowedTools "$ALLOWED_TOOLS" 2>&1 | tee -a "$LOG_FILE"
    echo ""
    echo -e "${GREEN}  Done. Log: ${LOG_FILE}${RESET}"
    exit 0
  fi

  echo ""
done

# ── Timeout ───────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${RED}${divider}${RESET}"
echo -e "${BOLD}${RED}  MAX ITERATIONS REACHED${RESET}"
echo -e "${BOLD}${RED}${divider}${RESET}"
echo -e "  Stopped after ${MAX_ITERATIONS} iterations."
echo -e "  Check ${BOLD}${PLAN_FILE}${RESET} for progress."
echo -e "  Log: ${LOG_FILE}"
echo -e "${RED}${divider}${RESET}"
exit 1
