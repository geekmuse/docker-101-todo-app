#!/bin/bash

TOPIC=$(kubectl get snstopic 101-todo-app -o jsonpath="{.metadata.annotations.crossplane\.io/external-name}")

sed -e "s/__TOPIC__/${TOPIC}/g" 08_deployment.tpl.yml > 08_deployment.yml

kubectl apply -f ./08_deployment.yml
