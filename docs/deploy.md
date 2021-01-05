

## Deploying RocketChat

### Database

### Database Backup

### Server
```console
 oc process -f openshift/templates/rocketchat-deploy.yaml \
  --param-file=openshift/rocketchat-dev.properties \
  -p TLS_CERT_PEM="$(cat ./openshift/certificate.pem)" \
  -p TLS_KEY_PEM="$(cat ./openshift/key.pem)" \
  -p TLS_CACERT_PEM="$(cat ./openshift/ca.pem)" | \
  oc apply -f -
```

Note: The three TLS PEM files are not included in the repo; check with a Platform Services team member or Vault for these credentials.