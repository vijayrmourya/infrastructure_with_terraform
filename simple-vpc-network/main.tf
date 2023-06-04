module "website_s3_bucket" {
  source = "../../terraform-modules/s3-static-website-module"
  #  refer: https://github.com/vijayrmourya/terraform-modules

  bucket_name = var.bucket_name

  tags = {
    Terraform   = "true"
    Environment = "devModule"
  }
}
