#!/bin/bash -e

if [ ! -z "${DEBUG}" ]; then
  set -x
fi

CLUSTER_NAME="fargate-cluster"
PIPELINE_VERSION=20

# Start Fargate Task
TASK_ARN=$(aws ecs run-task --cluster ${CLUSTER_NAME}  --task-definition pipeline:${PIPELINE_VERSION} --launch-type "FARGATE" --network-configuration "awsvpcConfiguration={subnets=[subnet-0121a9057485fbe72],securityGroups=[sg-01b56214e8d158906]}" | jq -r .tasks[0].taskArn)

# Output Fargate task description
aws ecs describe-tasks --cluster ${CLUSTER_NAME} --tasks ${TASK_ARN}

# Poll until lastStatus is RUNNING
IS_DONE=false
until ${IS_DONE}
do
    echo "Fargate task is not in a running state yet...wait and poll again. | lastStatus: ${STATUS}"
    sleep 2

    STATUS=$(aws ecs describe-tasks --cluster ${CLUSTER_NAME} --tasks ${TASK_ARN} | jq -r .tasks[0].lastStatus)
    if [ "${STATUS}" == "RUNNING" ]; then
        IS_DONE=true
    fi
done

TASK_ID=$(echo ${TASK_ARN} | grep -o -e "\/.*" | grep -o -e "[0-9a-z].*")

# Follow logs until it has completed
ecs-cli logs --cluster ${CLUSTER_NAME} --task-id ${TASK_ID} --follow