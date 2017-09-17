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

echo 'Attempting to destroy AWS Lambda with name "'$AWS_LAMBDA_NAME'" and AWS Role "'$AWS_LAMBDA_ROLE_WORKSHOP'".' 

if aws lambda delete-function \
  --function-name $AWS_LAMBDA_NAME ; then 
  
  echo 'Lambda destroyed.'
else 
  echo 'Failed to destroy Lambda.'
  exit 1
fi

# Remove the state file for the lambda
rm $UTILIRY_DIRECTORY/.hello-world 2> /dev/null
