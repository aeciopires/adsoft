#!/bin/bash

#------------------------------------------------------------
# Default function to general use
# Do nothing. Just define functions.
# Load with ". ./lib.sh"
#------------------------------------------------------------


#------------------------------------------------------
#------------------------------------------------------
# Shared variables
#------------------------------------------------------
#------------------------------------------------------


#####
# COLORS
#####
readonly        BLACK=$'\033[0;30m'
readonly  LIGHT_BLACK=$'\033[1;30m'
readonly          RED=$'\033[1;31m'
readonly    LIGHT_RED=$'\033[1;31m'
readonly        GREEN=$'\033[1;32m'
readonly  LIGHT_GREEN=$'\033[1;32m'
readonly       YELLOW=$'\033[1;33m'
readonly LIGHT_YELLOW=$'\033[1;33m'
readonly         BLUE=$'\033[0;34m'
readonly   LIGHT_BLUE=$'\033[0;34m'
readonly       PURPLE=$'\033[0;35m'
readonly LIGHT_PURPLE=$'\033[1;35m'
readonly         CYAN=$'\033[0;36m'
readonly   LIGHT_CYAN=$'\033[1;36m'
readonly        WHITE=$'\033[0;37m'
readonly  LIGHT_WHITE=$'\033[1;37m'
readonly          OFF=$'\033[0m'

#------------------------ END-VARIABLES ------------------------



#------------------------------------------------------
#------------------------------------------------------
# Generic Functions
#------------------------------------------------------
#------------------------------------------------------



#--------------------------------------------------------
# comment: Retries a command on failure.
#
# sintax:
# retry number_attempts command
#
# Example:
# retry 5 ls -ltr foo
#
# Reference: http://fahdshariff.blogspot.com/2014/02/retrying-commands-in-shell-scripts.html
#
function retry() {

  # Creates a read-only local variable of integer type
  local -r -i max_attempts="$1"; shift
  # Create a read-only local variable
  local -r command="$@"
  # Create a local variable of integer type
  local -i attempt_num=1
  local -i time_seconds=30


  until $command; do
    if (( attempt_num == max_attempts )); then
      echo "[ERROR] Attempt $attempt_num failed and there are no more attempts left!"
      return 1
    else
      echo "[WARNING] Attempt $attempt_num failed! Trying again in $time_seconds seconds..."
      sleep $time_seconds
    fi
  done
}


#------------------------------------------------------------
# comment: Check if the file exists.
# usage:
#   checkFile FILE
# return: 0 is exists or error if not exists
#
function checkFile() {

  for file in "$@" ; do
    [ ! -f "$file" ] && {
      echo "[ERROR] File '$file' not found."
      exit 4
    }
  done
}


#------------------------------------------------------------
# comment: Check if the directory exists.
# usage:
#   checkDir DIR
# return: 0 is exists or error if not exists
#
function checkDir() {

  #####
  # Function variables
  #####
  local dir="$1"

  if [ -d "$dir" ]; then
    return 0
  else
    echo "[ERROR] Directory '$dir' not found."
    exit 4
  fi
}


#------------------------------------------------------------
# comment: Checks if file has size greater than 0.
# usage:
#   checkFileEmpty FILE
# return: 0 is not empty or error if empty
#
function checkFileEmpty() {

  for file in "$@" ; do
    [ ! -s "$file" ] && {
      echo "[ERROR] File '$file' is empty."
      exit 4
    }
  done
}


#--------------------------------------------------------
# comment: Check if exists command
# usage:
#   checkCommand command1 command2 command3
# return: 0 is correct or error if not exists
#
# Example:
# checkCommand git kubectl helm
#
function checkCommand() {

  #####
  # Function variables
  #####
  local commands="$@"

  for command in $commands ; do
    if ! type "$command" > /dev/null 2>&1; then
      echo "[ERROR] Command '$command' not found."
      exit 4
    fi
  done
}



