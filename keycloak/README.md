# Installation

Currently installed with:

```
helm -n keycloak install --create-namespace keycloak .
```

Will change once I add applicationset in /config.

# Access

Get the keycloak admin password and console info:

```
DNS_NAME=$(kubectl get cm dns-name -n default -o jsonpath={.data.dns-name})
PASSWORD=$(kubectl -n keycloak get secret keycloak -o jsonpath="{.data.admin-password}" | base64 -d)
echo "Keycloak console at https://keycloak.$DNS_NAME"
echo "username: user"
echo "password: $PASSWORD"
```
