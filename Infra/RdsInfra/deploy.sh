#!/bin/bash
helpfunction ()
{
printf "\nUsage: deploy.sh -e NonProd -p non-prodTeamAdmin -r RoleName \n\n-e = Environment name to deploy the stack. Valid values are NonProd, Prod.\n
-p = Local AWS CLI profile to use to connect to AWS account.\n
-r = Role name to be assumed while deploying the stack.\n"
exit 1
}


while getopts e:p:r: flag
do
    case "${flag}" in
        e) Environment=${OPTARG};;
        p) Profile=${OPTARG};;
        r) Role=${OPTARG};;
        ?) helpfunction ;;
    esac
done

# Print helpFunction in case parameters are empty
if [ -z "$Environment" ] || [ -z "$Profile" ] || [ -z "$Role" ]
then
   echo "Some or all of the parameters are empty";
   helpfunction
fi

AWS_ACCOUNT=(`aws sts get-caller-identity --query Account --output text`)
ROLE="arn:aws:iam::${AWS_ACCOUNT}:role/${Role}"

KST=(`aws --profile ${Profile} sts assume-role --role-arn $ROLE --role-session-name manual-ansible-deployment-${Role} --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]' --output text`)

unset AWS_SECURITY_TOKEN
export AWS_ACCESS_KEY_ID=${KST[0]}
export AWS_SECRET_ACCESS_KEY=${KST[1]}
export AWS_SESSION_TOKEN=${KST[2]}
export AWS_SECURITY_TOKEN=${KST[2]}



ansible-playbook rds-ansible.yml -e "EnvPrefix=$Environment"
