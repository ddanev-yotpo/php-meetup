#!/usr/bin/env bash -x

IMAGE_NAME=$1
DOCKERFILE=${2:-Dockerfile}
TAG=latest

AWS_PROFILE=__CHANGEME__
AWS_ACCOUNT_ID=__CHANGEME__
AWS_REGION=us-east-1
AWS_ECR_ENDPOINT=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

aws --profile $AWS_PROFILE ecr get-login-password --region $AWS_REGION \
| docker login --username AWS --password-stdin $AWS_ECR_ENDPOINT

docker \
    buildx build --platform=linux/amd64 \
    -t ${AWS_ECR_ENDPOINT}/${IMAGE_NAME}:${TAG} \
    -f $DOCKERFILE . && \
    docker push ${AWS_ECR_ENDPOINT}/${IMAGE_NAME}:${TAG}

