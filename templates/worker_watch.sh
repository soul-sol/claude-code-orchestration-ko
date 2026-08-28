#!/usr/bin/env bash
set -u

# 사용법: worker_watch.sh <name> <pid> <log> <kind> <exit-file>
# kind: codex | other
# worker_launch.sh 가 남긴 .pid/.log/.exit 를 그대로 넘기면 됩니다.
# 마커는 로그 "말미"에서만 찾습니다 — 워커가 읽은 문서에 같은 문구가 되울릴 수 있기 때문입니다.
name="${1:?name required}"
pid="${2:?pid required}"
log="${3:?log required}"
kind="${4:?kind required}"
exit_file="${5:?exit-file required}"

if [[ ! "$pid" =~ ^[1-9][0-9]*$ ]]; then
  echo "STALL $name — invalid pid record"
  exit 2
fi

if kill -0 -- "$pid" 2>/dev/null; then
  echo "RUNNING $name pid=$pid"
  exit 0
fi

if [[ ! -f "$log" ]]; then
  echo "STALL $name — log missing"
  exit 2
fi

if [[ ! -f "$exit_file" ]]; then
  echo "STALL $name — process exited but exit code is unavailable"
  tail -n 12 "$log"
  exit 2
fi

exit_code=$(tr -d '[:space:]' < "$exit_file")
if [[ ! "$exit_code" =~ ^[0-9]+$ ]]; then
  echo "STALL $name — invalid exit code record"
  tail -n 12 "$log"
  exit 2
fi

if [[ "$exit_code" != "0" ]]; then
  echo "FAILED $name — exit=$exit_code"
  tail -n 12 "$log"
  exit 2
fi

if [[ "$kind" == "codex" ]]; then
  if tail -n 40 "$log" | grep -q "tokens used"; then
    echo "DONE $name — codex marker found"
    exit 0
  fi
else
  if tail -n 40 "$log" | grep -q "DONE"; then
    echo "DONE $name — exit=0 and conclusion found; inspect result body"
    tail -n 12 "$log"
    exit 0
  fi
  if tail -n 40 "$log" | grep -q "FAILED"; then
    echo "FAILED $name — worker reported failure"
    tail -n 12 "$log"
    exit 2
  fi
fi

echo "STALL $name — process exited without a completion conclusion"
tail -n 12 "$log"
exit 2
