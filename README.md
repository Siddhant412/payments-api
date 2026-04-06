# payments-api

API for the payment operations

## Local Development

```bash
npm install
npm start
```

The service listens on port `7000` by default and exposes:

- `GET /`
- `GET /health/live`
- `GET /health/ready`

## Testing

```bash
npm test
```

## Repository Layout

- `src/` contains the application entrypoint and server setup
- `test/` contains smoke tests for the HTTP endpoints
- `docs/` contains TechDocs content
- `kustomize/` contains deploy manifests for `dev` and `staging`

## Deployment Flow

This repository owns application code and image builds. Deployment desired state lives in the separate `gitops-platform-environments` repository.

On pushes to `main`, CI:

- publishes a multi-arch image to GHCR
- updates `apps/payments-api/overlays/dev/kustomization.yaml` in the GitOps repo with the new image tag
