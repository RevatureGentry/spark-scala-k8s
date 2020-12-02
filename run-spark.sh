#!/bin/sh
SPARK_HOME=/mnt/c/Users/WilliamGentry/dev/spark-3.0.1-bin-hadoop2.7
SCHEME="file"
APPLICATION_JAR_LOCATION="$SCHEME:///mnt/c/Users/WilliamGentry/dev/projects/s3-example/target/scala-2.12/s3-example_2.12-0.1.jar"
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
S3_BUCKET=""
S3_INPUT="$S3_BUCKET/path/to/your/data"

set -e

echo "Running job located at $APPLICATION_JAR_LOCATION"

$SPARK_HOME/bin/spark-submit \
    --master k8s://http://localhost:8001 \
    --name s3-example \
    --deploy-mode cluster \
    --class com.revature.Example \
    --packages com.amazonaws:aws-java-sdk:1.7.4,org.apache.hadoop:hadoop-aws:2.7.6 \
    --conf spark.kubernetes.file.upload.path="$S3_BUCKET/spark/" \
    --conf spark.hadoop.fs.s3a.access.key="$AWS_ACCESS_KEY_ID" \
    --conf spark.hadoop.fs.s3a.secret.key="$AWS_SECRET_ACCESS_KEY" \
    --conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem \
    --conf spark.hadoop.fs.s3a.fast.upload=true \
    --conf spark.driver.extraJavaOptions="-Divy.cache.dir=/tmp -Divy.home=/tmp" \
    --conf spark.driver.log.persistToDfs.enabled=true \
    --conf spark.driver.log.dfsDir="$S3_BUCKET/spark-driver-logs/" \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    --conf spark.executor.instances=3 \
    --conf spark.kubernetes.driver.request.cores=1 \
    --conf spark.kubernetes.executor.request.cores=1 \
    --conf spark.hadoop.fs.s3a.path.style.access=true \
    --conf spark.hadoop.fs.s3.impl=org.apache.hadoop.fs.s3native.NativeS3FileSystem \
    --conf spark.hadoop.fs.s3.awsAccessKeyId="$AWS_ACCESS_KEY_ID" \
    --conf spark.hadoop.fs.s3.awsSecretAccessKey="$AWS_SECRET_ACCESS_KEY" \
    --conf spark.executor.request.memory=1g \
    --conf spark.driver.request.memory=1g \
    --conf spark.kubernetes.container.image=855430746673.dkr.ecr.us-east-1.amazonaws.com/adam-king-848-example-spark \
    $APPLICATION_JAR_LOCATION $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY $S3_INPUT