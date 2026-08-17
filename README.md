# helm-charts

[![Lint](https://img.shields.io/github/actions/workflow/status/futuro135/helm-charts/lint.yml?branch=master&label=lint)](https://github.com/futuro135/helm-charts/actions/workflows/lint.yml)
[![License: MIT](https://img.shields.io/github/license/futuro135/helm-charts)](./LICENSE)
[![Helm](https://img.shields.io/badge/Helm-3-0F1689?logo=helm&logoColor=white)](https://helm.sh)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io)
[![GHCR](https://img.shields.io/badge/GHCR-OCI-blue?logo=github)](https://github.com/futuro135?tab=packages)

Personal Helm chart repository for portfolio and learning.

Charts are production-shaped **examples** (clear values, probes, securityContext, persistence) —
not drop-in replacements for Bitnami / CloudNativePG / operators when you need HA.

## Charts

| Chart | Description | App version |
|-------|-------------|-------------|
| [postgres](./charts/postgres) | Single-primary PostgreSQL (StatefulSet + PVC) | 16.4 |
| [matrix](./charts/matrix) | Synapse homeserver + Element Web (Ingress, cert-manager) | 1.109.0 |

## Install from GHCR (OCI)

```bash
helm install demo oci://ghcr.io/futuro135/charts/postgres \
  --version 0.1.0 \
  -n databases --create-namespace

helm install matrix oci://ghcr.io/futuro135/charts/matrix \
  --version 0.1.0 \
  -n matrix --create-namespace \
  -f ./charts/matrix/examples/values-dev.yaml \
  --set server.name=matrix.example.com \
  --set database.password='secret'
```

Подробнее: [docs/GHCR.md](./docs/GHCR.md)

## Install from git clone

```bash
git clone https://github.com/futuro135/helm-charts.git
cd helm-charts

helm lint ./charts/postgres
helm install demo ./charts/postgres -n databases --create-namespace \
  -f ./charts/postgres/examples/values-dev.yaml

helm lint ./charts/matrix
helm install matrix ./charts/matrix -n matrix --create-namespace \
  -f ./charts/matrix/examples/values-dev.yaml \
  --set server.name=host135.online \
  --set database.host=my-postgres-postgresql.default.svc.cluster.local \
  --set database.password='YOUR_PASSWORD'
```

## Repository layout

```
helm-charts/
├── README.md
├── LICENSE
├── docs/GHCR.md
├── .github/workflows/
│   ├── lint.yml
│   └── publish-ghcr.yml
└── charts/
    ├── postgres/
    └── matrix/
```

## CI

| Workflow | Когда | Что делает |
|----------|--------|------------|
| **Lint Helm charts** | push / PR | `helm lint` + `helm template` |
| **Publish charts to GHCR** | вручную или GitHub Release | `helm package` + `helm push` в `ghcr.io` |

## License

[MIT](./LICENSE)
