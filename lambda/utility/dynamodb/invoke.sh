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

if ! [ -f $UTILITY_DIRECTORY/.dynamo ] ; then 
  echo 'State file not present. Not allowing update.'
  echo 'If you know the Lambda is uploaded, touch utility/dynamodb/.dynamo and re-run this script.'
  echo 'If it is not or you are unsure, run the script create-hello-world.sh to upload the Lambda.' 
  exit 1
fi 


if ! aws lambda invoke \
  --function-name $AWS_LAMBDA_NAME_WORKSHOP \
  --invocation-type RequestResponse \
  --payload fileb://$UTILITY_DIRECTORY/item.json \
  $UTILITY_DIRECTORY/.output.log ; then
  
  echo 'Failed to invoke the updated Lambda.'
fi

echo 'Response from the Lambda'
cat $UTILITY_DIRECTORY/.output.log