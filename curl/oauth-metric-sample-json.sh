#!/bin/bash

# Set initial user info & controller host
OAUTH_CLIENT_SECRET="49c0ae5b-e6e1-4ae3-b69e-53a74b7e430e"
OAUTH_CLIENT_NAME="dmoorman-test-client"
ACCOUNT_NAME="customer1"
CONTROLLER_HOST="http://dmoormandevelopmentlab-kfk90btr.appd-sales.com:8090"

# Query details: Application, metrics path, time range type, & duration
APPLICATION="AppDynamics%20Analytics-2"
METRIC_PATH="Analytics%7CInstrumentable%20Tomcat%20Call%20Errors"
TIME_RANGE_TYPE="BEFORE_NOW"
DURATION_MINS=60

# OAuth Exchange: Obtain Access Token with Client Secret
curl -s -X POST -H "Content-Type: application/vnd.appd.cntrl+protobuf;v=1" \
  "${CONTROLLER_HOST}/controller/api/oauth/access_token" \
  -d "grant_type=client_credentials&client_id=${OAUTH_CLIENT_NAME}@${ACCOUNT_NAME}&client_secret=${OAUTH_CLIENT_SECRET}" \
  -o .access_token_payload

ACCESS_TOKEN=$(cat .access_token_payload | jq -r .access_token)

# Get all applications in XML form
curl -H "Authorization:Bearer ${ACCESS_TOKEN}" \
  "${CONTROLLER_HOST}/controller/rest/applications/${APPLICATION}/metric-data?metric-path=${METRIC_PATH}&time-range-type=${TIME_RANGE_TYPE}&duration-in-mins=${DURATION_MINS}"

# cleanup 
rm .access_token_payload
