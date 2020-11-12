#!/bin/bash

PROFILE="default"

set -euxo pipefail

# Set up crossplane in the cluster
kubectl create ns crossplane-system
helm repo add crossplane-alpha https://charts.crossplane.io/alpha
helm repo update
helm install crossplane \
	--namespace crossplane-system crossplane-alpha/crossplane \
	--set alpha.oam.enabled=true

# Congfigure kubectl for crossplane usage
curl -sL https://raw.githubusercontent.com/crossplane/crossplane/release-0.13/install.sh | sh
sudo mv kubectl-crossplane /usr/local/bin
sudo chmod +x /usr/local/bin/kubectl-crossplane
kubectl plugin list | grep crossplane
kubectl crossplane install provider crossplane/provider-aws:v0.12.0

# Set up AWS credentials
AWS_PROFILE=${PROFILE} && echo -e "[default]\naws_access_key_id = $(aws configure get aws_access_key_id --profile $AWS_PROFILE)\naws_secret_access_key = $(aws configure get aws_secret_access_key --profile $AWS_PROFILE)" > creds.conf
kubectl create secret generic aws-creds -n crossplane-system --from-file=key=./creds.conf
rm ./creds.conf
kubectl apply -f https://raw.githubusercontent.com/crossplane/crossplane/master/docs/snippets/configure/aws/providerconfig.yaml
