#!/bin/bash
#

set -e

USERNAME=user
PASSWORD=$(kubectl -n keycloak get secret keycloak -o jsonpath="{.data.admin-password}" | base64 -d)
DNS_NAME=$(kubectl get cm dns-name -n default -o jsonpath={.data.dns-name})
KEYCLOAK_DOMAIN_NAME=keycloak.${DNS_NAME}

cat > che-cluster-patch.yaml << EOF
spec:
  networking:
    auth:
      oAuthClientName: k8s-client
      oAuthSecret: eclipse-che
      identityProviderURL: "https://$KEYCLOAK_DOMAIN_NAME/realms/che"
      gateway:
        oAuthProxy:
          cookieExpireSeconds: 300
        deployment:
          containers:
          - env:
             - name: OAUTH2_PROXY_BACKEND_LOGOUT_URL
               value: "http://$KEYCLOAK_DOMAIN_NAME/realms/che/protocol/openid-connect/logout?id_token_hint={id_token}"
            name: oauth-proxy
  components:
    cheServer:
      extraProperties:
        CHE_OIDC_USERNAME__CLAIM: email
EOF

chectl server:deploy \
    --platform k8s \
    --domain $DNS_NAME \
    --che-operator-cr-patch-yaml che-cluster-patch.yaml \
    --k8spodreadytimeout 240000 \
    --k8spoddownloadimagetimeout 240000


