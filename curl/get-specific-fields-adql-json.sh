#!/bin/bash

API_KEY="d67cc104-6ac5-4a83-9cc1-cee1766e58a8" # dmoorman-test-api-key
GLOBAL_ACCOUNT_NAME="customer1_0cf8fe6a-74e0-4dac-b739-8e36b2d8e2ec"
CONTROLLER_HOST="http://dmoormandevelopmentlab-kfk90btr.appd-sales.com:9080"

ADQL_QUERY="SELECT responseTime, requestGUID, transactionName FROM transactions WHERE userExperience = ERROR"

curl -X POST -d "${ADQL_QUERY}" \
  -H"X-Events-API-AccountName:${GLOBAL_ACCOUNT_NAME}" \
  -H"X-Events-API-Key:${API_KEY}" \
  -H"Content-type: application/vnd.appd.events+json;v=2" \
  "${CONTROLLER_HOST}/events/query?limit=5"
