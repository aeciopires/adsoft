#!/bin/bash

#------------------------
# Thanks for: Victor Ribeiro, Aecio Pires, André Déo and Camila Paulino
# Date: 13 jan 2020
#
# Objective: Install or upgrade Prometheus Operator in Kubernetes clusters
#
#--------------------- REQUISITES --------------------#

#------------------------


#----------------------------------------
#----------------------------------------
# Local Functions
#----------------------------------------
#----------------------------------------


#--------------------------------------------------------
# comment: Print usage help
# usage: usage
#
function usage() {

cat <<EOF
  Script to install or upgrade Prometheus Operator in Kubernetes clusters

  Usage: $PROGPATHNAME <[options]>
  Options:
      -a, --action          The action name. Supported values: install, upgrade, unistall
      -h, --help            This message.
      -c, --cluster_name    Cluster name. Example: kind-kind-multinodes
      -e, --environment     Environment name. Supported values: testing, staging, production
      -p, --cloud_provider  Cloud provider. Supported values: aws, gcp

  Examples:

  # Install prometheus-operator
  $PROGPATHNAME -a install -p aws -e testing -c myawscluster [--dry-run]"

  # Upgrade prometheus-operator
  $PROGPATHNAME -a upgrade -p gcp -e staging -c mygcpcluster [--dry-run]"

  # Uninstall prometheus-operator
  $PROGPATHNAME -a uninstall -c mygcpcluster [--dry-run]"
EOF
}


#--------------------------------------------------------
# comment: Install/upgrade a helm release of prometheus-operator
# usage: install_prometheus_operator
#
function install_prometheus_operator() {

# Disable create resource CRD
# https://github.com/helm/charts/issues/19452

  helm secrets upgrade --install $APP_NAME \
  $HELM_REPO_NAME/$HELM_CHART_NAME \
  --version $CHART_VERSION \
  --namespace $NAMESPACE \
  $DRY_RUN_HELM_OPTION \
  $DEBUG_DEPLOY \
  $SKIP_CRD \
  -f $DEFAULT_VALUES \
  -f $CLOUD_VALUES \
  -f $CLUSTER_VALUES
}


#--------------------------------------------------------
# comment: Uninstall a helm release of prometheus-operator
# usage: uninstall_prometheus_operator
#
function uninstall_prometheus_operator() {

  helm uninstall $APP_NAME --namespace $NAMESPACE
}


#----------------------------------------
#----------------------------------------
# Main
#----------------------------------------
#----------------------------------------



#------------------------
# Variables
readonly PROGPATHNAME=$(readlink -f $0)
readonly PROGPATHNAME_RELATIVE=$BASH_SOURCE
PROGFILENAME=$(basename $PROGPATHNAME)
PROGDIRNAME=$(dirname $PROGPATHNAME)
LIB_FILE="${PROGDIRNAME}/lib.sh"
DEBUG=true
_DEBUG_COMMAND="on"
_OPTIONS_FOR_USAGE="${@}"
_COUNT_ARGS_FOR_ERROR="${#}"

#--- Version new of chart
#    https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
#    https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack
HELM_REPO_NAME='prometheus-community'
HELM_REPO_URL='https://prometheus-community.github.io/helm-charts'
HELM_CHART_NAME='kube-prometheus-stack'
CHART_VERSION='68.2.1'
APP_NAME='monitor'
NAMESPACE='monitoring'
# Use true to add helm repo always, use false to don't install helm repo
ADD_HELM_REPO=true
HELM_DIR="${PROGDIRNAME}/helm_vars"
# Uncomment next line to disable debug mode during deploy
#DEBUG_DEPLOY=''
# Uncomment next line to enable debug mode during deploy
DEBUG_DEPLOY='--debug'
# Uncomment next line to disable install crd
#SKIP_CRD='--skip-crds'
# Uncomment next line to enable install crd
SKIP_CRD=''
#------------------------


# Load scripts with our libs and variables defaults
if [ ! -f "$LIB_FILE" ] ; then
    echo "[ERROR] File '$LIB_FILE' not found."
    exit 1
else
  if [ -x "$LIB_FILE" ] ; then
    . "$LIB_FILE"
  else
    echo "[ERROR] file '$LIB_FILE' does not have execute permission."
    exit 1
  fi
fi

# Testing if commands exist
checkCommand git kubectl helm sops


#####
# BEGIN getopts
#####
die() { echo "${*}" >&2; exit 2; }  # complain to STDERR and exit with error
needs_arg() { if [[ -z "${OPTARG}" ]]; then die "No arg for --${OPT} option"; fi; }
no_arg() { if [[ -n "${OPTARG}" ]]; then die "No arg allowed for --${OPT} option"; fi; }
help() { usage; die; }

while getopts a:c:e:h:p:-: OPT; do
  # support long options: https://stackoverflow.com/a/28466267/519360
  if [[ "${OPT}" = "-" ]]; then   # long option: reformulate OPT and OPTARG
    OPT="${OPTARG%%=*}"           # extract long option name
    OPTARG="${OPTARG#"${OPT}"}"   # extract long option argument (may be empty)
    OPTARG="${OPTARG#=}"          # if long option argument, remove assigning `=`
  fi
  case "${OPT}" in
    a | action )               needs_arg; ACTION="${OPTARG}" ;;
    c | cluster_name )         needs_arg; CLUSTER_NAME="${OPTARG}" ;;
    e | environment )          needs_arg; ENVIRONMENT="${OPTARG}" ;;
    h | help )                 help ;;
    p | cloud_provider )       needs_arg; CLOUD_PROVIDER="${OPTARG}" ;;
    ??* )                      die "Illegal option --$OPT" ;;  # bad long option
    ? )                        exit 2 ;;  # bad short option (error reported via getopts)
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list
#####
# END getopts
#####



