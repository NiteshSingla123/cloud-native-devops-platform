resource "aws_iam_policy" "terraform_ec2_policy" {
  name        = "nitesh-terraform-ec2-policy"
  description = "Policy allowing EC2 basic operations"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:RunInstances",
          "ec2:TerminateInstances"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role" "ec2_role" {
  name = "nitesh-ec2-devops-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attach" {
  role       =  aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.terraform_ec2_policy.arn
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "nitesh-ec2-devops-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "nitesh-devops-project-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.devops_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "nitesh-devops-public-subnet"
  }
}

resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "nitesh-devops-internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.devops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_igw.id
  }

  tags = {
    Name = "nitesh-devops-public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "devops_sg" {
  name        = "nitesh-devops-security-group"
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_vpc.devops_vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
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
    Name = "devops-security-group"
  }
}

resource "aws_instance" "devops_server" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  associate_public_ip_address = true
  key_name = aws_key_pair.nitesh_devops_key.key_name

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "nitesh-devops-ec2-server"
  }
}

resource "aws_key_pair" "nitesh_devops_key" {
  key_name   = "nitesh-devops-key"
  public_key = file("${path.module}/../../nitesh-devops-key.pub")

  tags = {
    Name = "nitesh-devops-key"
  }
}

resource "aws_eip" "devops_eip" {
  domain = "vpc"

  tags = {
    Name = "nitesh-devops-elastic-ip"
  }
}

resource "aws_eip_association" "devops_eip_assoc" {
  instance_id   = aws_instance.devops_server.id
  allocation_id = aws_eip.devops_eip.id
}

