#!/bin/bash -e

# create_kops - A script to create a Kops Kubernetes cluster

##########################################
##### Constants
##########################################

TIME_NOW=$(date +"%x %r %Z")
KOPS_VERSION="1.11."

##########################################
##### Functions
##########################################

usage()
{
    echo "usage: create_kops [[[-n kops_name ] ] | [-h]]"
}

check_kops_version()
{
  command=$(kops version)

  if [[ "${command}" == *"${KOPS_VERSION}"* ]]; then
    echo "[INFO] Kops version: ${command}"
  else
    echo "[ERROR] Kops version expected: ${KOPS_VERSION}"
    echo "Got: ${command}"
    exit 1
  fi
}

create()
{
  # Checks
  VALUES_FILE_PATH="./clusters/${kops_name}/values.yaml"
  TEMPLATE_FILE_PATH="./template/cluster.yml"

  if [ ! -f ${VALUES_FILE_PATH} ]; then
    echo "File does not exist: ${VALUES_FILE_PATH}"
    exit 1
  fi

  if [ ! -f ${TEMPLATE_FILE_PATH} ]; then
    echo "File does not exist: ${TEMPLATE_FILE_PATH}"
    exit 1
  fi

  kops_state_store=s3://$(cat ${VALUES_FILE_PATH} | grep "s3BucketName: " | awk '{print $2}' | tr -d '[:space:]')
  export KOPS_STATE_STORE=${kops_state_store}
  echo "[INFO] Setting KOPS_STATE_STORE: ${kops_state_store}"

  if [ "${dry_run}" == "false" ]; then
    echo "[INFO] Not a dry run"
    echo "[INFO] Templating out"
    kops toolbox template --template ${TEMPLATE_FILE_PATH} --values ${VALUES_FILE_PATH} > ./kops-templated-${kops_name}.yaml
    cat kops-templated-${kops_name}.yaml

    echo "[INFO] Creating the cluster"
    kops create -f ./kops-templated-${kops_name}.yaml

    dns_zone=$(cat ${VALUES_FILE_PATH} | grep "dnsZone: " | awk '{print $2}' | tr -d '[:space:]')
    cluster_name=$(cat ${VALUES_FILE_PATH} | grep "kopsName: " | awk '{print $2}' | tr -d '[:space:]').${dns_zone}

    yes y | ssh-keygen -t rsa -b 4096 -C "kops@kops.com" -f ./ssh-keys/id_rsa_kops_script -q -N "" >/dev/null

    echo "[INFO] Setting to generic ssh pub key"
    kops create secret --name ${cluster_name} sshpublickey admin -i ./ssh-keys/id_rsa_kops_script.pub

    echo "[INFO] Applying cluster to AWS"
    kops --name ${cluster_name} update cluster --yes

    echo "[INFO] Get clusters"
    kops --name ${cluster_name} get clusters

    echo "[INFO] Get instance groups"
    kops --name ${cluster_name} get ig

  else
    echo "[INFO] Dry run"
    kops toolbox template --template ${TEMPLATE_FILE_PATH} --values ${VALUES_FILE_PATH}
  fi

  echo "Finished"

}

read()
{
  # Checks
  VALUES_FILE_PATH="./clusters/${kops_name}/values.yaml"
  TEMPLATE_FILE_PATH="./template/cluster.yml"

  if [ ! -f ${VALUES_FILE_PATH} ]; then
    echo "File does not exist: ${VALUES_FILE_PATH}"
    exit 1
  fi

  if [ ! -f ${TEMPLATE_FILE_PATH} ]; then
    echo "File does not exist: ${TEMPLATE_FILE_PATH}"
    exit 1
  fi

  kops_state_store=s3://$(cat ${VALUES_FILE_PATH} | grep "s3BucketName: " | awk '{print $2}' | tr -d '[:space:]')
  export KOPS_STATE_STORE=${kops_state_store}
  echo "[INFO] Setting KOPS_STATE_STORE: ${kops_state_store}"

  dns_zone=$(cat ${VALUES_FILE_PATH} | grep "dnsZone: " | awk '{print $2}' | tr -d '[:space:]')
  cluster_name=$(cat ${VALUES_FILE_PATH} | grep "kopsName: " | awk '{print $2}' | tr -d '[:space:]').${dns_zone}

  echo "[INFO] Get clusters"
  kops --name ${cluster_name} get cluster

  echo "[INFO] Get instance groups"
  kops --name ${cluster_name} get ig
}

