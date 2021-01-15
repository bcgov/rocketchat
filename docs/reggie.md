
➜  templates git:(master) ✗ oc process -f cicd.yaml -p NAMESPACE=$(oc project --short) | oc apply -f -
serviceaccount/github-cicd created
role.authorization.openshift.io/github-cicd created
rolebinding.authorization.openshift.io/github-cicd created

➜  templates git:(master) ✗ oc get secret/github-cicd-token-2dfjx -o json | jq '.data.token' |  tr -d "\"" | base64 -d | pbcopy 