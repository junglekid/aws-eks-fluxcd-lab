# Amazon EKS and FluxCD Lab
https://fluxcd.io/flux/get-started/
## Setup

Follow these steps to set up the environment.

1. Set variables in "locals.tf". Below are some of the variables that should be set.

   * aws region
   * aws profile
   * tags
   * custom_domain_name
   * public_domain

2. Update Terraform S3 Backend in provider.tf

   * bucket
   * key
   * profile
   * dynamodb_table

3. Initialize Terraform

   ```bash
   terraform init
   ```

4. Validate the Terraform code

   ```bash
   terraform validate
   ```

5. Run, review, and save a Terraform plan

   ```bash
   terraform plan -out=plan.out
   ```

6. Apply the Terraform plan

   ```bash
   terraform apply plan.out
   ```

7. Review Terraform apply results

   ![Terraform Apply](./images/terraform_apply.png)

## Configure access to Amazon EKS Cluster

EKS Cluster details can be extracted from terraform output or from AWS Console to get the name of cluster. This following command can be used to update the kubeconfig in your local machine where you run kubectl commands to interact with your EKS Cluster.

```bash
cd terraform
AWS_REGION=$(terraform output -raw aws_region)
EKS_CLUSTER_NAME=$(terraform output -raw eks_cluster_name)
aws eks --region $AWS_REGION update-kubeconfig --name $EKS_CLUSTER_NAME
```

## Build the Docker image

Set the variables needed to build and push your Docker image. Navigate to the root of the directory of the GitHub repo and run the following commands:

```bash
cd ..
AWS_REGION=$(terraform output -raw aws_region)
ECR_REPO=$(terraform output -raw ecr_repo_url)
```

To build the Docker image, run the following command:

```bash
docker build --platform linux/amd64 --no-cache --pull -t ${ECR_REPO}:latest ./react-app
```

## Push the Docker image to Amazon ECR

To push the Docker image to Amazon ECR, authenticate to your private Amazon ECR registry. To do this, run the following command:

```bash
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
```

Once authenticated, run the following command to push your Docker image to the Amazon ECR repository:

```bash
docker push ${ECR_REPO}:latest
```



Flux&Git0ps
$2a$10$z6BEJcTqCTgxlYr3YLOwo.TO4PhKPHagHWNVDItGwfyuJa/2EfM3K

Results of configuring kubeconfig.

![Configure Amazon EKS Cluster](./images/kubeconfig.png)


export GITHUB_TOKEN='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'
export GITHUB_USER='junglekid'

PASSWORD="admin123"
echo $PASSWORD | gitops get bcrypt-hash

PASSWORD="admin123"
printf $PASSWORD

print $PASSWORD | gitops get bcrypt-hash

PASSWORD="admin1234"
gitops create dashboard weave-gitops \
  --password=$PASSWORD \
  --export > weave-gitops-dashboard.yaml


Install


echo -n 'admin' | gitops get bcrypt-hash


clusters/eks-fluxcd-lab

flux bootstrap github \
  --components-extra=image-reflector-controller,image-automation-controller \
  --owner=junglekid \
  --repository=aws-eks-fluxcd-lab \
  --private=false \
  --path=clusters/eks-fluxcd-lab \
  --personal

flux reconcile source git flux-system

flux resume kustomization --all
flux resume source helm --all
flux resume source git --all
flux resume helmrelease --all

flux suspend

flux suspend kustomization apps-addons apps-namespaces apps-sources
flux delete helmrelease -s podinfo
flux delete helmrelease -s weave-gitops

flux delete source helm -s weave-gitops
flux delete source helm -s podinfo
kubectl delete ns podinfo

flux resume kustomization apps-addons apps-namespaces apps-sources

flux suspend kustomization infra-addons infra-configs infra-sources
flux delete helmrelease -s metrics-server
flux delete helmrelease -s external-dns
flux delete helmrelease -s aws-load-balancer-controller
flux delete helmrelease -s cluster-autoscaler

flux delete source helm -s metrics-server
flux delete source helm -s external-dns
flux delete source helm -s eks-charts

flux uninstall -s


flux create source git flux-monitoring \
--interval=30m \
--url=https://github.com/fluxcd/flux2 \
--branch=main \
--export

flux create kustomization kube-prometheus-stack \
  --interval=1h \
  --prune \
  --source=flux-monitoring \
  --path="./manifests/monitoring/kube-prometheus-stack" \
  --health-check-timeout=5m \
  --wait \
  --export

flux create kustomization monitoring-config \
  --depends-on=kube-prometheus-stack \
  --interval=1h \
  --prune=true \
  --source=flux-monitoring \
  --path="./manifests/monitoring/monitoring-config" \
  --health-check-timeout=1m \
  --wait \
  --export

