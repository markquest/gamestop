#create back up or tfstate.backend
terraform {
  backend "s3" {
    bucket = "gamestop-bucket"
    key = "gamestop-bucket.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform_state_lock"
    encrypt = true
  }
}

## creating dynamoDB for tfstate file locking

resource "aws_dynamodb_table" "terraform_state_lock" {
  name    = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

