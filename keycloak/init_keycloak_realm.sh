#!/bin/bash
#

set -e

USERNAME=user
PASSWORD=$(kubectl -n keycloak get secret keycloak -o jsonpath="{.data.admin-password}" | base64 -d)
DNS_NAME=$(kubectl get cm dns-name -n default -o jsonpath={.data.dns-name})

kubectl run kcadm --image quay.io/keycloak/keycloak:18.0.2 --command -- sleep infinity
kubectl wait --for=condition=Ready pod/kcadm --timeout=60s

kubectl exec pod/kcadm -- bash -c \
    "/opt/keycloak/bin/kcadm.sh config credentials \
        --server https://keycloak.$DNS_NAME \
        --realm master \
        --user $USERNAME  \
        --password $PASSWORD && \
    /opt/keycloak/bin/kcadm.sh create realms \
        -s realm='che' \
        -s displayName='che' \
        -s enabled=true \
        -s registrationAllowed=false \
        -s resetPasswordAllowed=true && \
    /opt/keycloak/bin/kcadm.sh create clients \
        -r 'che' \
        -s clientId=k8s-client \
        -s id=k8s-client \
        -s redirectUris='[\"*\"]' \
        -s directAccessGrantsEnabled=true \
        -s secret=eclipse-che && \
    /opt/keycloak/bin/kcadm.sh create users \
        -r 'che' \
        -s username=test \
        -s email=\"test@test.com\" \
        -s enabled=true \
        -s emailVerified=true &&  \
    /opt/keycloak/bin/kcadm.sh set-password \
        -r 'che' \
        --username test \
        --new-password test"

kubectl delete pod kcadm

