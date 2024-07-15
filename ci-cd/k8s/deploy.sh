#!/usr/bin/env bash

# the command below is out of date?
#./deploy.sh -r ng -e qa"
usage() { echo "Usage: $0  -i <infrastructure>" 1>&2; exit 1; }

set -e

declare inf=""
declare helmOptions=""


# Initialize parameters specified from command line
while getopts ":i:" arg; do
	case "${arg}" in
		i)
			inf=${OPTARG}
			;;

		esac
done
shift $((OPTIND-1))


if [[ -z "$inf" ]]; then

    echo "infrastructure is required"
    usage
    exit 1
fi

ENV_CONFIG="helm/env/${inf}/values.yaml"

if [ ! -f "${ENV_CONFIG}" ] ; then

    echo "Environment config file ${ENV_CONFIG} not found"
    exit 1

fi

NAMESPACE=${inf}-tomcat

set -e
set +x

kubectl get ns ${NAMESPACE}


helm template ./helm \
    -f ${ENV_CONFIG} \
    --set inf=${inf}\
    --namespace ${NAMESPACE} \
    | kubectl apply --namespace ${NAMESPACE} -f -

set +x
set +e
