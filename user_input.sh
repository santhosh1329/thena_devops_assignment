#!/bin/bash
#getting the input of github url & branch
read -p "Please Enter the GitHub/GitLab repository URL: " repo_url
read -p "Please Enter the branch name that you want to test: " branch_name

git clone $repo_url devops_assignment
if [ $? -ne 0 ]; then
  echo "Repo cloning failed"
  exit 1
fi
git fetch origin main && git checkout $branch_name

#getting the input of branch url
echo "Please Enter the Branch name you want to test"
git fetch origin main && git checkout $2
cd devops_assignment

#terraform deployment to aws instance
terraform init -input=false
terraform apply -auto-approve

if [ $? -ne 0 ]; then
  echo "Terraform deployment to aws instance failed."
  exit 1
fi

EC2_PUBLIC_IP=$(terraform output -raw public_ip)

sleep 60

scp -i ~/.ssh/my-ec2-key.pem index.html ec2-user@$EC2_PUBLIC_IP:/tmp/index.html

ssh -t -i ~/.ssh/my-ec2-key.pem ec2-user@$EC2_PUBLIC_IP "bash -l -c 'sudo mv /tmp/index.html /usr/share/nginx/html/index.html && sudo systemctl restart nginx'"


echo "Deployment URL:http:${EC2_PUBLIC_IP}"


