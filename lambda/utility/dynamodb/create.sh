#!/bin/bash

# Finds the directory the scripts are in, in a fairly robust manner
find_current_utility_script_directory () {
   SOURCE="${BASH_SOURCE[0]}"
   # While $SOURCE is a symlink, resolve it
   while [ -h "$SOURCE" ]; do
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$( readlink "$SOURCE" )"
        # If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
   done
   DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
   echo "$DIR"
}

UTILITY_DIRECTORY=$(find_current_utility_script_directory)

# Check if all variables are in place that need to be
if ! . $UTILITY_DIRECTORY/check-variables.sh ; then
  exit 1
fi

if [ -f $UTILITY_DIRECTORY/.dynamo ] ; then 
  echo 'State file is present. Lambda already created.'
  echo 'If you know the Lambda is not created, rm utility/dynamodb/.dynamo and re-run this script.' 
  exit 0
fi 

echo 'Attempting to create AWS Lambda with name "'$AWS_LAMBDA_NAME_WORKSHOP'" and AWS Role "'$AWS_LAMBDA_ROLE_WORKSHOP'".' 

if aws lambda create-function \
  --function-name $AWS_LAMBDA_NAME_WORKSHOP \
  --runtime $AWS_LAMBDA_RUNTIME \
  --role $AWS_LAMBDA_ROLE_WORKSHOP \
  --handler $AWS_LAMBDA_HANDLER \
  --zip-file $AWS_LAMBDA_ZIP_FILE ; then 
  
  echo 'Created Lambda OK.'
else 
  echo 'Failed to create Lambda.'
  exit 1
fi

touch $UTILITY_DIRECTORY/.dynamo

echo 'Listing available Lambda functions for current AWS Role.'
aws lambda list-functions

rm $UTILITY_DIRECTORY/.output.log 2> /dev/null

if ! aws lambda invoke \
  --function-name $AWS_LAMBDA_NAME_WORKSHOP \
  --invocation-type RequestResponse \
  --payload file://$UTILITY_DIRECTORY/item.json \
  $UTILITY_DIRECTORY/.output.log ; then
  
  echo 'Failed to invoke the created Lambda.'
fi

echo 'Response from the Lambda'
cat $UTILITY_DIRECTORY/.output.log
