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
  echo 'State file is not present. Lambda not deleted.'
  echo 'If you know the Lambda is created, touch utility/dynamodb/.dynamo and re-run this script.' 
  exit 0
fi 

echo 'Attempting to destroy AWS Lambda with name "'$AWS_LAMBDA_NAME_WORKSHOP'" and AWS Role "'$AWS_LAMBDA_ROLE_WORKSHOP'".' 

if aws lambda delete-function \
  --function-name $AWS_LAMBDA_NAME_WORKSHOP ; then 
  
  echo 'Lambda destroyed.'
else 
  echo 'Failed to destroy Lambda.'
  exit 1
fi

# Remove the state file for the lambda
rm $UTILITY_DIRECTORY/.dynamo 2> /dev/null