AWS_REGION=$(terraform output -raw aws_region)
EKS_CLUSTER_NAME=$(terraform output -raw eks_cluster_name)
EKS_CLUSTER_ENDPOINT=$(terraform output -raw eks_cluster_endpoint)
EXTERNAL_DNS_DOMAIN_FILTER=$(terraform output -raw domain_filter)
SA_ALB_NAME=$(terraform output -raw eks_sa_alb_name)
SA_ALB_IAM_ROLE_ARN=$(terraform output -raw eks_sa_alb_iam_role_arn)
SA_EXTERNAL_DNS_NAME=$(terraform output -raw eks_sa_external_dns_name)
SA_EXTERNAL_DNS_IAM_ROLE_ARN=$(terraform output -raw eks_sa_external_dns_iam_role_arn)
SA_CLUSTER_AUTOSCALER_NAME=$(terraform output -raw eks_sa_cluster_autoscaler_name)
SA_CLUSTER_AUTOSCALER_IAM_ROLE_ARN=$(terraform output -raw eks_sa_cluster_autoscaler_iam_role_arn)
AWS_WEAVE_GITOPS_DOMAIN_NAME=$(terraform output -raw weave_gitops_domain_name)
AWS_ACM_WEAVE_GITOPS_ARN=$(terraform output -raw weave_gitops_acm_certificate_arn)
AWS_PODINFO_DOMAIN_NAME=$(terraform output -raw podinfo_domain_name)
AWS_ACM_PODINFO_ARN=$(terraform output -raw podinfo_acm_certificate_arn)
AWS_REACT_APP_DOMAIN_NAME=$(terraform output -raw react_app_domain_name)
AWS_ACM_REACT_APP_ARN=$(terraform output -raw react_app_acm_certificate_arn)
ECR_REPO=$(terraform output -raw ecr_repo_url)

export KARPENTER_VERSION=v0.29.2

helm upgrade --install karpenter oci://public.ecr.aws/karpenter/karpenter --version ${KARPENTER_VERSION} --namespace karpenter --create-namespace \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=${KARPENTER_IAM_ROLE_ARN} \
  --set settings.aws.clusterName=${EKS_CLUSTER_NAME} \
  --set settings.aws.clusterEndpoint=${EKS_CLUSTER_ENDPOINT} \
  --set settings.aws.defaultInstanceProfile=${KARPENTER_INSTANCE_PROFILE_NAME} \
  --set settings.aws.interruptionQueueName=${KARPENTER_QUEUE_NAME} \
  --wait

  --set controller.resources.requests.cpu=1 \
  --set controller.resources.requests.memory=1Gi \
  --set controller.resources.limits.cpu=1 \
  --set controller.resources.limits.memory=1Gi \

eksctl get iamidentitymapping --cluster $EKS_CLUSTER_NAME --region=$AWS_REGION

controller.interruption	getting messages from queue, discovering queue url, fetching queue url, AWS.SimpleQueueService.NonExistentQueue: The specified queue does not exist for this wsdl version.

cat <<EOF | kubectl apply -f -
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: default
spec:
  requirements:
    - key: karpenter.sh/capacity-type
      operator: In
      values: ["spot"]
    - key: node.kubernetes.io/instance-type
      operator: In
      values:
      - m5a.large
      - m5.large
  providerRef:
    name: default
---
apiVersion: karpenter.k8s.aws/v1alpha1
kind: AWSNodeTemplate
metadata:
  name: default
spec:
  subnetSelector:
    karpenter.sh/discovery: eks-fluxcd-lab
  securityGroupSelector:
    karpenter.sh/discovery: eks-fluxcd-lab
EOF


  tags:
    karpenter.sh/discovery: eks-fluxcd-lab

aws sts decode-authorization-message --encoded-message WfGludc4jXepn7oIGxitrqcNf4zww7RDLEQ_T98Q135_gHU-YGwN_W3g8UzyeYzgwuWX1u8d_Ym9HQRZZuykYZTGfaxVypfOawtnvS5dKBgkHr5QG5Og3NCS30zOGflKdqWAHNgsRjKc-AE13kkcFhAVbeaDRwqQpMPflcGXlD50gNAjr-ksL0Im5s8jJLfhN87oTPCQJ340cXNHH2FfEgZUn3HA_AmfTD9b92dx6_Wxp31HB9Pr06bY-_w8ZLj3o5M482ZwgVkOtfaSG9gcsC5ogdaw8_iKxH3NUWmbwGxpJWZj3oML_j3wEgqtjlGWDKQ3BDdITVOxOekSKnRx_1_WAy3ckRCcGFt1h_0QQD0zMSUZMO8d4hCOkbKyQd3YPhfHD-LWUyGkmnHg2ac-zcknDH7Kmn92ZPHGNJakKECCtlZOaD6PDVagwj5tzcUsVsda0RDYINO0cz1gnYKc9yEyfNe0SQvaIe_jQSfs4sW3IUyV7Ke5cf8QDKjfk7Oyyxa8M3rLSWkvCO7MXVTWVJ04kSFGsSAiLH1hY7r5_fqgtTcQDy-FRI-t-K_IlPz3mtfqNNTLcHqcqk3X13y2I37RBfeCjSfO0hNzaz4WobyIdw7d998-BKRKgV3B7UtfZaHYpAlfluRyYY2RcTSxc_jIyG_nBswAgHWJEsSMknlgbVYxuXbws0YDq9Bw21Ks5qD4rl5Ow6yi4CRvHzyZcKH2-vZN0Q5ahFWbCcSERIMQXwXMOmcPur53gqzbASzDol80ti0Sgc7NEGnR5AE1KTq7eeHbC2vzajoygXbkm3eTSUHSzUJjJ8FHPuqBYsQ | jq


  ttlSecondsAfterEmpty: 30
  ttlSecondsUntilExpired: 172800

