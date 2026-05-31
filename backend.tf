terraform {
  backend "s3" {
    bucket       = "y-so-cereal-tfstate-ap-northeast-2" # Step 1에서 만든 버킷 이름
    key          = "terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true # dynamodb_table 대신 S3 네이티브 락 사용 (AWS provider 6.x)
  }
}
