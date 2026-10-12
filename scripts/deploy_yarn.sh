#!/usr/bin/env bash
set -euo pipefail

hw2_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hw2_key="$HOME/.ssh/team_internal"

if [ "$(hostname -s)" != "team-12-en" ] || [ "$(id -un)" != "team" ]; then
  echo "Запускайте этот скрипт от team на team-12-en"
  exit 1
fi

bash "$hw2_root/scripts/install_configs.sh"
sudo -n -u hadoop mkdir -p /home/hadoop/yarn-logs

for node in team-12-nn team-12-00 team-12-01; do
  ssh -n -o BatchMode=yes -o ConnectTimeout=10 -i "$hw2_key" "team@$node" \
    'mkdir -p "$HOME/yarn-homework-2/config"'

  scp -o BatchMode=yes -o ConnectTimeout=10 -i "$hw2_key" \
    "$hw2_root/config/mapred-site.xml" \
    "$hw2_root/config/yarn-site.xml" \
    "$hw2_root/config/yarn-env.sh" \
    "team@$node:yarn-homework-2/config/"

  ssh -o BatchMode=yes -o ConnectTimeout=10 -i "$hw2_key" "team@$node" \
    'bash -s' < "$hw2_root/scripts/install_configs.sh"

  ssh -n -o BatchMode=yes -o ConnectTimeout=10 -i "$hw2_key" "team@$node" \
    'sudo -n -u hadoop mkdir -p /home/hadoop/yarn-logs'
done

bash "$hw2_root/scripts/start_yarn.sh"
