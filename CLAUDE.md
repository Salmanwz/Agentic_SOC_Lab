# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

AI SOC Agents Lab — a portfolio/learning project building AI agents for SOC (Security Operations
Center) work: auto-triage of alerts, escalation decisions, and feedback-driven learning. Backed by
a self-hosted Wazuh SIEM fed with a ~120GB sample dataset of Splunk-format JSON logs. Inference
uses the Claude API (no local model hosting).

The design of record is the Notion page "Agentic SOC Triage Pipeline" (n8n SOAR, Postgres cases,
Chroma memory, three-agent pipeline, Discord); docs/architecture.md summarizes it.

Read [docs/architecture.md](docs/architecture.md) before making structural changes — it describes
the homelab deployment topology (Wazuh VM, DockerHome VM, Nextcloud cold storage) that this repo's
layout mirrors. Check [docs/roadmap.md](docs/roadmap.md) for current milestone status before
assuming a component (e.g. an agent framework) has been chosen — several decisions are explicitly
deferred until later milestones.

## Repo layout

- `infra/` — OpenTofu config that provisions the Wazuh Proxmox VM by cloning an existing
  cloud-init template. Provider is `bpg/proxmox`. Does not build the template itself; the
  `dockerhome` VM and Nextcloud already exist and are not managed here.
- `mcp-servers/` — MCP servers exposing SOC tooling to agents. Currently only `wazuh-mcp`, which
  talks to the Wazuh indexer's OpenSearch-compatible REST API to search/fetch alerts.
- `agents/` — the three-stage pipeline (Enrichment → Correlation → Review/Decision). Not yet built;
  framework choice deferred (see roadmap M5).
- `docker/docker-compose.yml` — services deployed to the DockerHome VM. Currently only `wazuh-mcp`;
  n8n, Postgres, and Chroma from the design are not added yet. Wazuh itself is **not** in this
  compose file — it runs on its own dedicated VM.
- `docs/` — architecture and roadmap.

## Working in `mcp-servers/wazuh-mcp`

- Built with the official Python MCP SDK (`mcp[cli]`), using `FastMCP` and the `streamable-http`
  transport so the server is reachable over the network from other DockerHome VM containers (not
  stdio — this isn't a locally-spawned subprocess setup).
- `wazuh_mcp/indexer_client.py` wraps the Wazuh indexer's OpenSearch `_search`/`_doc` REST API
  directly via `httpx`. There is no official Wazuh Python SDK in use — queries are raw OpenSearch
  query DSL (Lucene `query_string` + range filters).
- Config is env-var driven via `wazuh_mcp/config.py` (`load_settings()`), loaded from `.env`
  (see `.env.example` for the required keys: indexer URL/credentials, alerts index pattern, MCP
  bind host/port). There's no config file format beyond env vars.
- New tools go in `wazuh_mcp/server.py` as `@mcp.tool()`-decorated async functions; add supporting
  REST calls to `WazuhIndexerClient` in `indexer_client.py` rather than calling `httpx` directly
  from tool functions.

## Commands

```bash
# from infra/
tofu init
tofu plan
tofu apply               # provisions/updates the wazuh VM on Proxmox

# from mcp-servers/wazuh-mcp/
uv sync                 # install deps
uv run wazuh-mcp         # run the MCP server (streamable-http on MCP_HOST:MCP_PORT)

# from docker/
docker compose up --build wazuh-mcp   # build + run in a container (as deployed on DockerHome VM)
```

There is no test suite, linter, or CI configured yet.

## Conventions

- Python 3.11+, async I/O throughout for anything hitting the Wazuh indexer over HTTP.
- One MCP server per external system it talks to (e.g. `wazuh-mcp` only ever talks to Wazuh) —
  don't fold unrelated tool surfaces (Nextcloud, ticketing, etc.) into an existing server; add a
  new one under `mcp-servers/` instead.
