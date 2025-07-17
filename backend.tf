terraform {
  backend "s3" {
    bucket         = "terraform-state-youssef"
    key            = "webapp/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
