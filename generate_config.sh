#!/bin/bash -e

CLUSTER=$1
CONTEXT="gke_cyberagent-239_asia-northeast1-a_${CLUSTER}"
KUBECTL="kubectl --context ${CONTEXT}"
KUBECONFIG="config/${CLUSTER}.config"
MASTER_CERT="${CLUSTER}.crt"

if [ "${CLUSTER}" = "" ]; then
    echo "$(basename $0) <cluster_name>"
    exit 1
fi

# clean
rm -rf ./${KUBECONFIG} ./${MASTER_CERT}

# get cluster credentials
gcloud container clusters get-credentials ${CLUSTER}

# create sa and clusterrolebinding
${KUBECTL} apply -f sa.yaml

# get secret for intern
SECRET=$(${KUBECTL} get sa -n kube-system intern -o jsonpath='{ .secrets[0].name }')

# get token
TOKEN=$(${KUBECTL} get secret ${SECRET} -n kube-system -o jsonpath='{.data.token}' | base64 -D)

# get server endpoint
ENDPOINT=$(kubectl config view -o jsonpath="{.clusters[?(@.name == \"${CONTEXT}\")].cluster.server}")

# get server cert
${KUBECTL} get secret ${SECRET} -n kube-system -o json | jq -r '.data["ca.crt"]' | base64 -D > ${MASTER_CERT}

# create config
kubectl config --kubeconfig=${KUBECONFIG} set-cluster ${CLUSTER} --server=${ENDPOINT} --certificate-authority=${MASTER_CERT} --embed-certs=true
kubectl config --kubeconfig=${KUBECONFIG} set-credentials intern --token=${TOKEN}
kubectl config --kubeconfig=${KUBECONFIG} set-context "intern_${CLUSTER}" --cluster=${CLUSTER} --user=intern --namespace=default
kubectl config --kubeconfig=${KUBECONFIG} use-context "intern_${CLUSTER}"

