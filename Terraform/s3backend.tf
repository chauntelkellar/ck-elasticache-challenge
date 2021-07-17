resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-acgappperf"
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

terraform {
  backend "s3" {
    bucket  = "terraform-state-acgappperf"
    region  = "us-east-1"
    key     = "global/s3/terraform.tfstate"
    encrypt = true
  }
}