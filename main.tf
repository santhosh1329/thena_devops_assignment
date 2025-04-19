terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-south-1"
}

#resource "aws_key_pair" "sample_ec2_key" {
#  key_name   = "my-ec2-key"
#  public_key = file("~/.ssh/my-ec2-key.pub")  # adjust path as needed
#}

resource "aws_instance" "thena_devops" {
  ami           = "ami-0f1dcc636b69a6438" 
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-09f2ed42d97b5fa92"] 
  key_name = "my-ec2-key"
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                dnf update -y
                dnf install -y nginx
                systemctl enable nginx
                systemctl start nginx       
        EOF

}

output "public_ip" {
  value = aws_instance.thena_devops.public_ip
}
