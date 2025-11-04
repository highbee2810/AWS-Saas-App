provider "aws" {
  region = "us-east-2"
}
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "Saas_VPC"
    }
}
resource "aws_subnet" "public_subnet1" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr_1
availability_zone = "us-east-2a"
  tags = {
    Name = " first Public_Subnet"
  }
  map_public_ip_on_launch = true
}
resource "aws_subnet" "public_subnet2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr_2
availability_zone = "us-east-2b"
  tags = {
    Name = " second Public_Subnet"
  }
  map_public_ip_on_launch = true
}
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr1
availability_zone = "us-east-2a"
  tags = {
    Name = " first Private_Subnet"
  }
  
}
resource "aws_subnet" "private2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr2
availability_zone = "us-east-2b"
  tags = {
    Name = " second Private_Subnet"
  }
}
# creating internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Saas_IGW"
  }
}
# crating Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "Saas_NAT_EIP"
  }
}
# creating NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "Saas_NAT_GW"
  }
}
# creating Public Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Saas_Public_RT"
  }
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
}
}
# associating Private Subnets with Public Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id 
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id 
}

#create a route table for public subnets
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Saas_Public_Subnet_RT"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
  # associate public subnets with this route table
  resource "aws_route_table_association" "public_subnet1_association" {
    subnet_id      = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.public_subnet_rt.id
  }
  resource "aws_route_table_association" "public_subnet2_association" {
    subnet_id      = aws_subnet.public_subnet2.id
    route_table_id = aws_route_table.public_subnet_rt.id
  }
  # creating security group
resource "aws_security_group" "ASG" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "Saas_Web_SG"
  }
}
# creation of IAM Role for Auto Scaling Group
resource "aws_iam_role" "asg_role" {
  name = "Saas_ASG_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_policy" "admin_policy" {
  name        = "AdminAccessPolicy"
  description = "Grants full administrative access"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_admin_policy" {
  role       = aws_iam_role.asg_role.name
  policy_arn = aws_iam_policy.admin_policy.arn
}
# creation of IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-service-role"

  # This policy allows the CodeBuild service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "codebuild-role"
  }
}
resource "aws_iam_policy" "codebuild_github_policy" {
  name        = "CodeBuildGitHubAccess"
  description = "Allows CodeBuild to access GitHub and interact with CodePipeline and CodeDeploy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # GitHub source access via CodePipeline
      {
        Effect = "Allow"
        Action = [
          "codepipeline:GetPipeline",
          "codepipeline:GetPipelineExecution",
          "codepipeline:StartPipelineExecution",
          "codepipeline:PollForJobs",
          "codepipeline:PutJobSuccessResult",
          "codepipeline:PutJobFailureResult",
          "codepipeline:AcknowledgeJob"
        ]
        Resource = "*"
      },
      # CodeBuild permissions to run builds triggered by CodePipeline
      {
        Effect = "Allow"
        Action = [
          "codebuild:BatchGetProjects",
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds",
          "codebuild:ListSourceCredentials"
        ]
        Resource = "*"
      },
      # GitHub OAuth credentials access
      {
        Effect = "Allow"
        Action = [
          "codebuild:ImportSourceCredentials",
          "codebuild:DeleteSourceCredentials"
        ]
        Resource = "*"
      },
      # CodeDeploy permissions for deployment
      {
        Effect = "Allow"
        Action = [
          "codedeploy:GetDeploymentConfig",
          "codedeploy:RegisterApplicationRevision",
          "codedeploy:CreateDeployment",
          "codedeploy:GetApplicationRevision",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentGroup"
        ]
        Resource = "*"
      },
      # Logging and monitoring
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "codebuild_custom_policy_attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_github_policy.arn
}