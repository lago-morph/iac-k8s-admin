# Installation

Currently installed with:

```
helm -n keycloak install --create-namespace keycloak .
```

Will change once I add applicationset in /config.

# Access

Get the keycloak admin password and console info:

```
PASSWORD=$(kubectl -n keycloak get secret keycloak -o jsonpath="{.data.admin-password}" | base64 -d)
echo "Keycloak console at https://keycloak.$(cat ~/DNS_NAME)"
echo "username: user"
echo "password: $PASSWORD"
```
