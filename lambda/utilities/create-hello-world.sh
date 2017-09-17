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

UTILIRY_DIRECTORY=$(find_current_utility_script_directory)

# Check if all variables are in place that need to be
if ! . $UTILIRY_DIRECTORY/check-variables.sh ; then
  exit 1
fi

if [ -f $UTILIRY_DIRECTORY/.hello-world ] ; then 
  echo 'State file is present. Lambda already created.'
  echo 'If you know the Lambda is not created, rm utilities/.hello-world and re-run this script.' 
  exit 0
fi 

echo 'Attempting to create AWS Lambda with name "'$AWS_LAMBDA_NAME'" and AWS Role "'$AWS_LAMBDA_ROLE_WORKSHOP'".' 

if aws lambda create-function \
  --function-name $AWS_LAMBDA_NAME \
  --runtime $AWS_LAMBDA_RUNTIME \
  --role $AWS_LAMBDA_ROLE_WORKSHOP \
  --handler $AWS_LAMBDA_HANDLER \
  --zip-file $AWS_LAMBDA_ZIP_FILE ; then 
  
  echo 'Created Lambda OK.'
else 
  echo 'Failed to create Lambda.'
  exit 1
fi

touch $UTILIRY_DIRECTORY/.hello-world

echo 'Listing available Lambda functions for current AWS Role.'
aws lambda list-functions

