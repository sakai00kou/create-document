#-----------------------------------------------------------------------------------------------------------------------
# Terraform Backend
#-----------------------------------------------------------------------------------------------------------------------
terraform {
  backend "s3" {
    bucket         = "create-document-terraform"
    key            = "aws/create_document/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "create-document-terraform"
  }
}
