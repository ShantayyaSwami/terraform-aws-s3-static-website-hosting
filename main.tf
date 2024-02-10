resource "aws_s3_bucket" "s3-static-website" {
  bucket = var.bucket-name
  tags = {
    website = "ShantayyaSwami.in"
  }
}

resource "aws_s3_bucket_public_access_block" "s3-static-website" {
  bucket                  = aws_s3_bucket.s3-static-website.id
  block_public_acls       = "false"
  ignore_public_acls      = "false"
  block_public_policy     = "false"
  restrict_public_buckets = "false"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3-static-website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "s3-static-website" {
  depends_on = [
    aws_s3_bucket_public_access_block.s3-static-website
  ]
  bucket = aws_s3_bucket.s3-static-website.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  depends_on   = [aws_s3_bucket_versioning.versioning]
  bucket       = aws_s3_bucket.s3-static-website.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  acl          = "public-read"
}

resource "aws_s3_object" "error" {
  depends_on   = [aws_s3_bucket_versioning.versioning]
  bucket       = aws_s3_bucket.s3-static-website.id
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
  acl          = "public-read"
}

resource "aws_s3_bucket_website_configuration" "s3-static-website" {
  bucket = aws_s3_bucket.s3-static-website.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
    depends_on = [aws_s3_bucket_acl.s3-static-website]
}

# resource "aws_s3_bucket_policy" "public_read_access" {
#   bucket = aws_s3_bucket.s3-static-website.id
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
# 	  "Principal": "*",
#       "Action": [ "s3:GetObject" ],
#       "Resource": [
#         "${aws_s3_bucket.s3-static-website.arn}",
#         "${aws_s3_bucket.s3-static-website.arn}/*"
#       ]
#     }
#   ]
# }
# EOF
# }

