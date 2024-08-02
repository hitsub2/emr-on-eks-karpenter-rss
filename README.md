# emr-on-eks-karpenter-rss

## Installation

### Deploy the infrastructure

#### Clone the repository and deploy the infrastructure

```shell
git clone https://github.com/hitsub2/emr-on-eks-karpenter-rss
cd emr-on-eks-karpenter-rss/infra
./install.sh
```

Check if the EKS cluster is up and in function
```shell
kubectl get nodes
kubectl get pods -A
```

#### Check the Celeborn service status

```shell
kubectl get pods -n celeborn
```

output

```shell
NAME                READY   STATUS    RESTARTS   AGE
celeborn-master-0   1/1     Running   0          2d
celeborn-master-1   1/1     Running   0          2d
celeborn-master-2   1/1     Running   0          2d
celeborn-worker-0   1/1     Running   0          2d
celeborn-worker-1   1/1     Running   0          2d
```

## Run examples

### Prepare the data optional

```shell
cd emr-on-eks-karpenter-rss/examples
# modify the parameters if needed
kubectl apply -f tpcds-data-gen.yaml
```

### Run benchmark job

run tpcds sql

```shell
export S3BUCKET_LOG=YOUR_S3_BUCKET
#leave it as default if you do not generate your own data
export S3BUCKET_DATA=blogpost-sparkoneks-us-east-1

```

```shell
cd emr-on-eks-karpenter-rss/examples
./emr7.0-rss-99sql.sh
```

By default, this script will create resource in emr-data-team-a namespace

```shell
kubectl get pods -n emr-data-team-a
```


## Observability for Job tracking

## Celeborn Dashboard

![Celeborn Grafana Dashboard](assets/images/celeborn-monitoring.png "Celeborn Grafana Dashboard")

## Troubleshooting

re-run the ```install.sh``` command if the following error

```shell
╷
│ Warning: Helm release "celeborn" was created but has a failed status. Use the `helm` command to investigate the error, correct it, then run Terraform again.
│
│   with helm_release.celeborn,
│   on apache-celeborn.tf line 1, in resource "helm_release" "celeborn":
│    1: resource "helm_release" "celeborn" {
│
╵
╷
│ Error: context deadline exceeded
│
│   with helm_release.celeborn,
│   on apache-celeborn.tf line 1, in resource "helm_release" "celeborn":
│    1: resource "helm_release" "celeborn" {
│
╵
╷
│ Error: creating EMR Containers Virtual Cluster (emr-eks-rss-emr-data-team-a): operation error EMR containers: CreateVirtualCluster, https response error StatusCode: 400, RequestID: 6e015954-d56e-44a2-8b7d-80727d1d3af4, ValidationException: Required resource emr-data-team-a not found on the cluster. This could be due EMR on EKS not having access to this specific namespace in the cluster. Make sure the namespace is set up properly: https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/setting-up-cluster-access.html.
│
│   with module.emr_containers["data-team-a"].aws_emrcontainers_virtual_cluster.this[0],
│   on .terraform/modules/emr_containers/modules/virtual-cluster/main.tf line 20, in resource "aws_emrcontainers_virtual_cluster" "this":
│   20: resource "aws_emrcontainers_virtual_cluster" "this" {
│
╵
╷
│ Error: creating EMR Containers Virtual Cluster (emr-eks-rss-emr-data-team-b): operation error EMR containers: CreateVirtualCluster, https response error StatusCode: 400, RequestID: 7f28309e-d3a9-48d2-a30e-e40b6e2d5047, ValidationException: Required resource emr-data-team-b not found on the cluster. This could be due EMR on EKS not having access to this specific namespace in the cluster. Make sure the namespace is set up properly: https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/setting-up-cluster-access.html.
│
│   with module.emr_containers["data-team-b"].aws_emrcontainers_virtual_cluster.this[0],
│   on .terraform/modules/emr_containers/modules/virtual-cluster/main.tf line 20, in resource "aws_emrcontainers_virtual_cluster" "this":
│   20: resource "aws_emrcontainers_virtual_cluster" "this" {
│
╵
FAILED: Terraform apply of all modules failed
```