# set of environment variables used by the simplest hello-world AWS Lambda

# Set the env variable $AWS_LAMBDA_ROLE in your own bash terminal and it will be available here and get exported 
# into the sub-shells per se
export AWS_LAMBDA_ROLE_WORKSHOP=$AWS_LAMBDA_ROLE 
export AWS_LAMBDA_NAME_WORKSHOP=$AWS_LAMBDA_NAME

export AWS_LAMBDA_RUNTIME=nodejs6.10
export AWS_LAMBDA_HANDLER=index.handler
export AWS_LAMBDA_ZIP_FILE=fileb://hello-world-lambda.zip