#!/bin/bash

###################################
#
# Simple bash entrypoint for the 
# gitops-based presto pipeline
#
################################### 

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
DEF_VERSION="323-e.4"

prestoVersion=""

function log {
  echo -e "`date`: $1"
}

function doPrompt {
  clear
  banner -w 30 presto
  echo ". . . . . . . . . . . . . . . . . ."
  echo -e "This pipeline:"
  echo -e "- builds the specified presto version and uploads to GCR"
  echo -e "- deploys the newly built container to GKE"
  echo -e "- runs a bit of post-deploy validation on the deployed container"
  echo ". . . . . . . . . . . . . . . . . ."
  echo -e "${YELLOW}Please specify the presto version to initiate the pipeline (${DEF_VERSION}):${NC}" 
  read prestoVersion 
}

function checkInputs {
  # check required variables have been provided
  if [ -z "${prestoVersion}" ]; then
     log "${YELLOW}WARN${NC}: No presto version was provided.  Defaulting to ${DEF_VERSION}."
     prestoVersion=${DEF_VERSION}
  fi
}

function doPush {
  log "Initiating pipeline..."
  sed -i '' -e "s/_PRESTO_VERSION: .*/_PRESTO_VERSION: ${prestoVersion}/1" cloudbuild.yaml
  git add cloudbuild.yaml >/dev/null 2>&1 
  git commit -m "deploying presto v${prestoVersion}" >/dev/null 2>&1
  lastCommit=`git log -1 -- cloudbuild.yaml | head -1 | cut -d ' ' -f2`
  log "Pushed commit ${lastCommit}."
  git push  >/dev/null 2>&1
}

doPrompt
checkInputs
doPush

results=$?
if [ ! $results -eq 0 ]; then
  log "${RED}Unexpected return code of $results.${NC}"
  exit -1
fi
log "${GREEN}Presto server pipeline initiated."
log "Navigating to google cloud build for pipeline progress..."
open -a "Google Chrome" https://console.cloud.google.com/cloud-build/builds?project=presto-pl-gke 

