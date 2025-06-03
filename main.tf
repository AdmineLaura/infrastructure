  
provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket         = "codeacademy-terraform-state-bucket"    
    key            = "codeacademy-terraform-state-table.tfstate" 
    region         = "us-east-1" 
    dynamodb_table = "terraform"
    encrypt        = true
 }
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main-igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "ubuntu_ssh_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_security_group" "allow_ssh_http_https" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh-5000"
  }
}

resource "aws_instance" "ubuntu_instance" {
  ami                         = "ami-0c1ac8a41498c1a9c"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http_https.id]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true

  tags = {
    Name = "ubuntu-instance" 
  }
}

resource "null_resource" "name"  {

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ssh_key.private_key_pem
    host        = aws_instance.ubuntu_instance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
    "sudo apt update -y",
    "sudo apt install -y curl",
    "sudo curl -fsSL https://get.docker.com -o get-docker.sh",
    "sudo sh get-docker.sh",
    "sudo systemctl enable docker"
    ]
  }


  depends_on = [aws_instance.ubuntu_instance]

}

output "container_url" {
  value = join("", ["http://", aws_instance.ubuntu_instance.public_ip, ":5000"])
}

# Configure the GitHub provider

provider "github" {
  token = ${{ secrets.REPO_TOKEN }}
  owner = ${{ secrets.REPO_OWNER }}
}

resource "github_actions_secret" "my_secret" {
  repository      = ${{ secrets.REPO_NAME }}
  secret_name     = "EC2_HOST_PRIVATE_KEY"
  plaintext_value = tls_private_key.ssh_key.private_key_pem
}

resource "github_actions_secret" "my_secret2" {
  repository      = ${{ secrets.REPO_NAME }}
  secret_name     = "EC2_HOST_PUBLIC_KEY"
  plaintext_value = tls_private_key.ssh_key.public_key_openssh
}

resource "github_actions_secret" "my_secret3" {
  repository      = ${{ secrets.REPO_NAME }}
  secret_name     = "EC2_HOST"
  plaintext_value = aws_instance.ubuntu_instance.public_ip