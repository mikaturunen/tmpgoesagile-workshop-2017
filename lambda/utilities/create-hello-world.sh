#!/bin/bash


# ---------------------- PRE-RUN CHECK UPS ----------------------
# First things first - make sure we have all set up.
# Check few env variables we need to have
if [[ -z "${AWS_LAMBDA_ROLE}" ]]; then
  echo 'Please export Role into AWS_LAMBDA_ROLE for the script to work.'
  exit 1
fi
if [[ -z "${AWS_LAMBDA_NAME}" ]]; then
  echo 'Please export Lambda name into AWS_LAMBDA_NAME for the script to work.'
  exit 1
fi


# ---------------------- FUNCTIONS ----------------------
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


# ---------------------- ACTUAL SCRIPT FUNCTIONALITY ITSELF ----------------------
# Source environment variables into this context
if . $UTILIRY_DIRECTORY/hello-world-lambda.sh ; then
  echo 'Environment variables loaded.'
else 
  echo 'Could not load environment variables from file.'
  # Possible problem with $PATH or a typo -- relates to path of hello-world-lambda.sh
  exit 127
fi

echo 'Attempting to create AWS Lambda with name "'$AWS_LAMBDA_NAME'" with AWS Role "'$AWS_LAMBDA_ROLE_WORKSHOP'".' 

if aws lambda create-function \
  --function-name $AWS_LAMBDA_NAME \
  --runtime $AWS_LAMBDA_RUNTIME \
  --role $AWS_LAMBDA_ROLE_WORKSHOP \
  --handler $AWS_LAMBDA_HANDLER \
  --zip-file $AWS_LAMBDA_ZIP_FILE ; then 
  
  echo 'Created Lambda OK.'
else 
  echo 'Failed to Create Lambda.'
  exit 1
fi

echo 'Listing available Lambda functions for current AWS Role.'
aws lambda list-functions

