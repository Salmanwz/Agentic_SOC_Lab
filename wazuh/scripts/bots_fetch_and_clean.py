"""
Download a BOTS json-by-sourcetype export, decompress it, and flatten
each Splunk search-result envelope down to its 'result' object —
one clean JSON object per line, ready for Wazuh's log_format json.
"""

import gzip
import json
import sys
import urllib.request

DEFAULT_URL = "https://s3.amazonaws.com/botsdataset/botsv1/json-by-sourcetype/botsv1.WinEventLog-Application.json.gz"


def download(url, path):
    print(f"Downloading {url} ...")
    urllib.request.urlretrieve(url, path)
    print(f"Saved to {path}")


def flatten(gz_path, out_path):
    count = 0
    with gzip.open(gz_path, "rt", encoding="utf-8") as infile, \
         open(out_path, "w", encoding="utf-8") as outfile:
        for line in infile:
            line = line.strip()
            if not line:
                continue
            record = json.loads(line)
            result = record.get("result")
            if result is None:
                continue
            outfile.write(json.dumps(result) + "\n")
            count += 1
    print(f"Wrote {count} events to {out_path}")


if __name__ == "__main__":
    url = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_URL
    gz_path = url.split("/")[-1]
    out_path = gz_path.replace(".json.gz", "-clean.json")

    download(url, gz_path)
    flatten(gz_path, out_path)