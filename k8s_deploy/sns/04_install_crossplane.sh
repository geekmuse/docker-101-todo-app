#!/bin/bash

PROFILE="${1:-default}"
VSN="0.14.0"
VSN_TRIM=${VSN%".0"}

set -euxo pipefail

# Set up crossplane in the cluster
kubectl create ns crossplane-system
helm repo add crossplane-alpha https://charts.crossplane.io/alpha
helm repo update
helm install crossplane \
	--namespace crossplane-system crossplane-alpha/crossplane \
	--set alpha.oam.enabled=true --version ${VSN}

# Congfigure kubectl for crossplane usage
VERSION=${VSN} CHANNEL="alpha" curl -sL  https://raw.githubusercontent.com/crossplane/crossplane/release-0.14/install.sh | sh
sudo mv kubectl-crossplane /usr/local/bin
sudo chmod +x /usr/local/bin/kubectl-crossplane
kubectl plugin list | grep crossplane
kubectl crossplane install provider crossplane/provider-aws:alpha

# Set up AWS credentials
echo -e "[default]\naws_access_key_id = $(aws configure get aws_access_key_id --profile $PROFILE)\naws_secret_access_key = $(aws configure get aws_secret_access_key --profile $PROFILE)" > creds.conf
kubectl create secret generic aws-creds -n crossplane-system --from-file=key=./creds.conf
rm ./creds.conf
# provider config doesn't seem to work without the sleep
sleep 30
kubectl apply -f https://raw.githubusercontent.com/crossplane/crossplane/release-${VSN_TRIM}/docs/snippets/configure/aws/providerconfig.yaml
