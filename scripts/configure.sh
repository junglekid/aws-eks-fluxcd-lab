#!/usr/bin/env bash

function replace_in_file() {
    if [ "$(uname)" == "Darwin" ]; then
        # Do something under Mac OS X platform
        sed -i '' -e "$1" "$2"
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        sed -i -e "$1" "$2"
    fi
}

cd ../terraform
AWS_REGION=$(terraform output -raw aws_region)
EKS_CLUSTER_NAME=$(terraform output -raw eks_cluster_name)
EXTERNAL_DNS_DOMAIN_FILTER=$(terraform output -raw domain_filter)
SA_ALB_NAME=$(terraform output -raw eks_sa_alb_name)
SA_EXTERNAL_DNS_NAME=$(terraform output -raw eks_sa_external_dns_name)
AWS_WEAVE_GITOPS_DOMAIN_NAME=$(terraform output -raw weave_gitops_domain_name)
AWS_ACM_WEAVE_GITOPS_ARN=$(terraform output -raw weave_gitops_acm_certificate_arn)
AWS_PODINFO_DOMAIN_NAME=$(terraform output -raw podinfo_domain_name)
AWS_ACM_PODINFO_ARN=$(terraform output -raw podinfo_acm_certificate_arn)
# WEAVE_GITOPS_PASSWORD="admin1234"
# WEAVE_GITOPS_PASSWORD_HASH=$(printf "%s" $WEAVE_GITOPS_PASSWORD | tr -d '\n' | gitops get bcrypt-hash)

echo $WEAVE_GITOPS_PASSWORD | tr -d '\n'

gitops get bcrypt-hash <<< $WEAVE_GITOPS_PASSWORD

echo "Configuring access to Amazon EKS Cluster..."
aws eks --region $AWS_REGION update-kubeconfig --name $EKS_CLUSTER_NAME
echo ""

cd ..
echo "Configuring Apps managed by FluxCD..."
cp -f ./k8s/templates/apps/base/podinfo.yaml ./k8s/apps/base/podinfo.yaml
replace_in_file 's|AWS_PODINFO_DOMAIN_NAME|'"$AWS_PODINFO_DOMAIN_NAME"'|g' ./k8s/apps/base/podinfo.yaml
replace_in_file 's|AWS_ACM_PODINFO_ARN|'"$AWS_ACM_PODINFO_ARN"'|g' ./k8s/apps/base/podinfo.yaml

cp -f ./k8s/templates/apps/base/weave-gitops.yaml ./k8s/apps/base/weave-gitops.yaml
replace_in_file 's|AWS_WEAVE_GITOPS_DOMAIN_NAME|'"$AWS_WEAVE_GITOPS_DOMAIN_NAME"'|g' ./k8s/apps/base/weave-gitops.yaml
replace_in_file 's|AWS_ACM_WEAVE_GITOPS_ARN|'"$AWS_ACM_WEAVE_GITOPS_ARN"'|g' ./k8s/apps/base/weave-gitops.yaml
# replace_in_file 's|WEAVE_GITOPS_PASSWORD_HASH|'"$WEAVE_GITOPS_PASSWORD_HASH"'|g' ./k8s/apps/base/weave-gitops.yaml

cp -f ./k8s/templates/infrastructure/addons/aws-load-balancer-controller.yaml ./k8s/infrastructure/addons/aws-load-balancer-controller.yaml
replace_in_file 's|SA_ALB_NAME|'"$SA_ALB_NAME"'|g' ./k8s/infrastructure/addons/aws-load-balancer-controller.yaml
replace_in_file 's|AWS_REGION|'"$AWS_REGION"'|g' ./k8s/infrastructure/addons/aws-load-balancer-controller.yaml
replace_in_file 's|EKS_CLUSTER_NAME|'"$EKS_CLUSTER_NAME"'|g' ./k8s/infrastructure/addons/aws-load-balancer-controller.yaml

cp -f ./k8s/templates/infrastructure/addons/external-dns.yaml ./k8s/infrastructure/addons/external-dns.yaml
replace_in_file 's|EXTERNAL_DNS_DOMAIN_FILTER|'"$EXTERNAL_DNS_DOMAIN_FILTER"'|g' ./k8s/infrastructure/addons/external-dns.yaml
replace_in_file 's|SA_EXTERNAL_DNS_NAME|'"$SA_EXTERNAL_DNS_NAME"'|g' ./k8s/infrastructure/addons/external-dns.yaml
replace_in_file 's|AWS_REGION|'"$AWS_REGION"'|g' ./k8s/infrastructure/addons/external-dns.yaml
replace_in_file 's|EKS_CLUSTER_NAME|'"$EKS_CLUSTER_NAME"'|g' ./k8s/infrastructure/addons/external-dns.yaml

git add ./k8s/apps/base/podinfo.yaml
git add ./k8s/apps/base/weave-gitops.yaml
git add ./k8s/infrastructure/addons/aws-load-balancer-controller.yaml
git add ./k8s/infrastructure/addons/external-dns.yaml
git commit -m "Updating Apps"
git push
