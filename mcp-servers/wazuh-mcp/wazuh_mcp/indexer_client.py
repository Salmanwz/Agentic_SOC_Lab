from typing import Any

import httpx

from .config import Settings


class WazuhIndexerClient:
    """Thin wrapper around the Wazuh indexer's OpenSearch-compatible REST API."""

    def __init__(self, settings: Settings):
        self._settings = settings
        self._client = httpx.AsyncClient(
            base_url=settings.indexer_url,
            auth=(settings.indexer_user, settings.indexer_password),
            verify=settings.verify_ssl,
            timeout=30.0,
        )

    async def aclose(self) -> None:
        await self._client.aclose()

    async def search_alerts(
        self,
        query: str,
        size: int = 20,
        min_severity: int | None = None,
    ) -> list[dict[str, Any]]:
        """Search alerts using a Lucene query string, optionally filtered by min rule severity."""
        must: list[dict[str, Any]] = [{"query_string": {"query": query}}] if query else []
        filters: list[dict[str, Any]] = []
        if min_severity is not None:
            filters.append({"range": {"rule.level": {"gte": min_severity}}})

        body = {
            "size": size,
            "sort": [{"@timestamp": {"order": "desc"}}],
            "query": {"bool": {"must": must or {"match_all": {}}, "filter": filters}},
        }

        resp = await self._client.post(
            f"/{self._settings.alerts_index}/_search",
            json=body,
        )
        resp.raise_for_status()
        hits = resp.json()["hits"]["hits"]
        return [{"id": hit["_id"], **hit["_source"]} for hit in hits]

    async def get_alert(self, alert_id: str) -> dict[str, Any] | None:
        """Fetch a single alert document by its indexer document id."""
        resp = await self._client.get(
            f"/{self._settings.alerts_index}/_doc/{alert_id}",
        )
        if resp.status_code == 404:
            return None
        resp.raise_for_status()
        doc = resp.json()
        return {"id": doc["_id"], **doc["_source"]}
