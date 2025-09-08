Scripts are all in the `scripts` directory.

Order of scripts:

- `init_keycloak_realm.sh`
- `install_chectl.sh`
- `associate-oidc.sh`
- `install_ingress_nginx.sh`
- `deploy_che.sh`

Current status:

- `install_ingress_nginx.sh` ingress installs an internal-facing one, which is not what we want.  It is likely `external-dns` is also not configured to register names using those annotations, but not sure yet.
- `deploy_che.sh` errors out because it is looking for the nginx ingress controller.