#------------------------------------------------------------
# comment: Check if file existis. 
# syntax: existfiles file [file ...]
#
existfiles(){

  # echo --
  # echo FILES=$@
  OK=YES
  for file in "$@" ; do
    if [ ! -f "$file" ] ; then
      echo "[ERROR] File '$file' not found."
      OK=NO
      exit 1
    fi
  done
}


#------------------------------------------------------------
# comment: Check if a variable is empty. 
#          This function works with array, numbers, boolean and strings
# usage:
#   checkVariable variable_name value
# return: 0 is correct or error if empty
#
# Example:
# checkVariable variable_name value
#
function checkVariable() {

  #####
  # Function variables
  #####
  local variable_name="$1";
  shift # will remove first arg from the "$@"
  local value=("$@");
  local debug="${DEBUG}"

  if [ -z "${value[*]}" ] ; then
    echo "[ERROR] The variable $variable_name is empty."
    # The function usage must create in script main
    usage
    exit 3
  else
    if [ "$debug" == true ]; then
      echo "[DEBUG] VARIABLE='$variable_name', VALUE='${value[*]}'."
    fi
  fi
}


#--------------------------------------------------------
# comment: Print error messages in red
#
# Reference: https://nick3499.medium.com/bash-echo-text-color-background-color-e8d8c41d5a91
#
# sintax:
# printRedMessage message
#
# Example:
# printRedMessage "Error Example"
#
function printRedMessage() {

  local message="$1";

  echo -e "\e[1;41m$message\e[0m"
}


#----------------------------------------------------
# comment: Converts lowercase letters to uppercase
# usage:
#   AUX=$(toupper $STRING)
# return: $AUX containing the uppercase string
#
function toupper() {

  tr '[a-z]' '[A-Z]' <<< $*
}


#----------------------------------------------------
# comment: Converts uppercase letters to lowercase
# usage:
#   AUX=$(tolower $STRING)
# return: $AUX containing the lower case string
#
function tolower() {

  echo $* | tr '[A-Z]' '[a-z]'
}



#----------------------------------------------------
# comment: Create a lock content in AWS-S3 bucket
# usage:
#   createLockBucketS3 "$aws_account" "$aws_region" "$s3_bucket" "$lock_key" "$lock_string_content"
#
function createLockBucketS3() {

  #####
  # Function variables
  #####
  local aws_account="$1"
  local aws_region="$2"
  local s3_bucket="$3"
  local lock_key="$4"
  local lock_string_content="$5"
  local temp_file=$(mktemp)

  # Checking if variable is empty
  checkVariable aws_account "$aws_account"
  checkVariable aws_region "$aws_region"
  checkVariable s3_bucket "$s3_bucket"
  checkVariable lock_key "$lock_key"
  checkVariable lock_string_content "$lock_string_content"

  # Check AWS access
  checkAWSAccess "$aws_account"

  echo "[INFO] Creating lock in AWS_S3_BUCKET='$s3_bucket', FILE='$lock_key', AWS_REGION='$aws_region', AWS_ACCOUNT='$aws_account'..."

  echo "$lock_string_content" > "$temp_file"
  aws s3api put-object --profile "$aws_account" --region "$aws_region" --bucket "$s3_bucket" --key "$lock_key" --body "$temp_file"
}


#----------------------------------------------------
# comment: Remove a lock content in AWS-S3 bucket
# usage:
#   removeLockBucketS3 "$aws_account" "$aws_region" "$s3_bucket" "$lock_key"
#
function removeLockBucketS3() {

  #####
  # Function variables
  #####
  local aws_account="$1"
  local aws_region="$2"
  local s3_bucket="$3"
  local lock_key="$4"

  # Checking if variable is empty
  checkVariable aws_account "$aws_account"
  checkVariable aws_region "$aws_region"
  checkVariable s3_bucket "$s3_bucket"
  checkVariable lock_key "$lock_key"

  # Check AWS access
  checkAWSAccess "$aws_account"

  echo "[INFO] Removing lock in AWS_S3_BUCKET='$s3_bucket', FILE='$lock_key', AWS_REGION='$aws_region', AWS_ACCOUNT='$aws_account'..."
  aws s3api delete-object --profile "$aws_account" --region "$aws_region" --bucket "$s3_bucket" --key "$lock_key"
}


