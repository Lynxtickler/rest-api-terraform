terraform {
  backend "s3" {
    bucket = "ties4560-tfstate-bucket"
    key    = "restapi.tfstate"
    region = "eu-north-1"
  }
}
