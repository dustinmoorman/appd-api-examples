#!/bin/bash

API_KEY="d67cc104-6ac5-4a83-9cc1-cee1766e58a8" # dmoorman-test-api-key
GLOBAL_ACCOUNT_NAME="customer1_0cf8fe6a-74e0-4dac-b739-8e36b2d8e2ec"
CONTROLLER_HOST="http://dmoormandevelopmentlab-kfk90btr.appd-sales.com:9080"
LIMIT=2
OUTPUT_FILENAME="results.json"

############# The ADQL query with the table you would like to pull data from
ADQL_QUERY="SELECT * FROM web_session_records" 

############## The actual API call, note the limit parameter, content type, and use of the HTTP Headers for Authentication
curl -s -X POST -d "${ADQL_QUERY}" \
  -H"X-Events-API-AccountName:${GLOBAL_ACCOUNT_NAME}" \
  -H"X-Events-API-Key:${API_KEY}" \
  -H"Content-type: application/vnd.appd.events+json;v=2" \
  "${CONTROLLER_HOST}/events/query?limit=${LIMIT}" \
  -o .query_results

echo "First pull";
cat .query_results > "${OUTPUT_FILENAME}"
cat "${OUTPUT_FILENAME}" | jq 

TOTAL_ROWS=$(cat .query_results | jq -r .[].total)
COUNT_RETURNED=$(cat .query_results | jq '.[].results | length')

# Get oldest element of array, and find the timestamp
OLDEST_TIMESTAMP=$(cat .query_results | jq -r '.[].results | .[-1] | .[12]')

echo "Total Result Rows: ${TOTAL_ROWS}";
echo "Returned in query: ${COUNT_RETURNED}";
echo "Last Timestamp in collection: ${OLDEST_TIMESTAMP}";

echo "Second pull";

if ((${COUNT_RETURNED} < ${TOTAL_ROWS}));
then
  ############### Follow up API calls with date pagination ending on the oldest timestamp recieved from the previous run
  curl -s -X POST -d "${ADQL_QUERY}" \
    -H"X-Events-API-AccountName:${GLOBAL_ACCOUNT_NAME}" \
    -H"X-Events-API-Key:${API_KEY}" \
    -H"Content-type: application/vnd.appd.events+json;v=2" \
    "${CONTROLLER_HOST}/events/query?limit=${LIMIT}&end=${OLDEST_TIMESTAMP}" \
    -o .query_results_2
fi

# Remove the newest record in this set as it was used in end time so is also pulled
RECORD_SET=$(cat .query_results_2 | jq '.[].results | del(.[0])')
echo $RECORD_SET | jq .[]

TOTAL_ROWS=$(cat .query_results_2 | jq -r .[].total)
COUNT_RETURNED=$(cat .query_results_2 | jq '.[].results | length')

echo "Total Result Rows: ${TOTAL_ROWS}";
echo "Returned in query: ${COUNT_RETURNED}";
echo "Last Timestamp in collection: ${LAST_TIMESTAMP}";

cat "${OUTPUT_FILENAME}" | jq ".[].results |= .+ [${RECORD_SET}]"

# cleanup
rm .query_results
rm .query_results_2
