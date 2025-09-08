#!/bin/bash
#

set -e 

DNS_NAME=$(kubectl get cm dns-name -n default -o jsonpath={.data.dns-name})

eksctl associate identityprovider \
  --wait \
  --config-file - << EOF
---
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: cluster
  region: $AWS_DEFAULT_REGION
identityProviders:
  - name: keycloak-oidc
    type: oidc
    issuerUrl: https://keycloak.${DNS_NAME}/realms/che
    clientId: k8s-client
    usernameClaim: email
EOF
