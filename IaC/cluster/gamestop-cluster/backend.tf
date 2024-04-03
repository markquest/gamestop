# backend resource for storing terraform state file
#in a S3 bucket

terraform {
  backend "s3" {
    bucket = "gamestop-bucket"
    key = "gamestop-bucket.tfstate"
    region = "us-east-1"
  }
}