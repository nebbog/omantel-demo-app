#!/usr/bin/env bash

if [[ -z "$KANNEL_VENSO_SMSC_PASSWORD" ]]; then

    set -e

    source ../../paga-infrastructure-azure/${country}/${inf}/.env

    SECRET_NAME=kannel-venso-smsc-password

    echo "Loading ${SECRET_NAME}"

    KANNEL_VENSO_SMSC_PASSWORD=$(az keyvault secret show --subscription ${SUBSCRIPTION_ID} --vault-name ${PLATFORM_BUILDER_VAULT_NAME} --name ${SECRET_NAME} --query value -o tsv)
    if [[ -z "${KANNEL_VENSO_SMSC_PASSWORD}" ]]; then
        echo "ERROR - ${SECRET_NAME} not configured in ${PLATFORM_BUILDER_VAULT_NAME} vault OR you don't have access to it"
        exit 1
    fi

fi


export ENV_CREDENTIALS_PARAM="--set kannelCredentials.vensoSmscPassword=${KANNEL_VENSO_SMSC_PASSWORD}"
