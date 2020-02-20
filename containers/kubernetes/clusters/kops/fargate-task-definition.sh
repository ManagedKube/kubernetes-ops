#!/bin/bash -e

###################################################
##
## This script run inside of Github Actions.
##
## Need to rebuild Docker container on edit: false
##
###################################################

echo "###################################################"
echo "running: fargate-task-definition.sh"
echo "###################################################"

if [ ! -z "${DEBUG}" ]; then
  set -x
fi

create="false"

while [ "$1" != "" ]; do
    case $1 in
        -c | --create )        shift
                                create=true
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

#######################
# Github Action envars
#
# Doc: The branch or tag ref that triggered the workflow. For example, refs/heads/feature-branch-1. If neither a branch or tag is available for the event type, the variable will not exist.
# https://help.github.com/en/actions/automating-your-workflow-with-github-actions/using-environment-variables
#######################
export GITHUB_REF=${GITHUB_REF}
export KOPS_STATE_STORE=${KOPS_STATE_STORE}
echo "GITHUB_REF: ${GITHUB_REF}"
echo "KOPS_STATE_STORE ${KOPS_STATE_STORE}"

#######################
# execution policy
#######################
EXECUTION_POLICY_PATH="/kubernetesops/fargate/policy/execution/"
EXECUTION_POLICY_LENGTH=$(aws iam list-policies --path-prefix ${EXECUTION_POLICY_PATH} | jq '.Policies | length')

if [ "${EXECUTION_POLICY_LENGTH}" -eq "0" ]; then
    echo "No execution policy found"

    if [ "${create}" == "true" ]; then
        echo "Creating execution policy..."
        POLICY_ARN_EXECUTION=$(aws iam create-policy --policy-name kubernetesOpsKopsFargateTaskExecution --path ${EXECUTION_POLICY_PATH} --description "A policy for the ECS execution agent." --policy-document file://${PWD}/containers/kubernetes/clusters/kops/fargate/task-execution-policy.json | jq -r .Policy.Arn)

        echo "created execution policy: ${POLICY_ARN_EXECUTION}"
    fi
else
    POLICY_ARN_EXECUTION=$(aws iam list-policies --path-prefix ${EXECUTION_POLICY_PATH} | jq -r .Policies[0].Arn)
    echo "found execution policy: ${POLICY_ARN_EXECUTION}"
fi

#######################
# execution role
#######################
EXECUTION_ROLE_PATH="/kubernetesops/fargate/role/execution/"
EXECUTION_ROLE_LENGTH=$(aws iam list-roles --path-prefix ${EXECUTION_ROLE_PATH} | jq '.Roles | length')

if [ "${EXECUTION_ROLE_LENGTH}" -eq "0" ]; then
    echo "No execution role found"

    if [ "${create}" == "true" ]; then
        echo "Creating execution role..."
        export ROLE_ARN_EXECUTION=$(aws iam create-role --role-name kubernetesOpsKopsFargateTaskExecution --path ${EXECUTION_ROLE_PATH} --description "a role for the ECS execution agent." --assume-role-policy-document file://${PWD}/containers/kubernetes/clusters/kops/fargate/task-role-trust-relationship.json | jq -r .Role.Arn)

        echo "created execution role: ${ROLE_ARN_EXECUTION}"
    fi
else
    export ROLE_ARN_EXECUTION=$(aws iam list-roles --path-prefix ${EXECUTION_ROLE_PATH} | jq -r '.Roles[0].Arn')
    echo "found execution role: ${ROLE_ARN_EXECUTION}"
fi

#######################
# Attache policy to the role
#######################
aws iam attach-role-policy --role-name kubernetesOpsKopsFargateTaskExecution --policy-arn ${POLICY_ARN_EXECUTION}

#######################
# task policy
#######################
TASK_POLICY_PATH="/kubernetesops/fargate/policy/task/"
TAKS_POLICY_LENGTH=$(aws iam list-policies --path-prefix ${TASK_POLICY_PATH} | jq '.Policies | length')

if [ "${TAKS_POLICY_LENGTH}" -eq "0" ]; then
    echo "No task policy found"

    if [ "${create}" == "true" ]; then
        echo "Creating task policy..."
        POLICY_ARN_TASK=$(aws iam create-policy --policy-name kubernetesOpsKopsFargateTask --path ${TASK_POLICY_PATH} --description "A policy for the Fargate container to use." --policy-document file://${PWD}/containers/kubernetes/clusters/kops/fargate/task-policy.json | jq -r .Policy.Arn)

        echo "created task policy: ${POLICY_ARN_TASK}"
    fi
else
    POLICY_ARN_TASK=$(aws iam list-policies --path-prefix ${TASK_POLICY_PATH} | jq -r .Policies[0].Arn)
    echo "found task policy: ${POLICY_ARN_TASK}"
fi

#######################
# task role
#######################
TASK_ROLE_PATH="/kubernetesops/fargate/role/task/"
TASK_ROLE_LENGTH=$(aws iam list-roles --path-prefix ${TASK_ROLE_PATH} | jq '.Roles | length')

if [ "${TASK_ROLE_LENGTH}" -eq "0" ]; then
    echo "No task role found"

    if [ "${create}" == "true" ]; then
        echo "Creating task role..."
        export ROLE_ARN_TASK=$(aws iam create-role --role-name kubernetesOpsKopsFargateTask --path ${TASK_ROLE_PATH} --description "a role for the Fargate container to use." --assume-role-policy-document file://${PWD}/containers/kubernetes/clusters/kops/fargate/task-role-trust-relationship.json | jq -r .Role.Arn)

        echo "created task role: ${ROLE_ARN_TASK}"
    fi
else
    export ROLE_ARN_TASK=$(aws iam list-roles --path-prefix ${TASK_ROLE_PATH} | jq -r '.Roles[0].Arn')
    echo "found task role: ${ROLE_ARN_TASK}"
fi

#######################
# Attache policy to the role
#######################
aws iam attach-role-policy --role-name kubernetesOpsKopsFargateTask --policy-arn ${POLICY_ARN_TASK}

#######################
# Create Fargate task definition
#######################
cat ./containers/kubernetes/clusters/kops/fargate/task-definition-template.json | jq  '.executionRoleArn=env.ROLE_ARN_EXECUTION' | jq '.taskRoleArn=env.ROLE_ARN_TASK' | jq '.containerDefinitions[0].environment[0].value=env.KOPS_STATE_STORE'   | jq '.containerDefinitions[0].environment[3].value=env.GIT_URL_WITH_DEPLOY_KEY'                   | jq '.containerDefinitions[0].command[3]=env.GITHUB_REF'           > ./containers/kubernetes/clusters/kops/fargate/task-definition.json

#######################
# Register Fargate task definition
#######################
TASK_DEFINITION_REVISION=$(aws ecs register-task-definition --cli-input-json file://${PWD}/containers/kubernetes/clusters/kops/fargate/task-definition.json | jq -r .taskDefinition.revision)

echo "TASK_DEFINITION_REVISION: ${TASK_DEFINITION_REVISION}"