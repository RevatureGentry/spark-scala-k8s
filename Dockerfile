FROM ubuntu
ENV ENV_VAR "a cron job!"
ENTRYPOINT echo "Hello, from ${ENV_VAR}"


# To get to ECR, Invoke the following commands
# docker build -t $ECR_REPO_NAME .
# docker push $ECR_REPO_NAME