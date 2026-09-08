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

# ⛔ 완료 판정은 exit code 와 결과 본문으로만 한다. 마커 부재를 STALL 로 판정하지 않는다.
# (2026-08-19 사고: 정상 완료한 GLM·agy 를 codex 전용 마커가 없다는 이유로 STALL 로 오판했다.)
if tail -n 40 "$log" | grep -q "FAILED"; then
  echo "FAILED $name — worker reported failure"
  tail -n 12 "$log"
  exit 2
fi

# 마커는 보조 진단일 뿐이며 판정을 바꾸지 않는다.
marker="none"
if [[ "$kind" == "codex" ]] && tail -n 40 "$log" | grep -q "tokens used"; then
  marker="codex 'tokens used' 관측"
elif tail -n 40 "$log" | grep -q "DONE"; then
  marker="결론 줄 관측"
fi

echo "DONE $name — exit=0; 결과 본문을 읽고 판단하십시오 (보조 진단: $marker)"
tail -n 12 "$log"
exit 0
