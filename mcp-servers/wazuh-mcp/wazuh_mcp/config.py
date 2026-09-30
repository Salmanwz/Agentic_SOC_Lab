import os
from dataclasses import dataclass

from dotenv import load_dotenv

load_dotenv()


@dataclass(frozen=True)
class Settings:
    indexer_url: str
    indexer_user: str
    indexer_password: str
    verify_ssl: bool
    alerts_index: str
    mcp_host: str
    mcp_port: int


def load_settings() -> Settings:
    return Settings(
        indexer_url=os.environ["WAZUH_INDEXER_URL"].rstrip("/"),
        indexer_user=os.environ["WAZUH_INDEXER_USER"],
        indexer_password=os.environ["WAZUH_INDEXER_PASSWORD"],
        verify_ssl=os.environ.get("WAZUH_INDEXER_VERIFY_SSL", "true").lower() == "true",
        alerts_index=os.environ.get("WAZUH_ALERTS_INDEX", "wazuh-alerts-*"),
        mcp_host=os.environ.get("MCP_HOST", "0.0.0.0"),
        mcp_port=int(os.environ.get("MCP_PORT", "8000")),
    )