template()
{
  # Checks
  VALUES_FILE_PATH="./clusters/${kops_name}/values.yaml"
  TEMPLATE_FILE_PATH="./template/cluster.yml"

  if [ ! -f ${VALUES_FILE_PATH} ]; then
    echo "File does not exist: ${VALUES_FILE_PATH}"
    exit 1
  fi

  if [ ! -f ${TEMPLATE_FILE_PATH} ]; then
    echo "File does not exist: ${TEMPLATE_FILE_PATH}"
    exit 1
  fi

  kops_state_store=s3://$(cat ${VALUES_FILE_PATH} | grep "s3BucketName: " | awk '{print $2}' | tr -d '[:space:]')
  export KOPS_STATE_STORE=${kops_state_store}
  echo "[INFO] Setting KOPS_STATE_STORE: ${kops_state_store}"

  echo "[INFO] Dry run"
  kops toolbox template --template ${TEMPLATE_FILE_PATH} --values ${VALUES_FILE_PATH}

  echo "Finished"
}

update()
{
  # cluster_name=$(kops get clusters | grep "^${kops_name}\." | awk '{print $1}')
  # echo "[INFO] Updating cluster named: ${cluster_name}"

  # Checks
  VALUES_FILE_PATH="./clusters/${kops_name}/values.yaml"
  TEMPLATE_FILE_PATH="./template/cluster.yml"

  if [ ! -f ${VALUES_FILE_PATH} ]; then
    echo "File does not exist: ${VALUES_FILE_PATH}"
    exit 1
  fi

  if [ ! -f ${TEMPLATE_FILE_PATH} ]; then
    echo "File does not exist: ${TEMPLATE_FILE_PATH}"
    exit 1
  fi

  kops_state_store=s3://$(cat ${VALUES_FILE_PATH} | grep "s3BucketName: " | awk '{print $2}' | tr -d '[:space:]')
  export KOPS_STATE_STORE=${kops_state_store}
  echo "[INFO] Setting KOPS_STATE_STORE: ${kops_state_store}"

  if [ "${dry_run}" == "false" ]; then
    echo "[INFO] Not a dry run"
    echo "[INFO] Templating out"
    kops toolbox template --template ${TEMPLATE_FILE_PATH} --values ${VALUES_FILE_PATH} > ./kops-templated-${kops_name}.yaml
    cat kops-templated-${kops_name}.yaml

    dns_zone=$(cat ${VALUES_FILE_PATH} | grep "dnsZone: " | awk '{print $2}' | tr -d '[:space:]')
    cluster_name=$(cat ${VALUES_FILE_PATH} | grep "kopsName: " | awk '{print $2}' | tr -d '[:space:]').${dns_zone}
    echo "[INFO] Updating cluster named: ${cluster_name}"

    echo "[INFO] Updating the cluster"
    #--force is required so that any resources (ie new instance groups) are created;
    # without this flag the call fails with a resource DNE error
    kops --name ${cluster_name} replace -f ./kops-templated-${kops_name}.yaml --force

    echo "[INFO] Applying cluster to AWS"
    kops --name ${cluster_name} update cluster --yes

    echo "[INFO] Cluster instance groups:"
    kops --name ${cluster_name} get ig

  else
    echo "[INFO] Dry run"
    echo "[INFO] Templating out"
    kops toolbox template --template ${TEMPLATE_FILE_PATH} --values ${VALUES_FILE_PATH} > ./kops-templated-${kops_name}.yaml
    cat kops-templated-${kops_name}.yaml

    dns_zone=$(cat ${VALUES_FILE_PATH} | grep "dnsZone: " | awk '{print $2}' | tr -d '[:space:]')
    cluster_name=$(cat ${VALUES_FILE_PATH} | grep "kopsName: " | awk '{print $2}' | tr -d '[:space:]').${dns_zone}
    echo "[INFO] Updating cluster named: ${cluster_name}"

    echo "[INFO] Updating the cluster"
    #--force is required so that any resources (ie new instance groups) are created;
    # without this flag the call fails with a resource DNE error
    kops --name ${cluster_name} replace -f ./kops-templated-${kops_name}.yaml --force

    echo "[INFO] Applying cluster to AWS"
    kops --name ${cluster_name} update cluster

    echo "[INFO] Cluster instance groups:"
    kops --name ${cluster_name} get ig
  fi

  echo "Finished"
}

