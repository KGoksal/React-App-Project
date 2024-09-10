
# React.js App Deployment on AWS ECS Fargate & GitLab CI/CD

This repository contains Terraform configurations to deploy a React.js application on AWS ECS Fargate. It also includes Terraform scripts for setting up a GitLab server on an EC2 instance for CI/CD workflows.

## Table of Contents
- [Requirements](#requirements)
- [Infrastructure Overview](#infrastructure-overview)
- [Terraform Files](#terraform-files)
- [Docker File](#docker-file)
- [GitLab Server Deployment](#gitlab-server-deployment)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Requirements

- AWS account with programmatic access
- Terraform installed
- Docker installed locally for building the React.js app image
- Node.js 18.x (used in the Docker container)

## Infrastructure Overview

This repository creates the following infrastructure on AWS:

1. **Amazon ECS (Elastic Container Service) Fargate**: Hosts the React.js application in a serverless environment.
2. **Elastic Load Balancer (ALB)**: Distributes incoming traffic to the ECS tasks.
3. **Amazon ECR (Elastic Container Registry)**: Stores the Docker images for the React.js app.
4. **GitLab CI/CD Server**: Set up on an EC2 instance, used for managing version control and pipelines for deployment.

## Terraform Files

### AWS ECS Fargate Deployment (`main.tf`)

This Terraform script provisions the following:
- A new VPC, subnet, and internet gateway for networking.
- An ECS cluster that hosts a React.js app on Fargate.
- A load balancer (ALB) to handle external traffic.
- IAM roles for ECS task execution.
- A security group that allows HTTP traffic.

```hcl
provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-cluster"
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "my-react-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode([{
    name      = "my-react-app"
    image     = "<ECR_REPOSITORY_URL>:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

# Additional resources include ALB, security groups, IAM roles, etc.
```

### Key Components
- **VPC & Subnets**: For networking.
- **ECS Cluster**: Manages containerized apps.
- **IAM Roles**: Provides the required permissions to the ECS tasks.
- **ALB & Target Group**: Ensures that the traffic is routed to the running containers.

## Docker File

The `Dockerfile` used for the React.js application is as follows:

```dockerfile
# Use Node.js base image
FROM node:18-alpine

# Set working directory
WORKDIR /create-react-app  

# Copy the required files
COPY public/ /create-react-app/public
COPY src/ /create-react-app/src 
COPY package.json /create-react-app/

# Install dependencies
RUN npm install 

# Copy the rest of the application
COPY . .

# Command to run the application
CMD ["npm", "start"]
```

This Docker file sets up a React.js app, installs the dependencies, and runs the application. You can build the Docker image and push it to an AWS ECR repository for deployment.

## GitLab Server Deployment

The following Terraform script creates a GitLab server running on an AWS EC2 instance. The server is configured with the following:
- Docker and Docker Compose
- Git
- AWS CLI
- Python 3, Ansible, Terraform, and Boto3

### GitLab Terraform Script (`gitlab.tf`)

```hcl
provider "aws" {
  region = var.region
}

resource "aws_instance" "tf-GitLab-server" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.mykey
  vpc_security_group_ids = [aws_security_group.tf-GitLab-sec.id]
  iam_instance_profile = aws_iam_instance_profile.tf-GitLab-server-profile.name
  root_block_device {
    volume_size = 16
  }
  tags = {
    Name = var.GitLab-server-tag
    server = "GitLab"
  }
  user_data = file("user.sh")
}

resource "aws_security_group" "tf-GitLab-sec" {
  name = var.GitLab_server_sec
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "tf-GitLab-server-role" {
  name = var.GitLab-role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", 
    "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess", 
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}

output "GitLabURL" {
  value = "http://${aws_instance.tf-GitLab-server.public_dns}:8080"
}
```

### Usage:

1. **Build the Docker Image:**
   ```bash
   docker build -t my-react-app .
   docker tag my-react-app:latest <ECR_REPOSITORY_URL>:latest
   docker push <ECR_REPOSITORY_URL>:latest
   ```

2. **Deploy with Terraform:**
   ```bash
   terraform init
   terraform apply
   ```

3. **Access the GitLab Server:**
   - Visit the URL from the output of the `GitLabURL`.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes.

