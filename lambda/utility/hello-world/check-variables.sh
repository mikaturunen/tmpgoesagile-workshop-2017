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

# Source environment variables into this context
if . $UTILITY_DIRECTORY/variables.sh ; then
  echo 'Environment variables loaded.'
else 
  echo 'Could not load environment variables from file.'
  # Possible problem with $PATH or a typo -- relates to path of hello-world-lambda.sh
  exit 127
fi
