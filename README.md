
**File Description:**
1. index.html --> website that is deployed through nginx on an ec2 instance using terraform.
2. main.tf --> terraform file that is configured to create an ec2 instance with nginx pre-installed using user-data script.
3. user_input.sh --> CLI where user can enter the github url and branch name that they want to deploy.

**Deployment Instructions:**
1. Run the user_input.sh script which it will prompt for github repo URL and branch name you want to deploy.
2. Give the https URL of the github repo and the branch name which you want to deploy.
3. The script will deploy the site to an ec2 instance in nginx web server. (Not routed to DNS provider as of now since everything is paid, this will print out the deployment url with public IP)

**Architecure Diagram:**
user_input.sh --> user gives input --> terraform creating an ec2 instance --> copied the index.html to the /tmp directory in that ec2 instance with scp --> ssh to that instance with giving commands to move the /tmp/index.html to /usr/share/nginx/html/index.html --> deployment url printed --> website is now serving.

**Auto-destroy logic explanation:**
        Created an alarm in AWS cloudwatch for checking the networkout parameter in ec2 and set the threshold as if it is less than 1 , it will automatically terminate the instance.

**Manual cleanup instructions:**
        You can go to the AWS console and delete the EC2 instance that is running with the same IP that we got output with the deployment URL.
