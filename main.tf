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

resource "aws_key_pair" "sample_ec2_key" {
  key_name   = "my-ec2-key"
  public_key = file("~/.ssh/my-ec2-key.pub")  # adjust path as needed
}

resource "aws_instance" "thena_devops" {
  ami           = "ami-0f1dcc636b69a6438" 
  instance_type = "t2.micro"
  key_name = aws_key_pair.sample_ec2_key.key_name
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              
              apt install -y nginx
              
              systemctl enable nginx

              systemctl start nginx

              apt install -y git

              ufw allow 'Nginx HTTP'
              EOF

  tags = {
    Name = "Thena DevOps Assignment"
  }
}

output "public_ip" {
  value = aws_instance.thena_devops.public_ip
}
