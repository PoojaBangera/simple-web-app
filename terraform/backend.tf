terraform {
  backend "s3" {
    encrypt = true
    bucket = "foojis3bucket"
    region = "us-east-1"
    key = "path/to/state/file"
  }
}