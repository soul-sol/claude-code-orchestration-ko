# 혼자서 팀처럼: Claude Code 멀티 에이전트 오케스트레이션 실전

**codex · GLM · Gemini CLI 워커 풀을 Claude가 지휘하게 만들어, 한도는 아끼고 구현은 병렬로 늘리는 실전 가이드**

## 이 책은 무엇인가요?

이 저장소는 전자책 『혼자서 팀처럼: Claude Code 멀티 에이전트 오케스트레이션 실전』의 공식 안내 및 무료 공개 자료를 담고 있습니다.

Claude Max 한도가 금방 바닥나는 분, 에이전트 하나가 오래 생각만 하는 걸 지켜본 적 있는 분을 위한 **실제 운영 매뉴얼**입니다. 단순한 "AI 코딩 팁"이 아니라, Claude Code 세션 하나를 지휘관으로 두고 codex, GLM, Gemini를 동시에 백그라운드 워커로 부리는 구체적인 오케스트레이션 규칙과 스크립트를 담았습니다.

## 무료 공개 자료

도입부와 핵심 템플릿 일부를 무료로 공개합니다:

- 📖 **[무료 미리보기 PDF (0장 ~ 2장)](./preview/혼자서-팀처럼-미리보기.pdf)**
- 📝 **[작업 명세 템플릿 (task_spec_template.md)](./templates/task_spec_template.md)**
- 🛡️ **[안전 금지 목록 (safety_denylist.md)](./templates/safety_denylist.md)**

## 전체 목차

0. 들어가며: 왜 "지휘관 + 워커 풀"인가
1. 역할 분리 설계 — Claude는 지휘관, 나머지는 손
2. 30분 세팅 — 워커 5기 설치·인증·래퍼
3. 워커가 멈추지 않는 작업 명세 쓰는 법
4. 병렬 분배와 git worktree
5. Stall 감지 — 워커가 죽었는지 살았는지 아는 법
6. 검증 게이트와 codex 적대적 리뷰
7. 재배정과 장애 대응 — 폴백 체인이 아니다
8. 한도·비용 정책 — Claude 한도를 안 먹는 구조
9. 안전 경계 — 브라우저·계정·비밀정보
10. 세션 간 기억 — 메모리 파일·SESSION-STATE·진행 보고
11. 사례: 4시간 동안 워커 5기로 기능 3개 출시하기
12. 템플릿 모음(복붙용)

## 전체본 구매하기

본문 전체(약 90쪽)와 모든 템플릿 파일이 포함된 전체 패키지는 아래 링크에서 구매하실 수 있습니다. (환불 보장)

👉 **[전체본 구매하기 (Gumroad)](https://lifestep1.gumroad.com/l/solo-team-claude-code-orchestration)**

## 저자 소개

2026년 7월부터 8월까지 직접 5기의 워커 풀을 운영하며 겪은 실제 사례를 바탕으로 이 책을 작성했습니다. 과장된 성과나 막연한 개념을 배제하고, 에이전트가 승인 대기 중 멈춘 것을 완료로 착각한 사고(2026-08-18), 브라우저 자동화가 2천 개의 북마크를 날려버린 사고(2026-08-20) 등 실패 경험과 이를 방어하기 위해 직접 짜고 다듬은 쉘 스크립트, 프롬프트, 감시 체계를 있는 그대로 담았습니다.

## 라이선스

- 본문 PDF 및 구매하신 콘텐츠: All rights reserved (무단 전재 및 재배포 금지)
- 이 저장소에 공개된 템플릿 파일(`templates/`): MIT License

---

## English Summary

**A field manual for running one Claude Code session as the commander of a worker pool (codex, GLM, Gemini).**

This repository contains the public introduction and free materials for the Korean digital book "Solo as a Team: Claude Code Multi-Agent Orchestration". It shows how to save your Claude quota for judgment and architecture, while delegating the heavy coding/search loops to background workers.

- **Free Preview (Ch 0~2):** [`./preview/혼자서-팀처럼-미리보기.pdf`](./preview/혼자서-팀처럼-미리보기.pdf)
- **Free Templates:** [Task Spec](./templates/task_spec_template.md) / [Safety Denylist](./templates/safety_denylist.md)
- **Purchase Full Bundle:** **[https://lifestep1.gumroad.com/l/solo-team-claude-code-orchestration](https://lifestep1.gumroad.com/l/solo-team-claude-code-orchestration)**

**License:** Public templates in this repository are under the MIT License. The book content itself is All rights reserved.

## English edition

**Solo, Like a Team — Claude Code Multi-Agent Orchestration in Practice** (165-page PDF + 8 English templates): https://lifestep1.gumroad.com/l/solo-like-a-team-claude-code-orchestration

## Free review prompts: https://github.com/soul-sol/ai-code-review-prompts

Related: The Adversarial Review Prompt Pack

25 prompts that attack AI-written code before you merge it — the chapter 6 review gate, expanded into a standalone pack (55-page PDF + 25 copy-paste prompt files, EN + 한국어 가이드): https://lifestep1.gumroad.com/l/adversarial-review-prompt-pack

## Tools

- [agent-watch](https://github.com/soul-sol/agent-watch) — RUNNING/DONE/FAILED/STALL detection for background AI agents (MIT)
- [ai-code-review-prompts](https://github.com/soul-sol/ai-code-review-prompts) — adversarial review prompts for AI-written code (MIT)

<!-- xlink:start -->
## Related free tools

- [XLSX Inspector](https://xlsx.lifestep.io) — check workbooks for macros, external links and hidden sheets
- [DNS and SPF Check](https://dnscheck.lifestep.io) — records, SPF, DMARC and TLS expiry
- [Email Validator](https://emailcheck.lifestep.io) — syntax, MX, disposable and role addresses
- [QR Code Generator](https://qrcode.lifestep.io) — free PNG and SVG API, no signup
- [agent-watch](https://github.com/soul-sol/agent-watch)
- [ai-code-review-prompts](https://github.com/soul-sol/ai-code-review-prompts)
- [claude-md-patterns](https://github.com/soul-sol/claude-md-patterns)
- [xlsx-inspector-api](https://github.com/soul-sol/xlsx-inspector-api)
- [domain-info-api](https://github.com/soul-sol/domain-info-api)
- [email-validator-api](https://github.com/soul-sol/email-validator-api)
- [qr-code-api](https://github.com/soul-sol/qr-code-api)
- [Agent Ops for VS Code](https://github.com/soul-sol/vscode-agent-ops) - review prompts and agent rules in the Command Palette (VSIX install)
- [Go Exec Format Doctor Action](https://github.com/soul-sol/go-exec-format-doctor) - CI gate for binary architecture mismatches

The paid guide collection is available at [lifestep1.gumroad.com](https://lifestep1.gumroad.com).
<!-- xlink:end -->
