# create an S3 bucket to store the state file in

resource "aws_s3_bucket" "fooji-s3-log-bucket" {
  bucket = "fooji-s3-log-bucket"
  acl = "log-delivery-write"

}

resource "aws_s3_bucket" "foojis3-tf-log-bucket" {
  bucket = "foojis3-tf-log-bucket"
  acl = "log-delivery-write"
  policy = file("policy.json")
  force_destroy = true

  logging {
    target_bucket = aws_s3_bucket.fooji-s3-log-bucket.bucket
    target_prefix = "tf-log/"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "foojis3bucket" {
  bucket = "foojis3bucket"
  acl = "private"
  force_destroy = true

  logging {
    target_bucket = aws_s3_bucket.fooji-s3-log-bucket.bucket
    target_prefix = "log/"
  }
}

resource "aws_s3_bucket" "fooji-s3-alb-logs" {
  bucket = "fooji-s3-alb-logs"
  acl = "log-delivery-write"
  policy = file("s3-policy-lb.json")
  force_destroy = true
  versioning {
    enabled = true
  }
  logging {
    target_bucket = aws_s3_bucket.fooji-s3-log-bucket.id
    target_prefix = "log/"
  }
}