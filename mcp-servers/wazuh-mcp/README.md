# wazuh-mcp

MCP server exposing Wazuh alert search/lookup as tools, backed by the Wazuh indexer's
OpenSearch-compatible REST API.

## Tools

- `search_alerts(query, size, min_severity)` — Lucene query string search over the alerts index.
- `get_alert(alert_id)` — fetch a single alert document by id.

## Config

Copy `.env.example` to `.env` and fill in the Wazuh indexer URL/credentials for your homelab VM.

## Run

```bash
uv sync
uv run wazuh-mcp
```

(or `pip install -e .` + `python -m wazuh_mcp.server` if not using `uv`)

Runs as a streamable-http MCP server bound to `MCP_HOST:MCP_PORT` (default `0.0.0.0:8000`), so it's
reachable from other containers on the DockerHome VM.
