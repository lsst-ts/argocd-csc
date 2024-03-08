#!/bin/bash -e
USAGE="Usage: ./install.sh ENVIRONMENT VAULT_TOKEN"
ENVIRONMENT=${1:?$USAGE}
export VAULT_TOKEN=${2:?$USAGE}
export VAULT_ADDR=https://vault.lsst.cloud
VAULT_PATH_PREFIX=$(yq -r .vaultPathPrefix ../apps/cluster-config/values-$ENVIRONMENT.yaml)
ARGOCD_PASSWORD=$(vault kv get --field=argocd.admin.plaintext_password $VAULT_PATH_PREFIX/installer)

echo "Login to argocd..."
argocd login \
  --plaintext \
  --port-forward \
  --port-forward-namespace argocd \
  --username admin \
  --password $ARGOCD_PASSWORD

echo "Create control system applications..."
./create_apps.py $ENVIRONMENT
