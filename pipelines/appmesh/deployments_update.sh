#!/bin/bash
for secret in $(kubectl get secret.cnp.comp.db.de -n $1 --context $2 -o jsonpath='{range .items[*]}{.status.resources.aws-secret.name},{.metadata.labels.cnp\.comp\.db\.de\/component},{.metadata.labels.cnp\.comp\.db\.de\/release}{"\n"}{end}' -l cnp.comp.db.de/component); do
    export claim=$(echo $secret | awk -F, {'print $1'})
    export component=$(echo $secret | awk -F, {'print $2'})
    export version=$(echo $secret | awk -F, {'print $3'})
    export DEPLOY_TEMPLATE="$1/deployment/$component/$component.yaml"
    # echo "claim: --$claim-- component: --$component-- version: --$version--"
    yq -i '(.spec.generators.0.matrix.generators.0.list.elements.[] | select(.version == strenv(version)) | .objectNameDbAdmin) |= strenv(claim)' $DEPLOY_TEMPLATE
    git add $DEPLOY_TEMPLATE
    git commit -m "update $DEPLOY_TEMPLATE"
done

for cert in $(kubectl get certificates.cnp.comp.db.de -n $1 --context $2 -o jsonpath='{range .items[*]}{.status.resources.aws-certificate.externalName},{.metadata.labels.cnp\.comp\.db\.de\/component},{.metadata.labels.cnp\.comp\.db\.de\/release}{"\n"}{end}' -l cnp.comp.db.de/component); do
    export arn=$(echo $cert | awk -F, {'print $1'})
    export component=$(echo $cert | awk -F, {'print $2'})
    export version=$(echo $cert | awk -F, {'print $3'})
    export DEPLOY_TEMPLATE="$1/deployment/$component/$component.yaml"
    # echo "claim: --$arn-- component: --$component-- version: --$version--"
    yq -i '(.spec.generators.0.matrix.generators.0.list.elements.[] | select(.version == strenv(version)) | .certificateARN) |= strenv(arn)' $DEPLOY_TEMPLATE
    git add $DEPLOY_TEMPLATE
    git commit -m "update $DEPLOY_TEMPLATE"
done