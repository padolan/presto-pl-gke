#!/bin/bash 

###################################################
#
# Smoke test a presto server using presto-cli 
#
###################################################

function log {
  echo -e "`date`: $1"
}

function checkInputs {
  # check required variables have been provided 
  if [ -z "${server}" ]; then
     log "ERROR: No server was provided.  Please provide the remote presto server."
     exit 1 
  fi
  if [ -z "${query}" ]; then
     query='select count(*) from mysql.information_schema.tables' 
  fi
}

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' 

checkInputs
presto-cli --server ${server} --execute "${query}" 
results=$?
if [ ! $results -eq 0 ]; then
  log "${RED}Unexpected return code of $results.${NC}"
  exit -1
fi
log "${GREEN}Presto server ${server} looks OK.${NC}"
exit 0

