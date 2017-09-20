# Practical AWS serverless 101

It's a fairly good assumption to say that all technically inclined people more or less love new technology. That's what got them into it in the first place. So here we are, looking at AWS serverless capabilities when it comes to Lambdas. It's not super bleeding edge, but it doest have some funky features and behaviours that makes it more than interesting to look at and use in real life.

In this workshop we'll quickly round up few AWS Lambdas, see how they work and what they do and once we're done with the workshop, you should have a fairly good idea of how they work, what they can do, what they are good in and what they are not so good at.

You'll get to deploy your very own AWS baby step lambdas and see what they do, play with the and most importantly, break them.


# Requirements for workshop


* Install: [AWS Command Line Interface installed](https://aws.amazon.com/cli)
* Given by instructor: AWS Access Key ID
* Given by instructor: AWS Secret Access Key
* Given by instructor: Lambda role

# Content of this directory

* `source`: Directory contains all the source code for the lambda.
* `source\hello-world\index.js`: Hello-world Lambda function
* `source\hello-world\package.json`: Node.js package.json package file.
* `source\dynamodb\index.js`: Dynamodb Lambda function
* `source\dynamodb\package.json`: Node.js package.json package file.
* `README.md`: This file, explaining everything.

`hello-world` is your baby steps to world of Lambda, just understanding how life works and the mentor will guide you through the lifecycle of Lambda's during the workshop.

`dynamodb` is second evolution, now we are talking into the database and actually getting things done.

TODO: `full-serverless` is the advanced, third evolution where we setup a simple web page with some functionality that is hosted without a separate server and it communicates into the `lambda` that actually acts as the backend for your baby web application.

# How to use the Lambda

## Note before we start

You don't actually have to install anything to test the `source\hello-world` Lambda and have it running in AWS. But if you want to run it locally, install additional packages and do something bigger, you need to have Node.js development environment installed. All the examples on how to run things are pointing to hello-world example, but the same applies to all of the lambdas when it comes to running them.

This workshop does not assume technical background but makes the assumption that you've written one or two hello world -type scripts in the past.

## Running the workshop materials

### CLI

These are given during the workshop:

* Lambda role
* AWS Access Key ID
* AWS Secret Access Key

The whole group will be using the same keys. Open terminal.

```bash
# Tested on OSX.
# Replace with your own unique function name, if you share the function name with someone -> will get mixed up with you.
# Essentially you are the same user during this workshop from access rights point of view :)
$ export AWS_LAMBDA_NAME=workshop                               
# Replace this with the real role provided by the instructor or if you followed the guide below.
$ export AWS_LAMBDA_ROLE=arn:aws:iam::************:role/workshop
# This is the execution environment, in this workshop we are using Node.js as it's fairly simple to understand.
$ export AWS_LAMBDA_RUNTIME=nodejs6.10

$ aws configure

  AWS Access Key ID [None]:     AKI**************K4A
  AWS Secret Access Key [None]: gbW**********************************KLL
  Default region name [None]:   eu-central-1
  Default output format [None]: json
 
$ aws lambda list-functions 

  {
    "Functions": []
  }
  
# We ZIP the contest of the file and send it off to AWS with the CLI
# OSX Specific -- use whatever means to zip the content of the dir into lambda.zip inside the dir
$ cd source/hello-world
$ zip -r lambda.zip * 

  updating: source/hello-world/index.js (deflated 41%)
  updating: source/hello-world/package.json (deflated 36%)
  ...

$ aws lambda create-function \
  --function-name workshop \
  --runtime $AWS_LAMBDA_RUNTIME \
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

# Feeling lazy?

Good, so am I. That's why I made a set of utility scripts to _really_ speed things up. Only tested to work on OS X but can't really see why they wouldn't work on nix based systems. Famous last words, eh?

```bash
$ export AWS_LAMBDA_NAME=workshop
 # Replace with the real Role
$ export AWS_LAMBDA_ROLE=arn:aws:iam::************:role/workshop 
$ export AWS_LAMBDA_RUNTIME=nodejs6.10
$ aws configure
$ ./utilities/create-hello-world.sh
$ ./utilities/delete-hello-world.sh
```

There, you've run the creation and deletion of it. The utility scripts should also invoke all the required content.

# Want to do the workshop but missed it at Tampere Goes Agile?

## Required

* AWS credentials
  * [AWS Free Tier - Create a Free Account](https://aws.amazon.com/free)
  * Go to the link and create a free tier Account
* [AWS Command Line Interface installed](https://aws.amazon.com/cli)

## Create required keys and roles

Next you'll have to create the three following items to be able to run the CLI Commands:

* AWS Access Key ID
* AWS Secret Access Key
* Lambda role

## Login into AWS and start creating

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


