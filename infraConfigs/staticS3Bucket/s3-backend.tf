terraform {
  backend "s3" {
    bucket         = "terraformstatestore.vjmourya"
    key            = "terraform-modules/statics3bucket/tfstate"
    region         = "ap-south-1"
    profile        = "for_aws_3"
    dynamodb_table = "terraformstatestore"
  }
}
