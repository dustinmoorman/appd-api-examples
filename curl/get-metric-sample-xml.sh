#!/bin/bash

# Set initial user info, controller host, pull duration
USER_NAME="dustin"
USER_PASS="appdynam1cs"
ACCOUNT_NAME="customer1"
CONTROLLER_HOST="http://dmoormandevelopmentlab-kfk90btr.appd-sales.com:8090"

METRIC_PATH="Analytics%7CInstrumentable%20Tomcat%20Call%20Errors"
TIME_RANGE_TYPE="BEFORE_NOW"
DURATION_MINS=60

# Get metrics call
curl --user "${USER_NAME}@${ACCOUNT_NAME}:${USER_PASS}" \
  "${CONTROLLER_HOST}/controller/rest/applications/AppDynamics%20Analytics-2/metric-data?metric-path=${METRIC_PATH}&time-range-type=${TIME_RANGE_TYPE}&duration-in-mins=${DURATION_MINS}"