#----------------------------------------------------
# comment: List lock files in AWS-S3 bucket
# usage:
#   listLockBucketS3 "$aws_account" "$aws_region" "$s3_bucket" "$lock_key"
#
function listLockBucketS3() {

  #####
  # Function variables
  #####
  local aws_account="$1"
  local aws_region="$2"
  local s3_bucket="$3"
  local lock_key="$4"

  # Checking if variable is empty
  checkVariable aws_account "$aws_account"
  checkVariable aws_region "$aws_region"
  checkVariable s3_bucket "$s3_bucket"
  checkVariable lock_key "$lock_key"

  # Check AWS access
  checkAWSAccess "$aws_account"

  echo "[INFO] Listing lock in AWS_S3_BUCKET='$s3_bucket', FILE='$lock_key', AWS_REGION='$aws_region', AWS_ACCOUNT='$aws_account'..."

  string_lock=$(aws s3 cp --profile "$aws_account" --region "$aws_region" "s3://${s3_bucket}/${lock_key}" - | head)
  echo "[WARNING] Cluster in use: $string_lock."
  echo "Other script, pipeline, job or process is updating this cluster."
  echo "Please wait some minutes. Take a coffe, coke, juice, beer, tea or other drink!!! Cheers :-) :-D ;-) :-P \o/"
}


#----------------------------------------------------
# comment: Validating lock in AWS-S3 bucket
# usage:
#   validateLockBucketS3 "$aws_account" "$aws_region" "$s3_bucket" "$lock_key" "$lock_string_content"
#
function validateLockBucketS3() {

  #####
  # Function variables
  #####
  local aws_account="$1"
  local aws_region="$2"
  local s3_bucket="$3"
  local lock_key="$4"
  local lock_string_content="$5"
  local lock_max_time=$6

  # Checking if variable is empty
  checkVariable aws_account "$aws_account"
  checkVariable aws_region "$aws_region"
  checkVariable s3_bucket "$s3_bucket"
  checkVariable lock_key "$lock_key"
  checkVariable lock_string_content "$lock_string_content"
  checkVariable lock_max_time "$lock_max_time"

  # Check AWS access
  checkAWSAccess "$aws_account"

  echo "[INFO] Valitating lock in AWS_S3_BUCKET='$s3_bucket', FILE='$lock_key', AWS_REGION='$aws_region', AWS_ACCOUNT='$aws_account'..."

  # Check if the file exists on S3
  if aws s3api head-object --profile "$aws_account" --region "$aws_region" --bucket "$s3_bucket" --key "$lock_key" 2>/dev/null; then
    # Gets the last modified date of the file
    local last_modification=$(aws s3api head-object --profile "$aws_account" --region "$aws_region" --bucket "$s3_bucket" --key "$lock_key" --query "LastModified" --output text)

    # Calculates the time elapsed since the last modification
    local elapsed_time=$(( $(date +%s) - $(date -d "$last_modification" +%s) ))

    # Verifica se o tempo decorrido é menor que o tempo máximo permitido
    if [ "$elapsed_time" -le "$lock_max_time" ]; then
      difference_time=$(echo "$lock_max_time" - "$elapsed_time" | bc)
      echo "[ERROR] The lock still is valid. Check again after $difference_time seconds."
      listLockBucketS3 "$aws_account" "$aws_region" "$s3_bucket" "$lock_key"
      exit 9
    else
      echo "[WARNING] The lock expired."
      echo "[INFO] Trying to acquire lock in AWS_S3_BUCKET='$LOCK_S3_BUCKET', FILE='$LOCK_KEY_FILE', AWS_REGION='$LOCK_S3_REGION', AWS_ACCOUNT='$LOCK_AWS_S3_ACCOUNT'..."
      createLockBucketS3 "$aws_account" "$aws_region" "$s3_bucket" "$lock_key" "$lock_string_content"
    fi
  else
    echo "[WARNING] The lock not exists."
    echo "[INFO] Trying to acquire lock in AWS_S3_BUCKET='$LOCK_S3_BUCKET', FILE='$LOCK_KEY_FILE', AWS_REGION='$LOCK_S3_REGION', AWS_ACCOUNT='$LOCK_AWS_S3_ACCOUNT'..."
    createLockBucketS3 "$aws_account" "$aws_region" "$s3_bucket" "$lock_key" "$lock_string_content"
  fi
}


