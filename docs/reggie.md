## Deploying Reggie

oc process -f openshift/templates/nsp.yaml -p NAMESPACE=$(oc project --short)| oc apply -f -

➜  templates git:(master) ✗ oc process -f openshift/templates/cicd.yaml -p NAMESPACE=$(oc project --short) | oc apply -f -
serviceaccount/github-cicd created
role.authorization.openshift.io/github-cicd created
rolebinding.authorization.openshift.io/github-cicd created


➜  templates git:(master) ✗ oc get secret/github-cicd-token-2dfjx -o json | jq '.data.token' |  tr -d "\"" | base64 -d | pbcopy 


### API

oc process -f openshift/templates/reggie-api-secrets.yaml --param-file=openshift/reggie-api-prod-secret.properties | oc apply -f -

oc process -f openshift/templates/reggie-api-deploy.yaml --param-file=openshift/reggie-api-prod.properties -p NAMESPACE=$(oc project --short) -p TLS_CERT_PEM="$(cat ./openshift/certificate.pem)" -p TLS_KEY_PEM="$(cat ./openshift/key.pem)" -p TLS_CACERT_PEM="$(cat ./openshift/ca.pem)"| oc apply -f -

### Web


