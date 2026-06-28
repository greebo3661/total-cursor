---
name: voice-bot-stack
description: Use when working on Asterisk, WebRTC, SIP, RTP, coturn/ICE, the ARI Stasis gateway, ASR (GigaAM/Whisper), local LLM (Gemma4), TTS, or telephony acceptance tests in this repo. Provides architecture, host topology, and the authoritative runbook/checklist references.
---

# Voice-bot Stack

Domain knowledge for the telephony / voice-bot platform in this repository.

## Architecture

Caller dials extension `3003` in Asterisk -> ARI/Stasis gateway (`voice_bot`) accepts RTP ->
audio sent to ASR on the Windows host (Whisper or GigaAM) -> prompt built ->
local LLM on Windows (Gemma4-2B / avibe) -> response synthesized via MOSS-TTS on Linux ->
audio played back into the channel.

- Windows host (Asterisk + ASR + LLM): `192.168.148.109`
- Linux host (gateway + TTS): `192.168.149.194`

## Authoritative references

Always consult these before changing config (they are the source of truth):

- `VOICE-BOT-HANDOFF.md` — architecture, hosts, ports, components
- `CONTAINERS.md` — container map
- `asterisk/docs/asterisk-webrtc/README.md` — WebRTC setup sequence (numbered 01..21)
- `asterisk/docs/asterisk-webrtc/08-checklist.md` — verification checklist
- `asterisk/docs/asterisk-webrtc/14-incompatible-sdp-checklist.md` — SDP/488 issues
- `asterisk/docs/asterisk-webrtc/18-one-way-audio-turn.md` — one-way audio / TURN
- `asterisk/docs/asterisk-webrtc/03-rtp-ice-docker.md` — RTP/ICE under Docker
- `asterisk/docs/asterisk-webrtc/05-coturn.md` — coturn config

## Services

- `gigaam/` — ASR (`main.py`, `transcriber.py`); acceptance: `gigaam/scripts/run-acceptance-tests.ps1`
- `gemma4-4b/` — LLM inference; acceptance: `gemma4-4b/scripts/run-acceptance-tests.ps1`
- `asterisk/` — PBX configs in `etc/` (`pjsip_*.conf`, `extensions_custom.conf`, `rtp.conf`)

## Workflow

1. Identify which layer is affected: Asterisk/SIP, WebRTC/ICE, ASR, LLM, or TTS.
2. Read the matching runbook(s) above and restate the relevant constraints.
3. Make the change; keep Docker networking constraints in mind for RTP/ICE/coturn.
4. Verify:
   - Asterisk/dialplan/pjsip: `asterisk/scripts/test-voice-bot-asterisk.ps1`
   - ASR: `gigaam/scripts/run-acceptance-tests.ps1`
   - LLM: `gemma4-4b/scripts/run-acceptance-tests.ps1`
5. Update the corresponding runbook/checklist when behavior changes.

## Guardrails

- Never commit real SIP credentials or host passwords; rotate immediately if leaked.
- Do not change ports/IPs without updating `VOICE-BOT-HANDOFF.md` and `CONTAINERS.md`.
- One-way audio and 488 errors almost always trace to ICE/TURN/SDP — check those runbooks first.
