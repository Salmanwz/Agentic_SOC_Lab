from typing import Any

from mcp.server.fastmcp import FastMCP

from .config import load_settings
from .indexer_client import WazuhIndexerClient

settings = load_settings()
client = WazuhIndexerClient(settings)

mcp = FastMCP("wazuh-mcp", host=settings.mcp_host, port=settings.mcp_port)


@mcp.tool()
async def search_alerts(
    query: str = "",
    size: int = 20,
    min_severity: int | None = None,
) -> list[dict[str, Any]]:
    """Search Wazuh alerts.

    Args:
        query: Lucene query string (e.g. "rule.groups:authentication_failed"). Empty matches all.
        size: Max number of alerts to return (default 20).
        min_severity: If set, only return alerts with rule.level >= this value.
    """
    return await client.search_alerts(query=query, size=size, min_severity=min_severity)


@mcp.tool()
async def get_alert(alert_id: str) -> dict[str, Any] | None:
    """Fetch a single Wazuh alert by its indexer document id."""
    return await client.get_alert(alert_id)


def main() -> None:
    mcp.run(transport="streamable-http")


if __name__ == "__main__":
    main()
