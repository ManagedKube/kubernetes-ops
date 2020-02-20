#!/bin/bash -e

###################################################
##
## This script run inside of Github Actions.
##
## Need to rebuild Docker container on edit: false
##
###################################################

echo "###################################################"
echo "running: run.sh"
echo "###################################################"

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
echo "This is unable to tail the Fargate logs while this runs because there is no ending indication to when the tail should stop.  If we simply tailed the Fargate logs, the tail would hang there after the job has stopped."
echo "Command to tail logs while this runs: ecs-cli logs --cluster ${CLUSTER_NAME} --task-id ${TASK_ID}" --follow
echo "#########################################"

# Poll until lastStatus is RUNNING
IS_DONE=false
until ${IS_DONE}
do
    echo "[INFO] Command to tail logs while this runs: ecs-cli logs --cluster ${CLUSTER_NAME} --task-id ${TASK_ID}" --follow
    
    STATUS=$(aws ecs describe-tasks --cluster ${CLUSTER_NAME} --tasks ${TASK_ARN} | jq -r .tasks[0].lastStatus)
    if [ "${STATUS}" == "STOPPED" ]; then
        ecs-cli logs --cluster ${CLUSTER_NAME} --task-id ${TASK_ID} --since 1

        echo "[INFO] The Fargate job has completed"

        IS_DONE=true
    elif [ "${STATUS}" == "RUNNING" ]; then
      
        # Return logs that are 1 min old
        ecs-cli logs --cluster ${CLUSTER_NAME} --task-id ${TASK_ID} --since 1

        echo "[INFO] [Status: ${STATUS}] Sleeping 60 seconds then outputting logs from the Fargate run..."
        sleep 60
    else
      echo "[INFO] Fargate task is not in a running state yet...wait and poll again. | lastStatus: ${STATUS}"
      sleep 2

    fi
done

# Follow logs until it has completed
set -x
ecs-cli logs --cluster ${CLUSTER_NAME} --task-id ${TASK_ID}
set +x