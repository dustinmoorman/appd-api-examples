#!/bin/bash

API_KEY="d67cc104-6ac5-4a83-9cc1-cee1766e58a8" # dmoorman-test-api-key
GLOBAL_ACCOUNT_NAME="customer1_0cf8fe6a-74e0-4dac-b739-8e36b2d8e2ec"
CONTROLLER_HOST="http://dmoormandevelopmentlab-kfk90btr.appd-sales.com:9080"
LIMIT=2

ADQL_QUERY="SELECT * FROM web_session_records" 

curl -s -X POST -d "${ADQL_QUERY}" \
  -H"X-Events-API-AccountName:${GLOBAL_ACCOUNT_NAME}" \
  -H"X-Events-API-Key:${API_KEY}" \
  -H"Content-type: application/vnd.appd.events+json;v=2" \
  "${CONTROLLER_HOST}/events/query?limit=${LIMIT}" \
  -o .query_results

TOTAL_ROWS=$(cat .query_results | jq -r .[].total)
COUNT_RETURNED=$(cat .query_results | jq '.[].results | length')

# Get last element of array, and find the timestamp
LAST_TIMESTAMP=$(cat .query_results | jq -r '.[].results | .[-1] | .[12]')

echo "Total Result Rows: ${TOTAL_ROWS}";
echo "Returned in query: ${COUNT_RETURNED}";
echo "Last Timestamp in collection: ${LAST_TIMESTAMP}";

if ((${COUNT_RETURNED} < ${TOTAL_ROWS}));
then
  curl -s -X POST -d "${ADQL_QUERY}" \
    -H"X-Events-API-AccountName:${GLOBAL_ACCOUNT_NAME}" \
    -H"X-Events-API-Key:${API_KEY}" \
    -H"Content-type: application/vnd.appd.events+json;v=2" \
    "${CONTROLLER_HOST}/events/query?limit=${LIMIT}&start=${LAST_TIMESTAMP}" \
    -o .query_results_2
fi

cat .query_results_2 | jq

rm .query_results
