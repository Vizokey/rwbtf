terraform {
  backend "s3" {
    bucket         = "elbtestfilestf"
    key            = "elbtestfilestf/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}