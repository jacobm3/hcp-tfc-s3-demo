provider "vault" {
  # It is strongly recommended to configure this provider through the
  # environment variables described above, so that each user can have
  # separate credentials set in the environment.
  #
  # This will default to using $VAULT_ADDR
  # But can be set explicitly
  # address = "https://vault.example.net:8200"
}

data "vault_generic_secret" "aws" {
  path = "aws/creds/s3-sts-role"
}

provider "aws" {
  region     = "us-east-1"
  access_key = data.vault_generic_secret.aws.data.access_key
  secret_key = data.vault_generic_secret.aws.data.secret_key
  token = data.vault_generic_secret.aws.data.security_token
}

resource "random_string" "random" {
  length = 16
  special = false
  upper = false
}

resource "aws_s3_bucket" "website_bucket" {
  force_destroy = true
  bucket = "jacobm-${random_string.random.result}"
  acl    = "public-read"
  
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  versioning {
    enabled = true
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::jacobm-${random_string.random.result}/*"
        }
    ]
}
POLICY


  tags = {
    owner = "jmartinson@hashicorp.com"
  }
}
