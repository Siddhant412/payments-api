# payments-api

## Purpose

API for payment operations

## Ownership

- Owner: `group:default/payments-team`
- System: `system:default/gitops-developer-platform`

## Runtime

- Port: `7000`
- Liveness: `/health/live`
- Readiness: `/health/ready`

## Deployment Notes

Deployment manifests are under `kustomize/` with environment overlays for `dev` and `staging`.
