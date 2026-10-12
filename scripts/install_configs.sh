#!/usr/bin/env bash
set -euo pipefail

case "$(hostname -s)" in
  team-12-en|team-12-nn|team-12-00|team-12-01) ;;
  *) printf 'Ошибка: команда запущена не на узле team-12\n'; exit 1 ;;
esac

hw2_source="$HOME/yarn-homework-2/config"
hw2_target="/opt/hadoop/etc/hadoop"

for name in mapred-site.xml yarn-site.xml yarn-env.sh; do
  test -r "$hw2_source/$name"
  test -r "$hw2_target/$name"
done

hw2_backup=$(mktemp -d "$HOME/yarn-homework-2/backup.XXXXXXXX")

for name in mapred-site.xml yarn-site.xml yarn-env.sh; do
  cp "$hw2_target/$name" "$hw2_backup/$name"
done

sudo -n install -m 644 \
  "$hw2_source/mapred-site.xml" \
  "$hw2_source/yarn-site.xml" \
  "$hw2_source/yarn-env.sh" \
  "$hw2_target/"

for name in mapred-site.xml yarn-site.xml yarn-env.sh; do
  cmp "$hw2_source/$name" "$hw2_target/$name"
done

printf '%s: конфиги установлены. Резервная копия: %s\n' \
  "$(hostname -s)" "$hw2_backup"
