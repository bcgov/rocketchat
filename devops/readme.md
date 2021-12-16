# DevOps for RocketChat and Reggie

This RocketChat suite uses Argo CD and Kustomize to manage deployments.  Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.  Kustomize is a tool for efficiently managing Kubernetes resource manifests for multiple environments.  GitHub Actions constitute the CI portion of the pipeline.

The purpose of this document is to describe:
* the 'devops' directory structure
* the CI/CD pipelines
* how to work with Argo CD for management of deployments

## Table of Contents
1. [Prerequisites](#prerequisites)
    1. [CLIs](#clis)
    2. [Access](#access)
2. [Kustomize](#kustomize)
3. [Argo CD](#argocd)
4. [Vault](#vault)
5. [GitHub Actions](#github-actions)


## Prerequisites <a name="prerequisites">
If you intend to manage or extend the DevOps infrastructure described here, you will need some tools, as well as access to the systems in question.  If not, continue with the next section.
* CLIs
  * [kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)
  * [oc](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.7/html-single/cli_tools/index#cli-getting-started)
  * [vault](https://www.vaultproject.io/downloads)
* Access
  * OCP project - Access to the OpenShift console for the given namespace
  * Argo CD UI - Access to the Argo CD Project containing the RocketChat Applications
  * This repo

## Kustomize
All Kubernetes resources are represented by a YAML manifest, which can be stored as files in a Git repository and applied directly to the OpenShift cluster.  Kustomize is a system that provides an efficient way of managing a single set of manifests for your application for all of your non-prod and prod environments.  It does this by establishing a base set of manifests, as well as a set of "overlay" files that define any non-default settings or resources for each environment.

[https://kustomize.io/](https://kustomize.io/)
[https://argo-cd.readthedocs.io/en/release-2.0/user-guide/kustomize/](https://argo-cd.readthedocs.io/en/release-2.0/user-guide/kustomize/)

The base files are all managed in the `base` directory and are complete resource manifest files.  There is a `kustomization.yaml` file in the base directory, which lists the manifests that are to be included.  **Note:** Each manifest must be listed in the kustomization.yaml file or it will be ignored.

Each environment's overlays are in the respective `env/*` directories.  Like the 'base' directory, each 'env/ENV' directory contains a 'kustomization.yaml' file.  This file contains multiple sections:
* `bases` - a list of directories containing 'base' files
* `resources` - a list of local (environment-specific) resource files that are not part of the base
* `patches` - a list of patch files that modify a resource or resources defined in a base manifest
* `configMapGenerator` - a list of files defining config maps
* `images` - a list of images used by the application, which allows for simple setting of the image IDs for each environment
* and there are more options - see [Kustomization](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/)

You can verify that your manifests will build, and review the result offline, by creating a manifest file using the CLI.
```
# Generate an all-inclusive manifest for review
# ---------------------------------------------
kustomize build devops/env/<env_name> > deployment.yaml
```

## Argo CD
An application in Argo CD is configured to monitor the overlays path within this repository, such as `devops/env/prod`.  It compares the manifest files with the actual resources in the cluster and makes any changes necessary in order to make them the same.  If automatic synchronization is enabled, updates will be initiated within three minutes.  When automatic synchronization is not enabled, an update to the manifests will result in Argo CD showing the application as being "out of sync" and the app can be manually synchronized by clicking the Sync button in the Argo CD UI.  Note that Argo CD allows you to specify both a branch and a path for an application, so you may use an alternate branch to test changes to the Kustomize files.

For more infomation on Argo CD, see [the docs](https://argo-cd.readthedocs.io/en/release-2.0/).
 
## Vault
It is important to never include passwords, certificates, or other secret information in your manifests, for security reasons.  Therefor, we use Vault for management of secrets and can safely incorporate them into the app.

[Vault Documentation](https://www.vaultproject.io/docs)

1. Vault setup:
First of all, we need to make sure the secrets are exist in the corresponding Vault project. The following are some basic steps to create and check the secret key-value pairs.

**Note** that the following are just samples; refer to Vault documentation or run `vault -h` for more information. It's recommeded to use the Vault CLI instead of the GUI, as it offers more options and documentation.

```shell
# Log in to Vault
export VAULT_ADDR=https://vault.developer.gov.bc.ca/
export VAULT_NAMESPACE=platform-services
vault login -method=oidc -namespace=platform-services role=87d478

# Create secrets
vault kv put 87d478-nonprod/mongo-db-credential MONGODB_ADMIN_PASSWORD=123 MONGODB_ADMIN_USERNAME=admin-user

# Check secrets
vault kv get 87d478-nonprod/mongo-db-credential
vault kv get -format=json 87d478-nonprod/mongo-db-credential
# (make sure Options are put before the secret name)

# Delete secrets
vault kv delete 87d478-nonprod/mongo-db-credential
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
        vault.hashicorp.com/auth-path: auth/k8s-gold
        vault.hashicorp.com/namespace: platform-services
        # specify which project in vault, prod or nonprod:
        vault.hashicorp.com/role: 87d478-nonprod
        # specify which secret to use:
        vault.hashicorp.com/agent-inject-secret-creds: 87d478-nonprod/mongodb-creds-dev
        # this writes a file in the path /vault/secrets/creds with the following content
        # {{ .Data.data.xxx }} takes the corresponding value from secret key
        vault.hashicorp.com/agent-inject-template-creds: |
          {{- with secret "87d478-nonprod/mongodb-creds-dev" }}
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
      serviceAccountName: 87d478-vault
      containers:
        - name: mongo-container
          args:
            - sh
            - '-c'
            - '. /vault/secrets/creds && run-mongod'
            # this is to source the file written by Vault into env vars for app to use
```

**Note** that the secret env var are only sourced during the container start command, which means it's not going to be an env var in the pod that can be used directly. As a result of this, for example, we will not be able to run `./backup.sh -1` to manually trigger a DB backup from pod. To use the secrets for manual actions, make sure to source them first like `. /vault/secrets/creds && ./backup.sh -1`!

## GitHub Actions <a name="github-actions">
The `.github/workflows/` directory contains GitHub Action workflows.  These are used to build and test the images, and if the build and test are successful, to update the image ID for the target environment(s).  For the migration to Argo CD, these were updated so that upon a successful build, the kustomization.yaml file for the target environment is updated with the new image ID, as described above in the Kustomize section.  This is achieved by getting the unique SHA256 ID of the new image and applying that with the 'kustomize' CLI.
```
kustomize edit set image "reggie-api=<image_registry>/<image_path>@<image_ID>"
```
See the files in `.github/workflows/` for complete details.

The workflows are started by either a push or merge (`on.push`) or manually (`on.workflow_dispatch`).




