terraform {
  backend "s3" {
    bucket         = "terraformstatestore.vjmourya"
    key            = "aws-serverless-terraform/http-api-with-lambda/simplestate"
    region         = "ap-south-1"
    profile        = "for_aws_3"
    dynamodb_table = "terraformstatestore"
  }
}
