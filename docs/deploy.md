

## Deploying RocketChat

### Network Security Policy

Deploy the network security policy in advance to make sure the components in your deployments work as expected:

```console
oc process -f openshift/templates/nsp.yaml \
  -p NAMESPACE=$(oc project --short) | \
  oc apply -f -
```

### Database

Create the database credentials in advance of deploying the stateful set otherwise it will fail with various errors:

```console
oc process -f openshift/templates/mongodb-secrets.yaml| oc apply -f - 
```

Deploy the mongodb `statefullset`. The deployment parameters that vary across environments are stored in a properties file; pass this file to the command below varying the environment name as needed.

```console
oc process -f openshift/templates/mongodb-deploy.yaml \
  --param-file=openshift/mongodb-dev.properties | \
  oc create -f -
```
Watch that all tree pods in the `statefullset` start and verify in the Aporeto console that the cluster can communicate amongst itself.

![Mongo Communications](mongo-pod-comm.png "Mongo Comms")

### Database Backup

### Server

The deployment parameters that vary across environments are stored in a properties file; pass this file to the command below varying the environment name as needed.

```console
 oc process -f openshift/templates/rocketchat-deploy.yaml \
  --param-file=openshift/rocketchat-dev.properties \
  -p TLS_CERT_PEM="$(cat ./openshift/certificate.pem)" \
  -p TLS_KEY_PEM="$(cat ./openshift/key.pem)" \
  -p TLS_CACERT_PEM="$(cat ./openshift/ca.pem)" | \
  oc apply -f -
```

Note: The three TLS PEM files are not included in the repo; check with a Platform Services team member or Vault for these credentials.