#####
#  Help and ERROR #
#####

# Check have some args
if [[ "${_COUNT_ARGS_FOR_ERROR}" -eq 0 ]]; then
  echo "[ERROR] no options given!"
  _ERROR=true
fi

if [ "$_ERROR" == "true" ]; then
  usage
  die
fi


# Testing if variable is empty
checkVariable ACTION "$ACTION"
checkVariable CLUSTER_NAME "$CLUSTER_NAME"

ACTION=$(tolower "$ACTION")

if [ "$ACTION" != "uninstall" ]; then
  checkVariable ENVIRONMENT "$ENVIRONMENT"
  checkVariable CLOUD_PROVIDER "$CLOUD_PROVIDER"

  CLOUD_PROVIDER=$(tolower "$CLOUD_PROVIDER")
  ENVIRONMENT=$(tolower "$ENVIRONMENT")

  # File with config values
  DEFAULT_VALUES="$HELM_DIR/values.yaml"
  CLOUD_VALUES="$HELM_DIR/$CLOUD_PROVIDER/values.yaml"
  CLUSTER_VALUES="$HELM_DIR/$CLOUD_PROVIDER/$ENVIRONMENT/$CLUSTER_NAME.yaml"


  # Check if cloud provider is supported
  case "$CLOUD_PROVIDER" in
    aws|gcp)
    ;;
    *)
      echo "[ERROR] '$CLOUD_PROVIDER' cloud provider not supported."
      usage
      exit 3
    ;;
  esac


  # Check if environment is supported
  case "$ENVIRONMENT" in
    testing|staging|production)
    ;;
    *)
      echo "[ERROR] '$ENVIRONMENT' environment not supported."
      usage
      exit 3
    ;;
  esac

  # Testing if files existis
  existfiles "$DEFAULT_VALUES" "$CLOUD_VALUES" "$CLUSTER_VALUES"

  # Check if should enable dry-run mode
  if [ "$5" == "--dry-run" ] ; then
    DRY_RUN=true
    DRY_RUN_HELM_OPTION='--dry-run'
  else
    DRY_RUN=false
    DRY_RUN_HELM_OPTION=''
  fi

  if [ "$ADD_HELM_REPO" == true ]; then
    echo "[INFO] Add Helm repo '$HELM_REPO_NAME'"
    helm repo add "$HELM_REPO_NAME" "$HELM_REPO_URL"
  fi

  helm repo update
fi

echo "[INFO] Testing access a kubernetes cluster."
testAccessKubernetes

# Get short cluster-name
if ``kubectl cluster-info > /dev/null 2>&1``; then
  CONTEXT_NAME=$(kubectl config current-context)
fi

SHORT_CLUSTER_NAME=$(echo "$CONTEXT_NAME" | grep -o "$CLUSTER_NAME")
if [ "$ACTION" != "uninstall" ]; then
  SHORT_CLUSTER_VALUES=$(basename "$CLUSTER_VALUES" | cut -d'.' -f1)
fi

if [ "$DEBUG" == true ]; then
  echo "[DEBUG] INIT -------------"
  echo "[DEBUG] CONTEXT_NAME         => $CONTEXT_NAME"
  echo "[DEBUG] CLUSTER_NAME         => $CLUSTER_NAME"
  echo "[DEBUG] NAMESPACE            => $NAMESPACE"
  echo "[DEBUG] SHORT_CLUSTER_NAME   => $SHORT_CLUSTER_NAME"
  if [ "$ACTION" != "uninstall" ]; then
    echo "[DEBUG] CLUSTER_VALUES       => $CLUSTER_VALUES"
    echo "[DEBUG] SHORT_CLUSTER_VALUES => $SHORT_CLUSTER_VALUES"
    echo "[DEBUG] Helm plugins installed..."
    helm plugin list
  fi
  echo "[DEBUG] END"
fi

# Check 1: if the connected cluster is the correct
if ! kubectl config current-context | grep -q "$CLUSTER_NAME"; then
  MESSAGE="[ERROR] Connect in correct cluster: \"$CLUSTER_NAME\""
  printRedMessage "$MESSAGE"
  exit 1
fi

if [ "$ACTION" != "uninstall" ]; then
  # Check 2: if the connected cluster is the same of helm values
  if [ "$SHORT_CLUSTER_NAME" != "$SHORT_CLUSTER_VALUES" ]; then
    MESSAGE="[ERROR] Connect in correct cluster: \"$SHORT_CLUSTER_VALUES\""
    printRedMessage "$MESSAGE"
    exit 1
  fi
fi

# Create namespace if not exist
createNameSpace "$NAMESPACE"

# Execute action
case "$ACTION" in
  install|upgrade)
    install_prometheus_operator
    ;;
  uninstall)
    uninstall_prometheus_operator
    ;;
  *)
    echo "[ERROR] '$ACTION' action not supported."
    usage
    exit 3
  ;;
esac
