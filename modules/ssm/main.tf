# SSM Parameter Store - 서비스별 공통 환경변수 및 시크릿 관리
# 실제 값은 로컬에서 직접 등록하거나 terraform.tfvars로 관리
# GitHub Actions나 tfstate에 평문 시크릿이 남지 않도록 주의

locals {
  # 서비스별 기본 파라미터 경로: /{project}/{env}/{service}/{key}
  base_path = "/${var.project_name}/${var.environment}"
}

# 앱 공통 파라미터 (평문)
resource "aws_ssm_parameter" "app_env" {
  for_each = var.app_parameters

  name  = "${local.base_path}/${each.key}"
  type  = "String"
  value = each.value

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 앱 시크릿 (암호화)
resource "aws_ssm_parameter" "app_secrets" {
  for_each = var.app_secrets

  name   = "${local.base_path}/${each.key}"
  type   = "SecureString"
  value  = each.value
  key_id = "alias/aws/ssm" # AWS 관리형 KMS 키 사용

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  lifecycle {
    ignore_changes = [value] # 값은 콘솔/CLI로 직접 관리, Terraform이 덮어쓰지 않도록
  }
}
