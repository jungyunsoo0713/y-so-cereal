# 사용할 Provider와 버전 정의
# Provider란 테라폼 코드를 실제 클라우드 서비스가 알아 들을 수 있는 명령어로 바꿔주는 매개체
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Provider 세부 설정 (리전 등)
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
