#!/usr/bin/env bash
set -euo pipefail

report=$(ssh -n -o BatchMode=yes -o ConnectTimeout=10 \
  -i "$HOME/.ssh/team_internal" team@team-12-nn \
  'sudo -n -iu hadoop timeout 60s /opt/hadoop/bin/yarn node -list -all')
printf '%s\n' "$report"

# Require exactly the three intended workers in RUNNING state.
printf '%s\n' "$report" | awk '
  /^Total Nodes:/ { total = $0; sub(/^Total Nodes:[[:space:]]*/, "", total) }
  $1 ~ /^team-12-/ {
    name = $1
    sub(/:.*/, "", name)
    sub(/\.hse\.c\.mws$/, "", name)
    if (name != "team-12-en" && name != "team-12-00" && name != "team-12-01") bad = 1
    if ($2 != "RUNNING" || seen[name]++) bad = 1
    count++
  }
  END { exit !(total == "3" && count == 3 && !bad) }
' || { echo 'ERROR: ожидались ровно три рабочих узла RUNNING' >&2; exit 1; }
