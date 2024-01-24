provider "aws" {
  region = "us-east-1"
}



module "stage1_module" {
  source = "./prod"
}
