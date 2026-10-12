#!/usr/bin/env bash
set -euo pipefail

ssh -n -o BatchMode=yes -o ConnectTimeout=10 \
  -i "$HOME/.ssh/team_internal" team@team-12-nn \
  'sudo -n -iu hadoop /opt/hadoop/sbin/stop-yarn.sh'
