# helm-charts

Personal Helm chart repository for portfolio and learning.

Charts are production-shaped **examples** (clear values, probes, securityContext, persistence) —
not drop-in replacements for Bitnami / CloudNativePG / operators when you need HA.

## Charts

| Chart | Description | App version |
|-------|-------------|-------------|
| [postgres](./charts/postgres) | Single-primary PostgreSQL (StatefulSet + PVC) | 16.4 |

## Install from GHCR (OCI)

```bash
helm install demo oci://ghcr.io/futuro135/charts/postgres \
  --version 0.1.0 \
  -n databases --create-namespace
```

## Install from git clone

```bash
git clone https://github.com/futuro135/helm-charts.git
cd helm-charts

helm lint ./charts/postgres
helm install demo ./charts/postgres -n databases --create-namespace \
  -f ./charts/postgres/examples/values-dev.yaml
```

## Repository layout

```
helm-charts/
├── README.md
├── LICENSE
├── .gitignore
├── .github/workflows/
│   ├── lint.yml
│   └── publish-ghcr.yml
└── charts/
    └── postgres/
```

## CI

| Workflow | Когда | Что делает |
|----------|--------|------------|
| **Lint Helm charts** | push / PR | `helm lint` + `helm template` |
| **Publish charts to GHCR** | вручную или GitHub Release | `helm package` + `helm push` в `ghcr.io` |

## License

[MIT](./LICENSE)
