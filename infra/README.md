# infra

OpenTofu config that provisions the Wazuh VM on Proxmox (see
[../docs/architecture.md](../docs/architecture.md)):

- `wazuh` — Wazuh manager + indexer + dashboard

The `dockerhome` VM (MCP servers, agents, n8n) already exists and is not managed by this config.
The Wazuh VM is cloned from an existing cloud-init-enabled VM template on your Proxmox node (this
repo does not build the template — see prerequisites below).

## Layout

```
versions.tf              required providers (bpg/proxmox) + OpenTofu version constraint
providers.tf              Proxmox provider config (reads connection details from variables/env)
variables.tf              root-level inputs (Proxmox endpoint, node, template id, SSH key, ...)
vms.tf                    the Wazuh VM instance, built from modules/proxmox-vm
outputs.tf                IP address of the created VM
terraform.tfvars.example  copy to terraform.tfvars and fill in for your homelab
modules/proxmox-vm/       reusable module: clone a template into a sized VM with cloud-init
```

## Prerequisites

1. A cloud-init-enabled VM template already exists on your Proxmox node. If you don't have one,
   copy `scripts/create-template.sh` to the Proxmox host and run it as root (builds an Ubuntu
   24.04 template as VM 9000; override `VMID`, `STORAGE`, `BRIDGE` via env vars). Set the VM ID as
   `template_vm_id`.
2. A Proxmox API token with permissions to clone/create/delete VMs.
3. An SSH public key to inject via cloud-init for initial access.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars: proxmox endpoint, node name, template_vm_id, ssh_public_key, etc.

cp .env.example .env
# edit .env: set TF_VAR_proxmox_api_token

# tofu.sh loads .env, then runs tofu with your args
bash ./tofu.sh init
bash ./tofu.sh plan
bash ./tofu.sh apply
```

OpenTofu doesn't read `.env` files itself, so use `tofu.sh` instead of calling `tofu` directly
(or `set -a; source .env; set +a` first). `proxmox_api_token` flows into `providers.tf` via
`var.proxmox_api_token`.

## Notes

- VM sizing (CPU/RAM/disk) lives in `vms.tf` (Wazuh's indexer is memory-hungry).
- Nextcloud (cold storage) and the DockerHome VM already exist and are out of scope for this
  infra — only the Wazuh VM is provisioned here.
- State is local (`terraform.tfstate`) by default, matching a single-operator homelab. Not
  configured for remote state / locking.
