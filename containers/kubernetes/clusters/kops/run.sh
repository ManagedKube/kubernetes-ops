#!/bin/bash -e

###################################################
##
## This script run inside of Github Actions.
##
## Need to rebuild Docker container on edit: false
##
###################################################

if [ ! -z "${DEBUG}" ]; then
  set -x
fi

CLUSTER_NAME="fargate-cluster"
PIPELINE_VERSION=$(./containers/kubernetes/clusters/kops/fargate-task-definition.sh --create true | grep TASK_DEFINITION_REVISION | grep -o -E "[[:digit:]]+")

# Start Fargate Task
set -x
TASK_ARN=$(aws ecs run-task --cluster ${CLUSTER_NAME}  --task-definition pipeline:${PIPELINE_VERSION} --launch-type "FARGATE" --network-configuration "awsvpcConfiguration={subnets=[subnet-0121a9057485fbe72],securityGroups=[sg-01b56214e8d158906]}" | jq -r .tasks[0].taskArn)
set +x

# Output Fargate task description
set -x
aws ecs describe-tasks --cluster ${CLUSTER_NAME} --tasks ${TASK_ARN}
set +x

TASK_ID=$(echo ${TASK_ARN} | grep -o -e "\/.*" | grep -o -e "[0-9a-z].*")

echo "#########################################"
echo "Command to tail logs while this runs: ecs-cli logs --cluster ${CLUSTER_NAME} --task-id ${TASK_ID}" --follow
echo "#########################################"

# Poll until lastStatus is RUNNING
IS_DONE=false
until ${IS_DONE}
do
    echo "Fargate task is not in a running state yet...wait and poll again. | lastStatus: ${STATUS}"
    sleep 2

    STATUS=$(aws ecs describe-tasks --cluster ${CLUSTER_NAME} --tasks ${TASK_ARN} | jq -r .tasks[0].lastStatus)
    if [ "${STATUS}" == "STOPPED" ]; then
        IS_DONE=true
    fi
done

# Follow logs until it has completed
set -x
ecs-cli logs --cluster ${CLUSTER_NAME} --task-id ${TASK_ID}
set +x