#!/bin/bash

# Set initial user info, controller host, pull duration
USER_NAME="dustin"
USER_PASS="appdynam1cs"
ACCOUNT_NAME="customer1"
CONTROLLER_HOST="http://dmoormandevelopmentlab-kfk90btr.appd-sales.com:8090"
DURATION_MINS=11520

# Get all applications in XML form
curl --user ${USER_NAME}@${ACCOUNT_NAME}:${USER_PASS} "${CONTROLLER_HOST}/controller/rest/applications/AppDynamics%20Analytics-2/metric-data?metric-path=Analytics%7CInstrumentable%20Tomcat%20Call%20Errors&time-range-type=BEFORE_NOW&duration-in-mins=${DURATION_MINS}"
