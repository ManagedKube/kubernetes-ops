#!/bin/bash -e

###################################################
##
## This script run inside of the Fargate Docker container.
##
## Need to rebuild the upgrade-pipeline-container Docker container on edit: true
##
###################################################

echo "###################################################"
echo "running: update-cluster-run.sh"
echo "###################################################"

if [ ! -z "${DEBUG}" ]; then
  set -x
fi

usage()
{
    echo "usage: TBD"
}

# Parse inputs
while [ "$1" != "" ]; do
    case $1 in
        -i | --initial-branch )           shift
                                INITIAL_BRANCH=$1
                                ;;
        -u | --updated-to-branch )        shift
                                UPDATE_TO_BRANCH=$1
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

# Check input params
if [ -z "${INITIAL_BRANCH}" ]; then
  echo "The --initial-branch param must be set"
  exit 1
fi

if [ -z "${UPDATE_TO_BRANCH}" ]; then
  echo "The --updated-to-branch param must be set"
  exit 1
fi


# Clone out the repository
echo "Cloning out source repository..."
git clone ${GIT_URL_WITH_DEPLOY_KEY} /opt/repo
cd repo

# Run the ci-pipeline.sh
./containers/kubernetes/clusters/kops/ci-pipeline.sh --initial-branch ${INITIAL_BRANCH} --updated-to-branch ${UPDATE_TO_BRANCH}
