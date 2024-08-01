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

export S3BUCKET_LOG=YOUR_S3_BUCKET

# leave it as default if you do not generate your own data
export S3BUCKET_DATA=blogpost-sparkoneks-us-east-1

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
