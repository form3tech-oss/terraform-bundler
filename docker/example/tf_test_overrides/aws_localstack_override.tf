provider "aws" {
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  endpoints {
    s3  = "http://localstack:4572"
    sns = "http://localstack:4575"
    sqs = "http://localstack:4576"
    iam = "http://localstack:4593"
    sts = "http://localstack:4592"
  }
}
