# y-so-cereal — AWS ECS Secure Deployment with GitHub Actions OIDC

GitHub Actions OIDC를 활용한 AWS ECS Fargate 배포 인프라입니다.  
Access Key 없이 단기 토큰으로 안전하게 AWS 리소스를 배포합니다.

## 아키텍처

```
GitHub Actions
    │
    │ OIDC (단기 토큰)
    ▼
AWS IAM Role (AssumeRoleWithWebIdentity)
    │
    ├── ECR (이미지 푸시)
    ├── ECS (서비스 업데이트)
    └── S3 / DynamoDB (Terraform 상태)

인프라 구성:
VPC → Public Subnet (ALB) → Private Subnet (ECS Fargate)
```

## 사전 준비

### 1. Terraform 상태 저장용 S3 버킷 & DynamoDB 테이블 생성

```bash
# S3 버킷 생성
aws s3api create-bucket \
  --bucket your-tfstate-bucket-name \
  --region ap-northeast-2 \
  --create-bucket-configuration LocationConstraint=ap-northeast-2

# 버킷 버저닝 활성화
aws s3api put-bucket-versioning \
  --bucket your-tfstate-bucket-name \
  --versioning-configuration Status=Enabled

# DynamoDB 락 테이블 생성
aws dynamodb create-table \
  --table-name terraform-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-northeast-2
```

### 2. backend.tf 수정

`backend.tf`의 `bucket` 값을 실제 버킷 이름으로 변경하세요.

### 3. GitHub Secrets 설정

Terraform apply 후 출력되는 `github_actions_role_arn` 값을 GitHub Secrets에 등록합니다.

```
Settings → Secrets and variables → Actions → New repository secret
Name: AWS_ROLE_ARN
Value: arn:aws:iam::123456789012:role/y-so-cereal-dev-github-actions-role
```

## 배포 방법

### 최초 인프라 구성

```bash
# dev 환경
terraform init
terraform plan -var-file=environments/dev/terraform.tfvars
terraform apply -var-file=environments/dev/terraform.tfvars
```

### GitHub Actions 자동 배포

- **PR 생성** → Terraform Plan 결과가 PR 코멘트로 자동 등록
- **main 브랜치 push (`.tf` 파일 변경)** → Terraform Apply 자동 실행
- **main 브랜치 push (앱 코드 변경)** → Docker 빌드 → ECR 푸시 → ECS 배포

## 보안 포인트

| 항목 | 내용 |
|------|------|
| OIDC 인증 | Access Key 없이 단기 토큰으로 AWS 인증 |
| 최소 권한 | GitHub Actions Role은 ECS/ECR/S3/DynamoDB만 허용 |
| Private Subnet | ECS Task는 외부 직접 접근 불가, ALB 통해서만 트래픽 수신 |
| 이미지 스캔 | ECR push 시 자동 취약점 스캔 |
| 읽기 전용 FS | 컨테이너 루트 파일시스템 읽기 전용 설정 |
| 자동 롤백 | 배포 실패 시 ECS Circuit Breaker로 자동 롤백 |
| SSM 시크릿 | 환경변수 대신 SSM Parameter Store 사용 권장 |
