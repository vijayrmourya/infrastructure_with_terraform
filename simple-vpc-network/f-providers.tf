# Provider Block
provider "aws" {
  profile = module.global_setting.aws_user_profile
  region  = module.global_setting.aws_default_region
}

module "global_setting" {
  source = "../../terraform-modules/global-settings"
  #  refer: https://github.com/vijayrmourya/terraform-modules
}
