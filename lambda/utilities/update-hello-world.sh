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

if ! [ -f $UTILIRY_DIRECTORY/.hello-world ] ; then 
  echo 'State file not present. Not allowing update.'
  echo 'If you know the Lambda is uploaded, touch utilities/.hello-world and re-run this script.'
  echo 'If it is not or you are unsure, run the script create-hello-world.sh to upload the Lambda.' 
  exit 1
fi 

if aws lambda update-function-code \
  --function-name $AWS_LAMBDA_NAME \
  --zip-file $AWS_LAMBDA_ZIP_FILE ; then 
  
  echo 'Updated Lambda OK.'
else 
  echo 'Failed to update Lambda.'
  exit 1
fi

# juuuust playing if safe and creating the state file -- by definition it should be there already but still ;)
touch $UTILIRY_DIRECTORY/.hello-world

rm $UTILIRY_DIRECTORY/.output.log 2> /dev/null

if ! aws lambda invoke \
  --function-name $AWS_LAMBDA_NAME \
  --invocation-type RequestResponse \
  --payload "{}" \
  $UTILIRY_DIRECTORY/.output.log ; then
  
  echo 'Failed to invoke the created Lambda.'
fi

echo 'Response from the Lambda'
cat $UTILIRY_DIRECTORY/.output.log