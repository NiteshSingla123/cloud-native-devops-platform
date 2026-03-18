# ==========================================================
# IAM POLICY
# Defines permissions that allow EC2 instances to perform
# basic EC2 operations such as launching and terminating
# instances.
# ==========================================================

resource "aws_iam_policy" "terraform_ec2_policy" {

  name        = "nitesh-terraform-ec2-policy"
  description = "Policy allowing EC2 basic operations"

  # JSON policy defining allowed EC2 actions
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"

        # Allow EC2 read operations and instance lifecycle actions
        Action = [
          "ec2:Describe*",
          "ec2:RunInstances",
          "ec2:TerminateInstances"
        ]

        # Applies to all resources
        Resource = "*"
      }
    ]
  })
}

# ==========================================================
# IAM ROLE
# This role will be assumed by the EC2 instance so it can
# interact with AWS services securely without storing
# credentials on the server.
# ==========================================================

resource "aws_iam_role" "ec2_role" {

  name = "nitesh-ec2-devops-role"

  # Trust relationship allowing EC2 service to assume the role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"

        # EC2 service is allowed to assume this role
        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

# ==========================================================
# IAM ROLE POLICY ATTACHMENT
# Attaches the previously defined IAM policy to the EC2 role
# ==========================================================

resource "aws_iam_role_policy_attachment" "ec2_policy_attach" {

  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.terraform_ec2_policy.arn
}

# ==========================================================
# INSTANCE PROFILE
# EC2 instances cannot directly use IAM roles.
# Instance profile acts as a container for the role.
# ==========================================================

resource "aws_iam_instance_profile" "ec2_profile" {

  name = "nitesh-ec2-devops-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# ==========================================================
# VPC (Virtual Private Cloud)
# Creates an isolated network for the DevOps platform.
# ==========================================================

resource "aws_vpc" "devops_vpc" {

  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "nitesh-devops-project-vpc"
  }
}

# ==========================================================
# PUBLIC SUBNET
# Subnet inside the VPC where the EC2 instance will run.
# ==========================================================

resource "aws_subnet" "public_subnet" {

  vpc_id     = aws_vpc.devops_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "nitesh-devops-public-subnet"
  }
}

# ==========================================================
# INTERNET GATEWAY
# Allows resources in the VPC to access the internet.
# ==========================================================

resource "aws_internet_gateway" "devops_igw" {

  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "nitesh-devops-internet-gateway"
  }
}

# ==========================================================
# ROUTE TABLE
# Defines routing rules for the public subnet.
# Traffic destined for the internet will go through
# the Internet Gateway.
# ==========================================================

resource "aws_route_table" "public_route_table" {

  vpc_id = aws_vpc.devops_vpc.id

  route {

    # Default route for internet traffic
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.devops_igw.id
  }

  tags = {
    Name = "nitesh-devops-public-route-table"
  }
}

# ==========================================================
# ROUTE TABLE ASSOCIATION
# Associates the public subnet with the public route table.
# ==========================================================

resource "aws_route_table_association" "public_subnet_association" {

  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# ==========================================================
# SECURITY GROUP
# Acts as a virtual firewall for the EC2 instance.
# Allows SSH access and HTTP traffic.
# ==========================================================

resource "aws_security_group" "devops_sg" {

  name        = "nitesh-devops-security-group"
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_vpc.devops_vpc.id

  # SSH access for remote server management
  ingress {

    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access for web traffic
  ingress {

    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
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

# ==========================================================
# EC2 INSTANCE
# This server will host the containerized DevOps platform.
# Docker, Git, and other tools will be installed using
# the user_data bootstrap script.
# ==========================================================

resource "aws_instance" "devops_server" {

  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  # Launch instance inside public subnet
  subnet_id = aws_subnet.public_subnet.id

  # Attach security group
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  # Attach IAM role via instance profile
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # Assign public IP for internet access
  associate_public_ip_address = true

  # SSH key pair for login
  key_name = aws_key_pair.nitesh_devops_key.key_name

  # Bootstrapping script to install Docker and tools
  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "nitesh-devops-ec2-server"
  }
}

# ==========================================================
# SSH KEY PAIR
# Uploads local public key to AWS so we can SSH into EC2.
# ==========================================================

resource "aws_key_pair" "nitesh_devops_key" {

  key_name   = "nitesh-devops-key"
  public_key = file("${path.module}/../../nitesh-devops-key.pub")

  tags = {
    Name = "nitesh-devops-key"
  }
}

# ==========================================================
# ELASTIC IP
# Provides a static public IP for the EC2 instance.
# Useful for DNS mapping and stable deployments.
# ==========================================================

resource "aws_eip" "devops_eip" {

  domain = "vpc"

  tags = {
    Name = "nitesh-devops-elastic-ip"
  }
}

# ==========================================================
# ELASTIC IP ASSOCIATION
# Attaches the Elastic IP to the EC2 instance.
# ==========================================================

resource "aws_eip_association" "devops_eip_assoc" {

  instance_id   = aws_instance.devops_server.id
  allocation_id = aws_eip.devops_eip.id
}