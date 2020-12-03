# Spark, Scala, and Kubernetes
## Getting started
1. Ensure authentication with EKS cluster
    ```shell 
   aws eks --profile $PROFILE_NAME update-kubeconfig --name $CLUSTER_NAME
   kubectl get svc
   ```
2. In a separate terminal window, invoke
    ```shell 
   kubectl proxy # Opens a proxy to the K8s API Server at 127.0.0.1:8001 
   ```
3. Substitute all environment variables in `run-spark.sh` script, namely
    * `$SPARK_HOME`
    * `$APPLICATION_JAR_LOCATION`
4. Invoke the script from a different terminal session than the one running `kubectl proxy`
    ```shell 
   ./run-spark.sh $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY $S3_BUCKET
   ```
5. Watch for the Spark Driver pod to initialize in order to watch logs
    * Will be in the format of `${spark.app.name}-$UUID-driver`
    * To watch the logs live, invoke the command
        ```shell 
        kubectl logs -f `${spark.app.name}-$UUID-driver`   
        ```