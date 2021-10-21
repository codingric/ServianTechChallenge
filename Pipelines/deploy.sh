#!/bin/bash
Environment=$1
export Environment=$1

ROLE="arn:aws:iam::852998739144:role/teamAdmin"

KST=(`aws --profile amit-teamAdmin sts assume-role --role-arn $ROLE --role-session-name manual-ansible-deployment --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]' --output text`)

unset AWS_SECURITY_TOKEN
export AWS_ACCESS_KEY_ID=${KST[0]}
export AWS_SECRET_ACCESS_KEY=${KST[1]}
export AWS_SESSION_TOKEN=${KST[2]}
export AWS_SECURITY_TOKEN=${KST[2]}


ansible-playbook pipeline-ansible.yml -e "EnvPrefix=$Environment"
# export PROJECTACCOUNTS="654996818359 094551496269"
# python3 test_python.py