rolling_update()
{
  # Checks
  VALUES_FILE_PATH="./clusters/${kops_name}/values.yaml"
  TEMPLATE_FILE_PATH="./template/cluster.yml"

  if [ ! -f ${VALUES_FILE_PATH} ]; then
    echo "File does not exist: ${VALUES_FILE_PATH}"
    exit 1
  fi

  if [ ! -f ${TEMPLATE_FILE_PATH} ]; then
    echo "File does not exist: ${TEMPLATE_FILE_PATH}"
    exit 1
  fi

  kops_state_store=s3://$(cat ${VALUES_FILE_PATH} | grep "s3BucketName: " | awk '{print $2}' | tr -d '[:space:]')
  export KOPS_STATE_STORE=${kops_state_store}
  echo "[INFO] Setting KOPS_STATE_STORE: ${kops_state_store}"

  USE_CLOUD_ONLY_FLAG=""
  if [ "${cloudonly}" == "true" ]; then
    echo "[INFO] Using --cloudonly flag.  This will not drain the nodes first.  It will simply terminate the nodes."
    USE_CLOUD_ONLY_FLAG="--cloudonly"
  fi

  if [ "${dry_run}" == "false" ]; then
    echo "[INFO] Not a dry run"

    dns_zone=$(cat ${VALUES_FILE_PATH} | grep "dnsZone: " | awk '{print $2}' | tr -d '[:space:]')
    cluster_name=$(cat ${VALUES_FILE_PATH} | grep "kopsName: " | awk '{print $2}' | tr -d '[:space:]').${dns_zone}
    echo "[INFO] Rolling cluster named: ${cluster_name}"

    kops --name ${cluster_name} rolling-update cluster --yes ${USE_CLOUD_ONLY_FLAG}

    echo "[INFO] rolling-update cluster:"
    kops --name ${cluster_name} rolling-update cluster ${USE_CLOUD_ONLY_FLAG}

  else
    echo "[INFO] Dry run"

    dns_zone=$(cat ${VALUES_FILE_PATH} | grep "dnsZone: " | awk '{print $2}' | tr -d '[:space:]')
    cluster_name=$(cat ${VALUES_FILE_PATH} | grep "kopsName: " | awk '{print $2}' | tr -d '[:space:]').${dns_zone}
    echo "[INFO] Rolling cluster named: ${cluster_name}"

    kops --name ${cluster_name} rolling-update cluster ${USE_CLOUD_ONLY_FLAG}

    echo "[INFO] rolling-update cluster:"
    kops --name ${cluster_name} rolling-update cluster ${USE_CLOUD_ONLY_FLAG}
  fi

  echo "Finished"
}

delete()
{
  # Checks
  VALUES_FILE_PATH="./clusters/${kops_name}/values.yaml"
  TEMPLATE_FILE_PATH="./template/cluster.yml"

  if [ ! -f ${VALUES_FILE_PATH} ]; then
    echo "File does not exist: ${VALUES_FILE_PATH}"
    exit 1
  fi

  if [ ! -f ${TEMPLATE_FILE_PATH} ]; then
    echo "File does not exist: ${TEMPLATE_FILE_PATH}"
    exit 1
  fi

  kops_state_store=s3://$(cat ${VALUES_FILE_PATH} | grep "s3BucketName: " | awk '{print $2}' | tr -d '[:space:]')
  export KOPS_STATE_STORE=${kops_state_store}
  echo "[INFO] Setting KOPS_STATE_STORE: ${kops_state_store}"

  dns_zone=$(cat ${VALUES_FILE_PATH} | grep "dnsZone: " | awk '{print $2}' | tr -d '[:space:]')
  cluster_name=$(cat ${VALUES_FILE_PATH} | grep "kopsName: " | awk '{print $2}' | tr -d '[:space:]').${dns_zone}
  echo "[INFO] Deleting cluster named: ${cluster_name}"

  if [ "${dry_run}" == "false" ]; then
    echo "[INFO] Not a dry run"

    kops --name ${cluster_name} delete cluster --yes

  else
    echo "[INFO] Dry run"
    kops --name ${cluster_name} delete cluster
  fi
}

