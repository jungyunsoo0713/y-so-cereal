provider "aws" {
  region = "ap-northeast-2" # 서울 리전
}

locals {
  # 띄워야 할 핵심 마이크로서비스 목록 (필요시 더 추가해!)
  services = ["ui", "catalog", "cart", "orders", "checkout"]
  vpc_cidr = "10.0.0.0/16"
}

# --------------------------------------------------
# 1. VPC & 네트워크 (빠른 통신을 위해 전부 Public Subnet)
# --------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "retail-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(local.vpc_cidr, 8, count.index)
  availability_zone       = element(["ap-northeast-2a", "ap-northeast-2c"], count.index)
  map_public_ip_on_launch = true # 컨테이너에 Public IP 자동 할당 (NAT Gateway 비용/시간 절약)
  tags = { Name = "retail-public-subnet-${count.index + 1}" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# --------------------------------------------------
# 2. 공통 보안 그룹 (개판 오분전 룰 적용: 내부 완전 개방)
# --------------------------------------------------
resource "aws_security_group" "ecs_sg" {
  name        = "retail-ecs-sg"
  description = "Allow internal traffic and outbound"
  vpc_id      = aws_vpc.main.id

  # 자기 자신(같은 SG를 가진 서비스)끼리는 모든 포트 통신 허용 (핵심!)
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true 
  }
  
  # UI 접속을 위한 80포트 오픈
  ingress {
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
}

# --------------------------------------------------
# 3. ECS 클러스터 & Cloud Map (마이크로서비스용 내비게이션)
# --------------------------------------------------
resource "aws_ecs_cluster" "main" {
  name = "retail-cluster"
}

# 각 서비스가 "http://catalog.retail.local" 처럼 통신할 수 있게 해줌
resource "aws_service_discovery_private_dns_namespace" "internal" {
  name        = "retail.local"
  description = "Service discovery for retail sample app"
  vpc         = aws_vpc.main.id
}

# --------------------------------------------------
# 4. ECR 저장소 (for_each로 한 방에 찍어내기)
# --------------------------------------------------
resource "aws_ecr_repository" "services" {
  for_each             = toset(local.services)
  name                 = "retail-${each.key}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true # 이미지가 있어도 강제 삭제되도록 올바른 속성으로 수정!
}