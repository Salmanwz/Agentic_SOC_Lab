# Roadmap

Rough milestone order, aligned with the Notion design (see [architecture.md](architecture.md)).
Update as work progresses.

- [ ] **M1 — Ingestion**: Wazuh on the Wazuh VM; custom decoder for the Splunk JSON schema; replay
      the dataset from Nextcloud; confirm alerts are queryable in the indexer.
- [ ] **M1b — Detection rules**: decoder + rules (MITRE-tagged) so the dataset produces alerts;
      see [detection-rules.md](detection-rules.md). Blocked on sample events.
- [ ] **M2 — Wazuh MCP tool**: `wazuh-mcp` `search_alerts` / `get_alert` working against the live
      indexer and reachable from the DockerHome VM.
- [ ] **M3 — Orchestration + cases**: n8n on DockerHome receives Wazuh alerts, writes/reads a case
      table in Postgres, and sends Discord notifications (throttled per case update).
- [ ] **M4 — Knowledge store + call tracking**: Chroma with closed-case backfill; `llm_calls`
      Postgres table.
- [ ] **M5 — Three-agent pipeline**: Enrichment → Correlation → Review/Decision using the Claude
      API, calling `wazuh-mcp` and Chroma; low-confidence cases routed to human review.
- [ ] **M6 — Feedback loop**: human confirm/override writes back to Chroma as labeled cases.
- [ ] **Later**: Langfuse trace UI; CMU Insider Threat dataset as a DLP scenario.

Decision still deferred until M5: agent framework (Claude Agent SDK vs. custom orchestration).
