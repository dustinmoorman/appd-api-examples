#/bin/bash

USER_NAME="dustin"
USER_PASS="appdynam1cs"
ACCOUNT_NAME="customer1"
CONTROLLER_HOST="http://dmoormandevelopmentlab-kfk90btr.appd-sales.com:8090"

# Get all applications in XML form
curl --user ${USER_NAME}@${ACCOUNT_NAME}:${USER_PASS} ${CONTROLLER_HOST}/controller/rest/applications
