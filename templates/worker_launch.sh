#!/usr/bin/env bash
# 사용법: worker_launch.sh <name> <logdir> -- <command...>
# 워커를 백그라운드로 띄우고 <logdir>/<name>.log, .pid, .exit 를 남깁니다.
# 예: worker_launch.sh sol_a ./logs -- codex exec --skip-git-repo-check -C "$PWD" -m gpt-5.6-sol -s workspace-write "지시"
set -u
name="${1:?name required}"; logdir="${2:?logdir required}"; shift 2
[[ "${1:-}" == "--" ]] && shift
mkdir -p "$logdir"
log="$logdir/$name.log"; pidf="$logdir/$name.pid"; exitf="$logdir/$name.exit"
rm -f "$exitf"
(
  "$@" > "$log" 2>&1
  echo $? > "$exitf"
) &
echo $! > "$pidf"
echo "LAUNCHED $name pid=$(cat "$pidf") log=$log"
