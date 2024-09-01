provider "aws" {
    region = "us-west-1"  
}

resource "aws_instance" "ec2-instance" {
  ami           = "ami-0d53d72369335a9d6" # us-west-1
  instance_type = "t2.micro"
  tags = {
      Name = "Jenkins-Instance"
  }
}

