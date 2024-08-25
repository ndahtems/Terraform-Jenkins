provider "aws" {
    region = "us-east-1"  
}

resource "aws_instance" "ec2-instance" {
  ami           = "ami-0e86e20dae9224db8" # us-east-1
  instance_type = "t2.medium"
  tags = {
      Name = "jenkins-instance"
  }
}
