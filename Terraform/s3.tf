resource "aws_s3_bucket" "app_bucket" {
  bucket = "ror-app-bucket-${random_id.bucket_id.hex}"
  force_destroy = true
}

resource "random_id" "bucket_id" {
  byte_length = 4
}
