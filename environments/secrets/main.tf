# SSM Secrets 관리 - 로컬에서만 실행 (GitHub Actions 제외)
# 사용법: cd environments/secrets && terraform init && terraform apply

module "ssm" {
  source = "../../modules/ssm"

  project_name = var.project_name
  environment  = var.environment

  app_parameters = {
    "common/APP_ENV"    = var.environment
    "common/AWS_REGION" = var.aws_region
  }

  # 시크릿은 terraform.tfvars에서 관리 (절대 커밋 금지)
  app_secrets = var.app_secrets
}
