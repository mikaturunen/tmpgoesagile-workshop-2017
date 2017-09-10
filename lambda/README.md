# Requirements

* AWS credentials
  * [AWS Free Tier - Create a Free Account](https://aws.amazon.com/free)
  * Go to the link and create a free tier Account
  
  
## Optional

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

## Running the Lambda

* Get AWS Account, you'll need it, I'm pretty sure of this :smile:
