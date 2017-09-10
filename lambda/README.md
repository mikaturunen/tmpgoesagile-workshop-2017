# Requirements

* [AWS Command Line Interface installed](https://aws.amazon.com/cli)

# Content of this directory

* `source`: Directory contains all the source code for the lambda.
* `source\index.js`: Lambda function code
* `source\package.json`: Node.js package.json package file.
* `README.md`: This file, explaining everything.

# How to use the Lambda

## Note before we start

You don't actually have to install anything to test the Lambda and have it running in AWS. But if you want to run it locally, install additional packages and do something bigger, you need to have Node.js development environment installed.

As of now, the Lambda does not use any external packages and thus does not really require running of `npm install` (or `yarn install`).

This workshop assumes that you are of technical background and does not explain certain commands or functions too much and assumes you have written simple hello world -functions before in different languages.

## Running the Lambda

* Get AWS Account, you'll need it, I'm pretty sure of this :smile:

### CLI

These are given during the workshop:

* Lambda role
* AWS Access Key ID
* AWS Secret Access Key

The whole group will be using the same keys.

```bash
# OSX
$ export AWS_LAMBDA_ROLE=arn:aws:iam::************:role/workshop # Replace with the real Role
$ aws configure

  AWS Access Key ID [None]:     AKI**************K4A
  AWS Secret Access Key [None]: gbW**********************************KLL
  Default region name [None]:   eu-central-1
  Default output format [None]: json
 
$ aws lambda list-functions 

  {
    "Functions": []
  }
  
$ cd source
$ zip -r lambda.zip * # We ZIP the contest of the file and send it off to AWS with the CLI

  updating: index.js (deflated 41%)
  updating: package.json (deflated 36%)

$ aws lambda create-function \
  --function-name workshop \
  --runtime nodejs6.10 \
  --role $AWS_LAMBDA_ROLE \
  --handler index.handler \
  --zip-file fileb://lambda.zip
  
  {
    "TracingConfig": {
        "Mode": "PassThrough"
    },
    "CodeSha256": "ImrD6VhEfMW7HwuUpB16bYj1/5T4Bg2oMEbWcCzaUjU=",
    "FunctionName": "workshop",
    "CodeSize": 1012,
    "MemorySize": 128,
    "FunctionArn": "arn:aws:lambda:eu-central-1:547036979707:function:workshop",
    "Version": "$LATEST",
    "Role": "arn:aws:iam::************:role/workshop",
    "Timeout": 3,
    "LastModified": "2017-09-10T13:17:17.251+0000",
    "Handler": "index.handler",
    "Runtime": "nodejs6.10",
    "Description": ""
  }
  
  
$ aws lambda invoke --function-name workshop --invocation-type RequestResponse --payload "{}" output.txt

  {
      "StatusCode": 200
  }
  
$ cat output.txt

  "Hello, World!"
  
# Remember to clean up after yourself
$ aws lambda delete-function --function-name workshop
```

# Want to do the workshop but missed it at Tampere Goes Agile?

## Required

* AWS credentials
  * [AWS Free Tier - Create a Free Account](https://aws.amazon.com/free)
  * Go to the link and create a free tier Account
* [AWS Command Line Interface installed](https://aws.amazon.com/cli)


Next you'll have to create the three following items to be able to run the CLI Commands:

* AWS Access Key ID
* AWS Secret Access Key
* Lambda role

I assume you have created your AWS Free Tier account and are ready to login. 
Follow these steps:

* Login into the account
* From top right corner, click your name and select 'My Security Credentials'
  * From the left column, click 'Users'
  * 'Add user'
    * Name: Test
    * Select Access type to be 'Programmatic access' only. 
    * 'Next: Permissions'
    * 'Add user to group'
    * 'Create group'
    * Group name: 'Admin'
    * Find policy 'AdministratorAccess' and select it
    * Now select your freshly created 'Admin' group and add the user to it
    * 'Next: Review'
    * 'Create user'
    * Write down the `Access key ID` and `Secret access key`, you will use these with the CLI”
    * Now you have the credentials to run the CLI properly, at this point you want to create the role for the Lambda
* From top right corner, click your name and select 'My Security Credentials'
  * From the left column, click 'Roles'
  * 'Create role'
    * 'AWS service' -> 'Lambda'
    * 'Next: Permissions'
    * Attach following policies
      * 'AWSLambdaBasicExecutionRole'
      * 'AWSLambdaRole'
    * Role name: `workshop`
    * 'Create Role'
  * This Role will be used to run the AWS Lambda through the CLI. You will attach the Lambda to this policy.
* Third time from top right corner, click your name and select 'My Security Credentials'
* 'Roles'
* Select your newly created Role 'workshop'
  * Find the full Role ARN: `arn:aws:iam::************:role/workshop`
  * This is the full Role you need to have at hand
* Hop back into the section named 'CLI' and continue with the README.