aws --region us-west-2 ec2 describe-subnets --filters Name=tag:karpenter.sh/discovery,Values=eks-fluxcd-lab


apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::704855531002:role/node_workers-eks-node-group-20230810234216535800000006
      username: system:node:{{EC2PrivateDNSName}}
kind: ConfigMap
metadata:
  creationTimestamp: "2023-08-10T23:53:41Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "854"
  uid: ac7755da-bd03-4f65-97ee-a8ada63b6748

AWS_REGION=$(terraform output -raw aws_region)
EKS_CLUSTER_NAME=$(terraform output -raw eks_cluster_name)
EKS_CLUSTER_ENDPOINT=$(terraform output -raw eks_cluster_endpoint)
EXTERNAL_DNS_DOMAIN_FILTER=$(terraform output -raw domain_filter)
SA_ALB_NAME=$(terraform output -raw eks_sa_alb_name)
SA_EXTERNAL_DNS_NAME=$(terraform output -raw eks_sa_external_dns_name)
AWS_WEAVE_GITOPS_DOMAIN_NAME=$(terraform output -raw weave_gitops_domain_name)
AWS_ACM_WEAVE_GITOPS_ARN=$(terraform output -raw weave_gitops_acm_certificate_arn)
AWS_PODINFO_DOMAIN_NAME=$(terraform output -raw podinfo_domain_name)
AWS_ACM_PODINFO_ARN=$(terraform output -raw podinfo_acm_certificate_arn)
KARPENTER_IAM_ROLE_ARN=$(terraform output -raw eks_karpenter_irsa_arn)
KARPENTER_INSTANCE_PROFILE_NAME=$(terraform output -raw eks_karpenter_instance_profile_name)
KARPENTER_QUEUE_NAME=$(terraform output -raw eks_karpenter_queue_name)

helm upgrade --install cluster-autoscaler autoscaler/cluster-autoscaler \
    --set "autoDiscovery.clusterName=$EKS_CLUSTER_NAME" \
    --set "awsRegion=$AWS_REGION" \
    --set "cloudProvider=aws" \
    --set "rbac.serviceAccount.create=false" \
    --set "rbac.serviceAccount.name=sa-cluster-autoscaler" \
    --set "replicaCount=2" \
    --namespace=kube-system

helm upgrade --install cluster-autoscaler autoscaler/cluster-autoscaler \
    --set "autoDiscovery.clusterName=$EKS_CLUSTER_NAME" \
    --set "awsRegion=$AWS_REGION" \
    --set "cloudProvider=aws" \
    --set rbac.serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::704855531002:role/eks-fluxcd-lab-cluster-autoscaler \
    --set "replicaCount=2" \
    --namespace=kube-system



helm upgrade -i my-release oci://ghcr.io/stefanprodan/charts/podinfo


helm repo add podinfo https://stefanprodan.github.io/podinfo

helm upgrade -i podinfo podinfo/podinfo \
  --values values.yaml

  --set "ingress.enabled=true" \
  --set "ingress.className=alb" \
  --set "annotations.alb.ingress.kubernetes.io/certificate-arn=arn:aws:acm:us-west-2:704855531002:certificate/394d0c68-0354-45ff-bd32-48d1f6fa4d32" \
  --set "annotations.alb.ingress.kubernetes.io/scheme=internet-facing" \
  --set "annotations.alb.ingress.kubernetes.io/ssl-redirect=443" \
  --set "annotations.alb.ingress.kubernetes.io/target-type=ip" \
  --set "annotations.external-dns.alpha.kubernetes.io/hostname=eks-podinfo-lab.dallin.brewsentry.com" \
  --set "replicaCount=2"


--set "annotations.alb.ingress.kubernetes.io/actions.ssl-redirect={\"Type\": \"redirect\", \"RedirectConfig\":
          { \"Protocol\": \"HTTPS\", \"Port\": \"443\", \"StatusCode\": \"HTTP_301\"}}" \
  --set "annotations.alb.ingress.kubernetes.io/listen-ports=\'[{\"HTTP\": 80}, {\"HTTPS\": 443}]\'" \
