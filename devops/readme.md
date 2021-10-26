# DevOps for RocketChat and Reggie

## Structure:
We are using Kustomize to template and config RocketChat and Reggie deployments.
- the Kustomization templates are in ./base folder, sorted by the micro-services components.
- also note that we have build templates in ./base/tekton folder. However, please notes that we are using GitHub workflows for CI at the moment, see ../.github/workflows for details.
- the environment configurations are in ./env folder. Please note that all secrets are using Vault services, the only thing that would need a local secret file is the route certificates. They should be placed in the ./env/<env_name>/routes, please refer to the specific kustomization.yaml for details.
- There is the plan to move RocketChat and all relevant components to Gold and GoldDR clusters, thus there is also a folder for transportServer. This is work in progress at the moment.

## Run:

1. Preparation:

First of all, we need to setup artifactory image pull credential. Also refer to Artifactory docs described here: https://developer.gov.bc.ca/Artifact-Repositories-(Artifactory).

```shell
# get the artifactory secret from tools namespace:
oc -n 6e2f55-tools get secret/artifacts-default-<suffix> -o json | jq '.data.username' | tr -d "\"" | base64 -d
oc -n 6e2f55-tools get secret/artifacts-default-<suffix> -o json | jq '.data.password' | tr -d "\"" | base64 -d

# Create the secret.
# 1. Note that the secret name should match the one Rocketchat deployment is using in the imagePullSecrets
# 2. Note that the docker server will need to match the one we are using!

oc -n 6e2f55-<env_name> create secret docker-registry artifactory-creds \
    --docker-server="docker-remote.artifacts.developer.gov.bc.ca" \
    --docker-username=<username> \
    --docker-password=<password> \
    --docker-email=<username>@<namespace>.local
```

1. Vault setup:
We are using Vault to manage application secrets. First of all we need to make sure the secrets are existing in the corresponding Vault project. Following are some basic steps to create and check the secret key-value pairs.

**Note** that following are just samples, refer to Vault documentation or do `vault -h`. It's recommeded to use Vault cli instead of the GUI as it offers way more options and documentation!

```shell
# Login to Vault
export VAULT_ADDR=https://vault.developer.gov.bc.ca/
export VAULT_NAMESPACE=platform-services
vault login -method=oidc -namespace=platform-services role=6e2f55

# Create secrets
vault kv put 6e2f55-nonprod/mongo-db-credential MONGODB_ADMIN_PASSWORD=123 MONGODB_ADMIN_USERNAME=admin-user

# Check secrets
vault kv get 6e2f55-nonprod/mongo-db-credential
vault kv get -format=json 6e2f55-nonprod/mongo-db-credential
# (make sure Options are put before the secret name)

# Delete secrets
vault kv delete 6e2f55-nonprod/mongo-db-credential
```

To configure Vault integration into application, we use annotations. Here's a sample of Vault patch to Kustomize templates for mongoDB. Refer to [Vault injector sidecar doc](https://www.vaultproject.io/docs/platform/k8s/injector/annotations) for more details!
```yaml
---
kind: StatefulSet
apiVersion: apps/v1
metadata:
  name: mongodb
spec:
  template:
    metadata:
      annotations:
        # specify the vault service in use:
        vault.hashicorp.com/agent-inject: 'true'
        vault.hashicorp.com/auth-path: auth/k8s-silver
        vault.hashicorp.com/namespace: platform-services
        # specify which project in vault, prod or nonprod:
        vault.hashicorp.com/role: 6e2f55-nonprod
        # specify which secret to use:
        vault.hashicorp.com/agent-inject-secret-creds: 6e2f55-nonprod/mongodb-creds-dev
        # this writes a file in the path /vault/secrets/creds with the following content
        # {{ .Data.data.xxx }} takes the corresponding value from secret key
        vault.hashicorp.com/agent-inject-template-creds: |
          {{- with secret "6e2f55-nonprod/mongodb-creds-dev" }}
          export MONGODB_ADMIN_PASSWORD="{{ .Data.data.MONGODB_ADMIN_PASSWORD }}"
          export MONGODB_ADMIN_USERNAME="{{ .Data.data.MONGODB_ADMIN_USERNAME }}"
          export MONGODB_PASSWORD="{{ .Data.data.MONGODB_PASSWORD }}"
          export MONGODB_USER="{{ .Data.data.MONGODB_USER }}"
          export MONGODB_KEYFILE_VALUE="{{ .Data.data.MONGODB_KEYFILE_VALUE }}"
          {{ end }}
        # optional, this will pull in the access token for debugging in pod
        vault.hashicorp.com/agent-inject-token: 'true'
    spec:
      # make sure to use the Vault service account for proper access:
      serviceAccountName: 6e2f55-vault
      containers:
        - name: mongo-container
          args:
            - sh
            - '-c'
            - '. /vault/secrets/creds && run-mongod'
            # this is to source the file written by Vault into env vars for app to use
```

**Note** that the secret env var are only sourced during the container start command, which means it's not going to be an env var in the pod that can be used directly. As a result of this, for example, we will not be able to run `./backup.sh -1` to manually trigger a DB backup from pod. To use the secrets for manual actions, make sure to source them first like `. /vault/secrets/creds && ./backup.sh -1`!


1. Create App Components:

To manually deploy the app, provide the needed configurations in the ./env folder, and use Kustomize to generate oc configurations.

```shell
# generate configs:
kustomize build devops/env/<env_name> > deployment.yaml

# dry run to test:
oc apply -f deployment.yaml --dru-run

# when all good, apply the configuration:
oc apply -f deployment.yaml

# To delete objects, first check on what are there:
oc get all -l "app=rocketchat"
oc get all -l "app=reggie"

# then delete:
oc delete all -l "app=rocketchat"
oc delete all -l "app=reggie"
```

