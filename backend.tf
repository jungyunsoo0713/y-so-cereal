terraform {
  backend "s3" {
    bucket  = "y-so-cereal-tfstate-ap-northeast-2"
    key     = "terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
