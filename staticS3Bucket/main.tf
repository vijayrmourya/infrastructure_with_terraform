module "website_s3_bucket" {
  source = "../../localModules/s3-static-website-module"

  bucket_name = var.bucket_name

  tags = {
    Terraform   = "true"
    Environment = "devModule"
  }
}
