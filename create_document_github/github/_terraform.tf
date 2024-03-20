#-----------------------------------------------------------------------------------------------------------------------
# Terraform Backend
#-----------------------------------------------------------------------------------------------------------------------
terraform {
  backend "s3" {
    bucket         = "create-document-terraform"
    key            = "github/create_document_github/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "create-document-terraform"
  }
}
