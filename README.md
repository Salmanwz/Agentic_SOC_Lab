# AI SOC Agents Lab

A portfolio/learning project: AI agents for SOC (Security Operations Center) work — auto-triage of
alerts, escalation decisions, and feedback-driven learning — built on top of a self-hosted Wazuh
SIEM, fed by a ~120GB sample dataset of Splunk-format JSON logs.

## Goals

- Ingest a large sample dataset of security logs into Wazuh for realistic alert data.
- Build MCP (Model Context Protocol) servers that expose SOC tooling (alert search, enrichment,
  case context) to agents.
- Build agents (using the Claude API) that triage incoming alerts, decide on escalation, and learn
  from analyst feedback.
- Deploy the whole thing across a homelab: cold log storage in Nextcloud, live indices + Wazuh on a
  dedicated VM, and agents/MCP servers on a separate DockerHome VM.

See [docs/architecture.md](docs/architecture.md) for the full deployment layout and
[docs/roadmap.md](docs/roadmap.md) for milestone status.

## Repo layout

```
infra/          OpenTofu config provisioning the Proxmox VMs (wazuh, dockerhome)
mcp-servers/    MCP servers exposing SOC tools (Wazuh alert search, etc.) to agents
agents/         Agent implementations (triage, escalation, feedback) — not yet scaffolded
docker/         docker-compose files for services that run on the DockerHome VM
docs/           Architecture notes, setup docs, roadmap
```

## Status

Early scaffolding. First milestone: get sample logs into Wazuh and stand up a minimal MCP server
that can query Wazuh alerts, so a single agent can do basic auto-triage against real data.
