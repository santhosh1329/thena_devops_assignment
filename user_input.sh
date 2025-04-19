#!/bin/bash
#getting the input of github url & branch
read -p "Please Enter the GitHub/GitLab repository URL: " $1
read -p "Please Enter the branch name that you want to test: " $2

git clone $1 devops_assignment
if [ $? -ne 0 ]; then
  echo "Repo cloning failed"
  exit 1
fi
git fetch origin main && git checkout $2

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


scp -i ~/.ssh/your-key.pem index.html ubuntu@$EC2_PUBLIC_IP:/tmp/

ssh -i ~/.ssh/your-key.pem ubuntu@$EC2_PUBLIC_IP <<EOF
  sudo mv /tmp/index.html /var/www/html/index.html
  sudo systemctl restart nginx
EOF