#--------------------------------------------------------
# comment: Verify that your AWS credentials are valid for one or more AWS accounts
# usage:
#   checkAWSAccess AWSAccount1 AWSAccount2 AWSAccount3
# return: 0 is correct or error if does not have access
#
# Example:
# checkAWSAccess myAWSAccount
#
# Reference: https://stackoverflow.com/questions/31836816/how-to-test-credentials-for-aws-command-line-tools
#
function checkAWSAccess() {

  #####
  # Function variables
  #####
  local accounts=("$@")

  for account in "${accounts[@]}" ; do
    if ! aws sts get-caller-identity --profile "$account" > /dev/null 2>&1; then
      echo "[ERROR] You not have access to AWS account '$account'. Check your AWS credentials."
      exit 255
    fi
  done
}


#--------------------------------------------------------
# comment: Verify that your GCP credentials are valid for one or more GCP project and can access GKE
# usage:
#   checkGKEAccess GCPproject1 GCPproject2 GCPproject3
# return: 0 is correct or error if does not have access
#
# Example:
# checkGKEAccess myGCPproject
#
function checkGKEAccess() {

  #####
  # Function variables
  #####
  local projects=("$@")

  for project in "${projects[@]}" ; do
    if ! gcloud projects get-iam-policy "$project" --flatten="bindings[].members" --format="table(bindings.role,bindings.members)" | grep container > /dev/null 2>&1; then
      echo "[ERROR] You not have access to GKE in GCP project '$project'. Check your GCP credentials and GKE permissions."
      exit 255
    fi
  done
}


#------------------------------------------------------------
# comment: Execute the command and show in output (use for debug of commands)
# usage:
#   debug COMMAND
# requirement: create variable _DEBUG_COMMAND.
#    Use the value 'on' for enable this funcion.
#    Use the value 'off' for disable this function
# reference: https://www.cyberciti.biz/tips/debugging-shell-script.html
#
# how_to:
#
# Example 1:
# debug echo "File is $filename"
#
# Example 2:
# debug set -x
# Cmd1
# Cmd2
# debug set +x
function debug() {
  [ "$_DEBUG_COMMAND" == "on" ] && "$@"
}


#--------------------------------------------------------
# comment: Get current context in Kubernetes cluster
# usage:
#   k8sGetCurrentContext
# return: k8s_context
#
function k8sGetCurrentContext() {

  #####
  # Function variables
  #####
  local k8s_context

  k8s_context=$(kubectl config current-context)
  echo "$k8s_context"
}


#--------------------------------------------------------
# comment: Unset current context in Kubernetes cluster
# usage:
#   k8sUnsetCurrentContext
#
function k8sUnsetCurrentContext() {

  #####
  # Function variables
  #####
  local context

  context=$(k8sGetCurrentContext)
  echo "[INFO] Disconnecting from '$context' cluster"
  kubectl config unset current-context
}


#--------------------------------------------------------
# comment: Test access to Kubernetes cluster
# usage:
#   testAccessKubernetes
# return: 0 is correct or error if does not have access
#
# Reference: https://github.com/judexzhu/Jenkins-Pipeline-CI-CD-with-Helm-on-Kubernetes/blob/master/Jenkinsfile
#
function testAccessKubernetes() {

  #####
  # Function variables
  #####
  local cluster_name
  local result_code

  echo "Testing access a Kubernetes cluster..."
  kubectl cluster-info > /dev/null 2>&1
  result_code=$?

  if [ "$result_code" -eq 0 ] ; then
    cluster_name=$(k8sGetCurrentContext)
    echo "[OK] CLUSTER_NAME=$cluster_name"
  else
    echo "[ERROR] Failed to access a Kubernetes cluster. Make sure to connect to a cluster before running the script."
    exit 254
  fi

  return 0
}


