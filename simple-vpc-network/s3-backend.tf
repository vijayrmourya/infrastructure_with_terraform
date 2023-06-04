terraform {
  backend "s3" {
    bucket         = "terraformstatestore.vjmourya"
    key            = "simple-vpc-network/statestorefile"
    region         = "ap-south-1"
    profile        = "for_aws_3"
    dynamodb_table = "terraformstatestore"
  }
}
