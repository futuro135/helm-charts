# Matrix Helm Chart

Helm chart for a self-hosted Matrix stack:

- **Synapse** — Matrix homeserver (Deployment + PVC + init containers)
- **Element Web** — optional browser client (Deployment + ConfigMap)
- **Ingress** — Traefik / cert-manager friendly routing

PostgreSQL is **external** (use the [postgres](../postgres) chart or any managed DB).

> Single Synapse instance — no workers, no streaming replication, no automatic failover.

## Features

- Init container renders `homeserver.yaml` from ConfigMap + Secrets
- Signing key generated once and kept on PVC
- Auto-generated secrets with stable `lookup` on upgrade
- Ingress: `/_matrix`, `/_synapse` → Synapse; `/` → Element
- TLS via cert-manager annotations (optional)

## Prerequisites

1. Kubernetes cluster with StorageClass (for Synapse PVC)
2. PostgreSQL database and user:

```sql
CREATE USER synapse WITH PASSWORD 'your-password';
CREATE DATABASE synapse OWNER synapse ENCODING 'UTF8' LC_COLLATE='C' LC_CTYPE='C' TEMPLATE template0;
```

3. (Optional) cert-manager + ClusterIssuer for TLS

## Quick start

From the **helm-charts** repo root:

```bash
helm lint ./charts/matrix
helm template matrix ./charts/matrix -f ./charts/matrix/examples/values-dev.yaml

helm install matrix ./charts/matrix -n matrix --create-namespace \
  -f ./charts/matrix/examples/values-dev.yaml \
  --set server.name=host135.online \
  --set database.host=my-postgres-postgresql.default.svc.cluster.local \
  --set database.password='YOUR_DB_PASSWORD'
```

## Install from GHCR

```bash
helm install matrix oci://ghcr.io/futuro135/charts/matrix \
  --version 0.1.0 \
  -n matrix --create-namespace \
  -f values.yaml
```

## Useful values

| Key | Default | Description |
|-----|---------|-------------|
| `server.name` | — | Matrix `server_name` (required) |
| `database.host` | — | PostgreSQL hostname (required) |
| `database.password` | `""` | DB password (auto-generated if empty) |
| `database.existingSecret` | `""` | External Secret with DB password |
| `persistence.size` | `2Gi` | Synapse data PVC |
| `synapse.enableRegistration` | `false` | Allow new user registration |
| `element.enabled` | `true` | Deploy Element Web |
| `ingress.enabled` | `true` | Create Ingress |
| `ingress.tls.enabled` | `true` | TLS block for cert-manager |

## Existing secrets

Secret keys (when not using `synapse.existingSecret`):

- `POSTGRES_PASSWORD` — unless `database.existingSecret` is set
- `REGISTRATION_SHARED_SECRET`
- `MACAROON_SECRET_KEY`
- `FORM_SECRET`

## Connect

```bash
kubectl -n matrix port-forward svc/matrix-synapse 8008:8008
curl http://127.0.0.1:8008/_matrix/client/versions
```

With Ingress: open `https://<server.name>/` in browser (Element) or use the Matrix API at `/_matrix`.

## Chart layout

```
charts/matrix/
├── Chart.yaml
├── values.yaml
├── values.schema.json
├── README.md
├── examples/
│   └── values-dev.yaml
└── templates/
    ├── synapse-*.yaml
    ├── element-*.yaml
    ├── ingress.yaml
    ├── secret.yaml
    └── NOTES.txt
```

## Portfolio talking points

1. Why Synapse uses init containers (template secrets into config)
2. Why signing key lives on PVC, not in Secret
3. Ingress path routing for Matrix federation vs Element UI
4. Trade-offs vs Element Matrix stack / operators
