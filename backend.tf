terraform {
  backend "s3" {
    bucket         = "your-tfstate-bucket-name"   # 실제 버킷 이름으로 변경
    key            = "terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"             # DynamoDB 락 테이블
  }
}
