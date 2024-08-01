#!/bin/bash
# SPDX-FileCopyrightText: Copyright 2021 Amazon.com, Inc. or its affiliates.
# SPDX-License-Identifier: MIT-0

export EMRCLUSTER_NAME=emr-eks-rss-emr-data-team-a
export AWS_REGION=us-west-2
export ACCOUNTID=$(aws sts get-caller-identity --query Account --output text)
export VIRTUAL_CLUSTER_ID=$(aws emr-containers list-virtual-clusters --query "virtualClusters[?name == '$EMRCLUSTER_NAME' && state == 'RUNNING'].id" --output text)
export EMR_ROLE_ARN=arn:aws:iam::$ACCOUNTID:role/emr-eks-rss-emr-data-team-a
export S3BUCKET_LOG=spark-data-rss
export S3BUCKET_DATA=blogpost-sparkoneks-us-east-1
export ECR_URL="$ACCOUNTID.dkr.ecr.$AWS_REGION.amazonaws.com"

aws emr-containers start-job-run \
  --virtual-cluster-id $VIRTUAL_CLUSTER_ID \
  --name celeborn-testing-emr7  \
  --execution-role-arn $EMR_ROLE_ARN \
  --release-label emr-7.0.0-latest \
  --job-driver '{
  "sparkSubmitJobDriver": {
      "entryPoint": "local:///usr/lib/spark/examples/jars/eks-spark-benchmark-assembly-1.0.jar",
      "entryPointArguments":["s3://'$S3BUCKET_DATA'/BLOG_TPCDS-TEST-3T-partitioned","s3://'$S3BUCKET_DATA'/EMRONEKS_TPCDS-TEST-3T-RESULT","/opt/tpcds-kit/tools","parquet","3000","1","false","q2-v2.4,q3-v2.4,q4-v2.4,q5-v2.4,q6-v2.4,q7-v2.4,q8-v2.4,q9-v2.4,q10-v2.4,q11-v2.4,q12-v2.4,q13-v2.4,q14-v2.4,q14a-v2.4,q14b-v2.4,q15-v2.4,q16-v2.4,q17-v2.4,q18-v2.4,q19-v2.4,q20-v2.4,q21-v2.4,q22-v2.4,q23-v2.4,q23a-v2.4,q23b-v2.4,q24-v2.4,q24a-v2.4,q24b-v2.4,q25-v2.4,q26-v2.4,q27-v2.4,q28-v2.4,q29-v2.4,q30-v2.4,q31-v2.4,q32-v2.4,q33-v2.4,q34-v2.4,q35-v2.4,q36-v2.4,q37-v2.4,q38-v2.4,q39a-v2.4,q39b-v2.4,q39-v2.4,q40-v2.4,q41-v2.4,q42-v2.4,q43-v2.4,q44-v2.4,q45-v2.4,q46-v2.4,q47-v2.4,q48-v2.4,q49-v2.4,q50-v2.4,q51-v2.4,q52-v2.4,q53-v2.4,q54-v2.4,q55-v2.4,q56-v2.4,q57-v2.4,q58-v2.4,q59-v2.4,q60-v2.4,q61-v2.4,q62-v2.4,q63-v2.4,q64-v2.4,q65-v2.4,q66-v2.4,q67-v2.4,q68-v2.4,q69-v2.4,q70-v2.4,q71-v2.4,q72-v2.4,q73-v2.4,q74-v2.4,q75-v2.4,q76-v2.4,q77-v2.4,q78-v2.4,q79-v2.4,q80-v2.4,q81-v2.4,q82-v2.4,q83-v2.4,q84-v2.4,q85-v2.4,q86-v2.4,q87-v2.4,q88-v2.4,q89-v2.4,q90-v2.4,q91-v2.4,q92-v2.4,q93-v2.4,q94-v2.4,q95-v2.4,q96-v2.4,q97-v2.4,q98-v2.4,q99-v2.4","true"],
      "sparkSubmitParameters": "--class com.amazonaws.eks.tpcds.BenchmarkSQL --conf spark.kubernetes.container.image=724853865853.dkr.ecr.us-west-2.amazonaws.com/celeborn-client:3.5.0 --conf spark.driver.cores=2 --conf spark.driver.memory=3g --conf spark.executor.cores=4 --conf spark.executor.memory=6g --conf spark.executor.instances=5"}}' \
  --configuration-overrides '{
    "applicationConfiguration": [
      {
                 "classification": "spark-defaults",
                 "properties": {
                   "spark.kubernetes.container.image": "724853865853.dkr.ecr.us-west-2.amazonaws.com/celeborn-client:3.5.0",
                   "spark.network.timeout": "2000s",
                   "spark.executor.heartbeatInterval": "300s",
                   "spark.kubernetes.executor.podNamePrefix": "celeborn-testing-emr7",
                   "spark.kubernetes.node.selector.NodeGroupType": "SparkMemoryOptimized",
                   "spark.driver.memoryOverhead": "1000",
                   "spark.executor.memoryOverhead": "2G",
 
                   "spark.shuffle.service.enabled": "false",
                   "spark.dynamicAllocation.enabled": "true",
                   "spark.dynamicAllocation.shuffleTracking.enabled": "false",
                   "spark.sql.adaptive.localShuffleReader.enabled":"false",
                   "spark.dynamicAllocation.minExecutors": "1",
                   "spark.dynamicAllocation.executorIdleTimeout": "5s",
                   "spark.dynamicAllocation.schedulerBacklogTimeout": "5s",
                   "spark.dynamicAllocation.sustainedSchedulerBacklogTimeout": "5s",
 
                   "spark.celeborn.shuffle.chunk.size": "4m",
                   "spark.celeborn.client.push.maxReqsInFlight": "128",
                   "spark.celeborn.rpc.askTimeout": "2000s",
                   "spark.celeborn.client.push.replicate.enabled": "true",
                   "spark.celeborn.client.push.excludeWorkerOnFailure.enabled": "true",
                   "spark.celeborn.client.fetch.excludeWorkerOnFailure.enabled": "true",
                   "spark.celeborn.client.commitFiles.ignoreExcludedWorker": "true",
                   "spark.shuffle.manager": "org.apache.spark.shuffle.celeborn.SparkShuffleManager",
                   "spark.shuffle.sort.io.plugin.class": "org.apache.spark.shuffle.celeborn.CelebornShuffleDataIO",
                   "spark.celeborn.master.endpoints": "celeborn-master-0.celeborn-master-svc.celeborn:9097,celeborn-master-1.celeborn-master-svc.celeborn:9097,celeborn-master-2.celeborn-master-svc.celeborn:9097",
                   "spark.sql.optimizedUnsafeRowSerializers.enabled":"false",
                   "spark.serializer": "org.apache.spark.serializer.KryoSerializer",
 
                   "spark.kubernetes.submission.connectionTimeout": "60000000",
                   "spark.kubernetes.submission.requestTimeout": "60000000",
                   "spark.kubernetes.driver.connectionTimeout": "60000000",
                   "spark.kubernetes.driver.requestTimeout": "60000000",

                   "spark.metrics.appStatusSource.enabled":"true",
                   "spark.ui.prometheus.enabled":"true",
                   "spark.executor.processTreeMetrics.enabled":"true",
                   "spark.kubernetes.driver.annotation.prometheus.io/scrape":"true",
                   "spark.kubernetes.driver.annotation.prometheus.io/path":"/metrics/executors/prometheus/",
                   "spark.kubernetes.driver.annotation.prometheus.io/port":"4040",
                   "spark.kubernetes.driver.service.annotation.prometheus.io/scrape":"true",
                   "spark.kubernetes.driver.service.annotation.prometheus.io/path":"/metrics/driver/prometheus/",
                   "spark.kubernetes.driver.service.annotation.prometheus.io/port":"4040",
                   "spark.metrics.conf.*.sink.prometheusServlet.class":"org.apache.spark.metrics.sink.PrometheusServlet",
                   "spark.metrics.conf.*.sink.prometheusServlet.path":"/metrics/driver/prometheus/",
                   "spark.metrics.conf.master.sink.prometheusServlet.path":"/metrics/master/prometheus/",
                   "spark.metrics.conf.applications.sink.prometheusServlet.path":"/metrics/applications/prometheus/"
          }
      }
    ],
    "monitoringConfiguration": {
      "persistentAppUI":"ENABLED",
      "s3MonitoringConfiguration": {
        "logUri": "'"s3://$S3BUCKET_LOG"'/logs/spark/"
      }
    }
  }'
