# This block gets AMI for Ubuntu 22.04
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# This block creates an AWS key pair resource for SSH access to the EC2 instances using a public key file (as4_key.pub)
resource "aws_key_pair" "local_key" {
  key_name   = "AWS_Key"
  public_key = file("~/.ssh/as4_key.pub")
}

# This block creates two EC2 instances (web, app)  using the for_each argument and the set of values
resource "aws_instance" "ubuntu" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.ubuntu.id
  for_each      = toset(["web", "app"])

  tags = {
    Name   = "ubuntu-${each.value}"
    Server = "${each.key}-server"
  }

  key_name               = aws_key_pair.local_key.id
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              = aws_subnet.main.id

  root_block_device {
    volume_size = 10
  }
}
