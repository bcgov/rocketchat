# DevOps for RocketChat and Reggie

## Structure:
We are using kustomize to template and config RocketChat and Reggie deployments.
- the kustomization templates are in ./base folder, sorted by the micro-services components.
- also note that we have build templates in ./base/tekton folder. However, please notes that we are using GitHub workflows for CI at the moment, see ../.github/workflows for details.
- the environment configurations are in ./env folder. Please note that all secrets are using Vault services, the only thing that would need a local secret file is the route certificates. They should be placed in the ./env/<env_name>/routes, please refer to the specific kustomization.yaml for details.
- There is the plan to move RocketChat and all relevant components to Gold and GoldDR clusters, thus there is also a folder for transportServer. This is work in progress at the moment.

## Run:
To manually deploy the app, provide the needed configurations in the ./env folder, and use kustomize to generate oc configurations.

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
