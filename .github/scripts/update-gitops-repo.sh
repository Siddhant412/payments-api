#!/usr/bin/env bash

set -euo pipefail

: "${GITOPS_REPO:?GITOPS_REPO is required}"
: "${GITOPS_OVERLAY_PATH:?GITOPS_OVERLAY_PATH is required}"
: "${GITOPS_REPO_TOKEN:?GITOPS_REPO_TOKEN is required}"
: "${IMAGE_TAG:?IMAGE_TAG is required}"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

git clone "https://x-access-token:${GITOPS_REPO_TOKEN}@github.com/${GITOPS_REPO}.git" "${TMP_DIR}/gitops-repo"

cd "${TMP_DIR}/gitops-repo"

if [[ ! -f "${GITOPS_OVERLAY_PATH}" ]]; then
  echo "Overlay file '${GITOPS_OVERLAY_PATH}' does not exist in ${GITOPS_REPO}" >&2
  exit 1
fi

python3 - "${GITOPS_OVERLAY_PATH}" "${IMAGE_TAG}" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
tag = sys.argv[2]
lines = path.read_text().splitlines()

for index, line in enumerate(lines):
    stripped = line.lstrip()
    if stripped.startswith("newTag:"):
        indent = line[: len(line) - len(stripped)]
        lines[index] = f"{indent}newTag: {tag}"
        break
else:
    raise SystemExit(f"Could not find newTag in {path}")

path.write_text("\n".join(lines) + "\n")
PY

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

git add "${GITOPS_OVERLAY_PATH}"

if git diff --cached --quiet; then
  echo "GitOps overlay already points at ${IMAGE_TAG}"
  exit 0
fi

git commit -m "deploy(payments-api): update dev image to ${IMAGE_TAG}"
git push origin HEAD:main
