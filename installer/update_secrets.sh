#!/bin/bash -e
ENVIRONMENT=$1

export VAULT_DOC_UUID=$(yq -r .onepassword_uuid site-config.yaml)
export VAULT_ADDR=https://vault.lsst.cloud
# Look up vault path to get SQuaRE environment as our environment naming is
# slightly different from SQuaRE's
VAULT_PATH_PREFIX=$(yq -r .vaultPathPrefix ../apps/cluster-config/values-$ENVIRONMENT.yaml)
SQUARE_ENVIRONMENT=${VAULT_PATH_PREFIX##*/}

tmp_file=".token"
./vault_key.py $SQUARE_ENVIRONMENT write --use-file=${tmp_file}
export VAULT_TOKEN=$(cat ${tmp_file})
rm ${tmp_file}

echo "Clear out any existing secrets"
rm -rf secrets

echo "Reading current secrets from vault"
./read_secrets.sh $ENVIRONMENT

echo "Generating missing secrets with values from onepassword"
./generate_secrets.py $ENVIRONMENT --op

echo "Writing secrets to vault"
./write_secrets.sh $ENVIRONMENT
