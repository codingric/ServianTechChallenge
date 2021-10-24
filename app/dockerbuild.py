# The python script to create the ECR repository for each environment if it dosent exist

import boto3
import os


aws_accountid = os.environ['AWS_ACCOUNTID']
envprefix = os.environ['ENVPREFIX']
aws_region = os.environ['AWS_REGION']
image_tag = os.environ['CODEBUILD_BUILD_NUMBER']

ecr = boto3.client('ecr', region_name=aws_region)

envprefix = envprefix.lower()

# Function to check if ecr repo exists


def check_repository():
    try:
        response = ecr.describe_repositories(
            repositoryNames=[
                envprefix+'-serviantestapp',
            ]
        )

        print(
            f'The repostory with name - {envprefix}-{application} already exists')
    except Exception as e:
        print(e)
        print("ECR repo does not exists, creating one.")
        response = ecr.create_repository(repositoryName=envprefix + '-serviantestapp', imageTagMutability='IMMUTABLE', imageScanningConfiguration={
            'scanOnPush': True
        }
        )
        print(response)


check_repository()
