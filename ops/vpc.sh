#!/bin/bash -e

# create_vpc - A script to create a VPC

##########################################
##### Constants
##########################################

TIME_NOW=$(date +"%x %r %Z")

TERRAFORM_VERSION="v0.11."
TERRAGRUNT_VERSION="v0.18."

##########################################
##### Functions
##########################################

usage()
{
    echo "usage: create_vpc [[[-n vpc_name ] ] | [-h]]"
}

check_terraform_version()
{
  command=$(terraform --version)

  if [[ "${command}" == *"${TERRAFORM_VERSION}"* ]]; then
    echo "[INFO] Terraform version: ${command}"
  else
    echo "[ERROR] Terraform version expected: ${TERRAFORM_VERSION}"
    echo "Got: ${command}"
    exit 1
  fi
}

check_terragrunt_version()
{
  command=$(terragrunt --version)

  if [[ "${command}" == *"${TERRAGRUNT_VERSION}"* ]]; then
    echo "[INFO] Terragrunt version: ${command}"
  else
    echo "[ERROR] Terragrunt version expected: ${TERRAGRUNT_VERSION}"
    echo "Got: ${command}"
    exit 1
  fi
}

create()
{
  # Checks
  if [ ! -f ../tf-environments/$vpc_name/_env_defaults/main.tf ]; then
    echo "File does not exist: ../tf-environments/$vpc_name/_env_defaults/main.tf"
    exit 1
  fi

  if [ ! -f ../tf-environments/$vpc_name/${cloud}/vpc/main.tf ]; then
    echo "File does not exist: ../tf-environments/$vpc_name/${cloud}/vpc/main.tf"
    exit 1
  fi

  echo "[INFO] Adding new VPC named: $vpc_name"

  cd ../tf-environments/$vpc_name/${cloud}/vpc

  terragrunt init
  terragrunt plan

  if [ "${dry_run}" == "false" ]; then
    echo "[INFO] Applying..."
    terragrunt apply -input=false -auto-approve
  fi

  echo "[INFO] Finished"

}

read()
{
  echo "[INFO] Reading vpc named: ${vpc_name}"
}

update()
{
  echo "[INFO] Updating vpc named: ${vpc_name}"
}

delete()
{
  echo "[INFO] Deleting vpc named: ${vpc_name}"

  cd ../tf-environments/$vpc_name/${cloud}/vpc

  if [ "${dry_run}" == "false" ]; then
    echo "[INFO] Not a dry run"

    terragrunt destroy -input=false -auto-approve

  else
    echo "[INFO] Dry run"
    terragrunt destroy
  fi
}




##########################################
##### Main
##########################################

cloud="aws"

vpc_name="none"
dry_run="true"

create="false"
read="false"
update="false"
delete="false"

while [ "$1" != "" ]; do
    case $1 in
        -n | --name )           shift
                                vpc_name=$1
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
        -x | --delete )        shift
                                delete=true
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
echo "[INFO] vpc_name = $vpc_name"

check_terraform_version
check_terragrunt_version

if [ "${create}" == "true" ]; then
  create $vpc_name
fi

if [ "${read}" == "true" ]; then
  read $vpc_name
fi

if [ "${update}" == "true" ]; then
  update $vpc_name
fi

if [ "${delete}" == "true" ]; then
  delete $vpc_name
fi
