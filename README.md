# helm-charts

Personal Helm chart repository for portfolio and learning.

Charts are production-shaped **examples** (clear values, probes, securityContext, persistence) —
not drop-in replacements for Bitnami / CloudNativePG / operators when you need HA.

## Charts

| Chart | Description | App version |
|-------|-------------|-------------|
| [postgres](./charts/postgres) | Single-primary PostgreSQL (StatefulSet + PVC) | 16.4 |

## Install from git clone

```bash
git clone https://github.com/<YOUR_GITHUB_USER>/helm-charts.git
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
├── .github/workflows/lint.yml
└── charts/
    └── postgres/
        ├── Chart.yaml
        ├── values.yaml
        ├── values.schema.json
        ├── README.md
        ├── examples/
        └── templates/
```

## CI

On every push/PR, GitHub Actions runs:

- `helm lint` for each chart under `charts/`
- `helm template` with the chart's example values (when present)

## License

[MIT](./LICENSE)