get_bastion()
{
  # Checks
  VALUES_FILE_PATH="./clusters/${kops_name}/values.yaml"
  TEMPLATE_FILE_PATH="./template/cluster.yml"

  if [ ! -f ${VALUES_FILE_PATH} ]; then
    echo "File does not exist: ${VALUES_FILE_PATH}"
    exit 1
  fi

  if [ ! -f ${TEMPLATE_FILE_PATH} ]; then
    echo "File does not exist: ${TEMPLATE_FILE_PATH}"
    exit 1
  fi

  kops_state_store=s3://$(cat ${VALUES_FILE_PATH} | grep "s3BucketName: " | awk '{print $2}' | tr -d '[:space:]')
  export KOPS_STATE_STORE=${kops_state_store}
  echo "[INFO] Setting KOPS_STATE_STORE: ${kops_state_store}"

  dns_zone=$(cat ${VALUES_FILE_PATH} | grep "dnsZone: " | awk '{print $2}' | tr -d '[:space:]')
  cluster_name=$(cat ${VALUES_FILE_PATH} | grep "kopsName: " | awk '{print $2}' | tr -d '[:space:]')
  region=$(cat ${VALUES_FILE_PATH} | grep "awsRegion: " | awk '{print $2}' | tr -d '[:space:]')
  network_cidr=$(cat ${VALUES_FILE_PATH} | grep "networkCIDR: " | awk '{print $2}' | tr -d '[:space:]')

  echo "[INFO] Getting bastion host for cluster named: ${cluster_name}"

  # Get the ELB DNS name
  bastion_dns_name=$(jq -r ".LoadBalancerDescriptions[] | .DNSName" ~/Downloads/describe-load-balancers.json | grep "bastion-${kops_name}-${region}")

  # Get the Kubernetes API server out of the kubeconfig file
  kubernetes_api_server=$(kubectl config view --minify | grep server | cut -f 2- -d ":" | tr -d " " | grep -oP "internal.*")

  echo "[INFO] bastion_dns_name: ${bastion_dns_name}"
  echo "[INFO] Add ssh keys into your ssh-agent: ssh-add ./ssh-keys/kubernetes-ops.pem"
  # echo "[INFO] run: sudo ssh -i ./ssh-keys/kubernetes-ops.pem -L 443:${kubernetes_api_server}:443 ec2-user@${bastion_dns_name}"
  echo "[INFO] sshuttle command: sshuttle -r ec2-user@${bastion_dns_name} ${network_cidr} -v"
  echo "[INFO] In another terminal run: kubectl get nodes"

}


##########################################
##### Main
##########################################

kops_name="none"
dry_run="true"
create="false"
read="false"
get_bastion="false"
update="false"
delete="false"
rolling_update="false"
cloudonly="false"

while [ "$1" != "" ]; do
    case $1 in
        -n | --name )           shift
                                kops_name=$1
                                ;;
        -d | --dry-run )        shift
                                dry_run=$1
                                ;;
        -c | --create )        shift
                                create=true
                                ;;
        -r | --read )        shift
                                read=true
                                ;;
        -u | --update )        shift
                                update=true
                                ;;
        -ru | --rolling-update )        shift
                                        rolling_update=true
                                        ;;
        -co | --cloudonly )             shift
                                        cloudonly=true
                                        ;;
        -t | --template )       shift
                                template=true
                                ;;
        -x | --delete )        shift
                                delete=true
                                ;;
        -b | --get-bastion )    shift
                                get_bastion=true
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

echo "[INFO] dry_run = ${dry_run}"
echo "[INFO] kops_name = $kops_name"

check_kops_version

if [ "${create}" == "true" ]; then
  create $kops_name
fi

if [ "${read}" == "true" ]; then
  read $kops_name
fi

if [ "${update}" == "true" ]; then
  update $kops_name
fi

if [ "${rolling_update}" == "true" ]; then
  rolling_update $kops_name
fi

if [ "${template}" == "true" ]; then
  template $kops_name
fi

if [ "${delete}" == "true" ]; then
  delete $kops_name
fi

if [ "${get_bastion}" == "true" ]; then
  get_bastion $kops_name
fi
