# PostgreSQL Helm Chart

Standalone PostgreSQL chart for Kubernetes. Built as a portfolio project to demonstrate
Helm templating, StatefulSets, Secrets, persistence, probes, NetworkPolicy and optional metrics.

> Not a replacement for Bitnami / CloudNativePG / operators in production HA setups.
> This chart runs a **single primary** with durable PVC storage.

## Features

- StatefulSet + PVC (`volumeClaimTemplates`)
- Auto-generated passwords (stable across upgrades via `lookup`)
- Optional `existingSecret`
- Liveness / readiness probes (`pg_isready`)
- Resource requests/limits and securityContext
- Optional custom `postgresql.conf` parameters via `args`
- Optional NetworkPolicy
- Optional Prometheus postgres-exporter sidecar

## Quick start

From the **helm-charts** repository root:

```bash
helm lint ./charts/postgres
helm template demo ./charts/postgres | less

helm install demo ./charts/postgres -n databases --create-namespace

# Or with explicit credentials
helm install demo ./charts/postgres -n databases --create-namespace \
  --set auth.username=app \
  --set auth.password='ChangeMe!' \
  --set auth.database=appdb \
  --set auth.postgresPassword='SuperSecret!'

# Dev / demo overrides
helm install demo ./charts/postgres -n databases --create-namespace \
  -f ./charts/postgres/examples/values-dev.yaml
```

## Connect

```bash
kubectl -n databases get secret demo-postgres -o jsonpath='{.data.password}' | base64 -d; echo
kubectl -n databases port-forward svc/demo-postgres 5432:5432
```

## Useful values

| Key | Default | Description |
|-----|---------|-------------|
| `image.tag` | `16.4` | PostgreSQL image tag |
| `auth.username` | `app` | Application user |
| `auth.database` | `app` | Database name |
| `auth.existingSecret` | `""` | Use an external Secret |
| `persistence.size` | `8Gi` | PVC size |
| `persistence.enabled` | `true` | Disable for emptyDir (ephemeral) |
| `postgresql.config` | `{}` | Extra `-c key=value` flags |
| `metrics.enabled` | `false` | Enable postgres-exporter |
| `networkPolicy.enabled` | `false` | Restrict ingress |

### Custom PostgreSQL settings

```yaml
postgresql:
  config:
    max_connections: "200"
    shared_buffers: "256MB"
```

### Existing Secret

Create a Secret with keys `postgres-password`, `password`, `username`, `database` (override names via `auth.secretKeys`), then:

```yaml
auth:
  existingSecret: my-pg-secret
```

## Chart layout

```
charts/postgres/
├── Chart.yaml
├── values.yaml
├── values.schema.json
├── .helmignore
├── README.md
├── examples/
│   └── values-dev.yaml
└── templates/
    ├── _helpers.tpl
    ├── _validate.tpl
    ├── statefulset.yaml
    ├── service.yaml
    ├── secret.yaml
    ├── configmap.yaml
    ├── serviceaccount.yaml
    ├── networkpolicy.yaml
    └── NOTES.txt
```

## Verify

```bash
helm lint ./charts/postgres
helm template demo ./charts/postgres --debug >/dev/null
helm package ./charts/postgres
```

## Portfolio talking points

1. Why StatefulSet instead of Deployment for databases
2. Password generation + `lookup` so upgrades do not rotate secrets unexpectedly
3. SecurityContext / non-root / dropped capabilities
4. Probes that actually check Postgres readiness
5. Trade-offs vs operators (no streaming replication, no automatic failover)
