# Detection rules plan

Status: **not started** — blocked on seeing sample events from the Splunk JSON dataset.

The pipeline needs Wazuh alerts to triage. The dataset is raw logs, not alerts, so we must write
(1) a decoder for the Splunk JSON schema and (2) detection rules on top of it.

## Approach

- Custom decoder (`decoders/`): parse each JSON line with Wazuh's `JSON_Decoder` plugin. Exact
  prematch depends on the export shape (flat vs. nested under `result` / `_raw`).
- Custom rules (`rules/`): IDs 100100–100199 reserved for this lab (Wazuh custom range is
  100000–120000). One base rule for "decoded Splunk event", child rules per detection, and
  frequency rules for correlation (e.g. brute force).
- Tag every rule with MITRE ATT&CK IDs so the Enrichment/Correlation agents can cite technique
  context.
- Test with `wazuh-logtest` on the Wazuh VM before enabling on the full 120GB replay.

## Candidate detections (assumes Windows/Sysmon-style events; verify against real data)

| Detection | ATT&CK | Key fields |
|-----------|--------|-----------|
| Encoded PowerShell | T1059.001 | EventCode 1, CommandLine |
| Office app spawns shell/script | T1204.002 | ParentImage, Image |
| certutil download | T1105 | CommandLine |
| Scheduled task creation | T1053.005 | CommandLine (`schtasks /create`) |
| LSASS memory access | T1003.001 | EventCode 10, TargetImage, GrantedAccess |
| Event log cleared | T1070.001 | EventCode 1102 / 104 |
| Added to local Administrators | T1098 | EventCode 4732 |
| Brute force (8 failed logons / 2 min per IP) | T1110 | EventCode 4625, IpAddress |
| Successful logon after brute force | T1110 | EventCode 4624 + correlation |

Field names above are assumptions and may differ in the dataset.

## Open questions

- What does one line of the dataset look like (flat vs. nested; which sourcetypes)?
- Which sourcetypes are present (Sysmon, Windows Security, network, other)? Detections follow the data.
- Alert volume target: the pipeline wants a manageable, mixed TP/FP set, so tune levels and
  thresholds after the first replay.

## Next step

Get 5–10 representative sample lines, then write `decoders/` and `rules/` and a `wazuh-logtest`
checklist. Files live under `wazuh/` (directories exist, currently empty).
