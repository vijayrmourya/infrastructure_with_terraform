# Provider Block
provider "aws" {
  profile = module.globalSettings.aws_user_profile
  region  = module.globalSettings.aws_default_region
}

module "globalSettings" {
  source = "../../localModules/global-settings/"
}
