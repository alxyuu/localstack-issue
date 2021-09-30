#!/bin/bash
shopt -s expand_aliases
alias awslocal='aws --endpoint-url http://localhost:4566'

docker-compose up -d

awslocal lambda create-function \
  --function-name test-lambda \
  --runtime nodejs12.x \
  --role arn:aws:iam::000000000:role/lambda-test \
  --handler index.handler \
  --code S3Bucket=__local__,S3Key=/tmp/localstack/lambda

awslocal lambda invoke \
  --function-name test-lambda \
  --invocation-type Event \
  --cli-binary-format raw-in-base64-out \
  --payload "{\"text\": \"this will pass\"}" \
  out

awslocal lambda invoke \
  --function-name test-lambda \
  --invocation-type Event \
  --cli-binary-format raw-in-base64-out \
  --payload "{\"text\": \"this won't pass\"}" \
  out

awslocal logs tail /aws/lambda/test-lambda