#--------------------------------------------------------
# comment: Check Kubernetes version
# usage:
#   checkK8sVersion "${KUBERNETES_VERSION_SUPPORTED[@]}"
# return: 0 is correct or 1 is incorrect
#
function checkK8sVersion() {

  #####
  # Function variables
  #####
  local versions_supported=("$@")
  local debug="${DEBUG}"

  echo "[INFO] Check Kubernetes version..."
  cluster_version=$(kubectl version --short 2> /dev/null | grep Server | cut -d":" -f2 | cut -d " " -f2)

  if [ "$debug" == true ]; then
    echo "[DEBUG] KUBERNETES_VERSION_SUPPORTED: ${versions_supported[*]}"
  fi

  for substring in "${versions_supported[@]}"; do
    if [[ "$cluster_version" == *"${substring}"* ]]; then
      echo "[OK] Kubernetes version $cluster_version is supported!"
      return 0
    else
      echo "[WARNING] Kubernetes version $cluster_version is not compatible with '$substring'! Use Kubernetes ${versions_supported[*]}"
    fi
  done

  echo "[ERROR] Kubernetes version $cluster_version is not supported! Use Kubernetes ${versions_supported[*]}"
  exit 7
}


#--------------------------------------------------------
# comment: Create namespace if not exists
# usage:
#   createNameSpace NAMESPACE
# return: 0 is correct or error if can not create
#
# Reference: https://github.com/eldada/jenkins-pipeline-kubernetes/blob/master/Jenkinsfile
#
function createNameSpace() {

  #####
  # Function variables
  #####
  local namespace="$1"

  ns_aux=$(kubectl get namespace "$namespace" --no-headers -o custom-columns=":metadata.name" 2> /dev/null)

  if [ -z "${ns_aux}" ]; then
    kubectl create namespace "$namespace"
    ns_aux2=$(kubectl get namespace "$namespace" --no-headers -o custom-columns=":metadata.name" 2> /dev/null)

    if [ -z "${ns_aux2}" ]; then
      echo "[ERROR] Problem to create namespace '$namespace'."
      exit 7
    fi
  else
    echo "[INFO] Namespace '$namespace' exists."
  fi

  local result_code=$?

  return $result_code
}


#--------------------------------------------------------
# comment: Check if namespace is terminating
# sintax:
#   checkNameSpaceTerminating NAMESPACE
# return: 0 - namespace doesn't exists or is in another status
# return: 3 - namespace is in terminating status
#
function checkNameSpaceTerminating() {
  #####
  # Function variables
  #####
  local namespace="$1"

  ns_status=$(kubectl get namespace "$namespace" --no-headers -o custom-columns=":status.phase" 2> /dev/null)

  if [ "${ns_status}" == "Terminating" ]; then
    echo "[ERROR] Namespace '$namespace' still terminating, please wait or kill it."
    echo "Please, read the tutorial: https://stackoverflow.com/questions/52369247/namespace-stuck-as-terminating-how-i-removed-it/62421957#62421957"
    exit 3
  fi
}



#--------------------------------------------------------
# comment: Recreate namespace
# usage:
#   recreateNameSpace NAMESPACE
# return: 0 is correct or error if can not recreate
#
function recreateNameSpace() {

  #####
  # Function variables
  #####
  local namespace="$1"

  echo "[INFO] Removing namespace '$namespace', if exists"
  kubectl delete namespace "$namespace" --timeout=3m 2> /dev/null
  
  checkNameSpaceTerminating "$namespace"
  
  echo "[INFO] Creating namespace $namespace"
  createNameSpace "$namespace"
}


#------------------------------------------------------------
# comment: Only show all input in output (use for mock tests)
# usage:
#   mock "TEXT or COMMAND"
function mock() {
  echo "$@"
}
