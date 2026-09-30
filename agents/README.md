# agents

Not yet scaffolded. Planned three-stage pipeline (see [../docs/architecture.md](../docs/architecture.md)):

1. **Enrichment** — user/role context, alert volume normalcy vs. peer group.
2. **Correlation** — rule-table fast path + top-k similar closed cases from Chroma.
3. **Review/Decision** — disposition, confidence, cited precedent; below-threshold goes to a human.

Kept as three stages rather than one tool-using agent on purpose (cost/latency tradeoff is part of
the portfolio story). Framework choice (Claude Agent SDK vs. custom orchestration) is deferred until
`wazuh-mcp` works against real data (roadmap M5).
