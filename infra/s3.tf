resource "aws_s3_bucket" "image_reg_website" {
  bucket = "image-rekognition-website-demo"
}

resource "aws_s3_bucket" "image_reg_storage" {
  bucket = "image-rekognition-storage-demo"
}

resource "aws_s3_bucket" "image_reg_states" {
  bucket = "image-rekognition-states-demo"
}

resource "aws_s3_bucket_acl" "image_reg_website_acl" {
  bucket = aws_s3_bucket.image_reg_website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "image_reg_website" {
  bucket = aws_s3_bucket.image_reg_website.id
  policy = data.aws_iam_policy_document.s3_static_host.json
}

resource "aws_s3_bucket_website_configuration" "image_reg_website_config" {
  bucket = aws_s3_bucket.image_reg_website.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}