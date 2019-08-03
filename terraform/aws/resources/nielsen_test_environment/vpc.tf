#####################################################################
#
#                        NIELSEN VPC
#
#####################################################################
#terraform {
#  backend "s3" {
    # Terraform does not support interpolation on backend object
    # dynamodb_table = "REPLACE_TF_STATE_DYNAMO_DB_TABLE"
#    bucket         = "bucket name"
#    key            = "tf state key"
#    region         = "region"
#    profile        = "aws profile"
#  }
#}

module "nielsen_vpc" {
  source = "../modules/"

  #
  # S3
  #

  aws_secret_key = "REPLACE"
  aws_access_key = "REPLACE"
  region = "us-west-2"

}