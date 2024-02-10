# Static Website Deployment with AWS S3 and Terraform

This repository contains Terraform code to deploy a static website to an AWS S3 bucket. The Terraform configuration includes setting up the S3 bucket for website hosting, enabling versioning, configuring ACLs, and defining the index and error documents.

## Prerequisites

Before getting started, ensure you have the following prerequisites:

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- An AWS account with appropriate permissions to create resources.

## Usage

1. Clone this repository to your local machine:

```bash
git clone https://github.com/your-username/your-repository.git
```

# Terraform Configuration
```
resource "aws_s3_bucket" "s3-static-website" {
  bucket = var.bucket-name
  tags = {
    website = "ShantayyaSwami.in"
  }
}
```
This block creates an S3 bucket for hosting the static website with the specified bucket name. It also adds a tag to the bucket indicating that it's for the website "ShantayyaSwami.in".

```
resource "aws_s3_bucket_public_access_block" "s3-static-website" {
  bucket                  = aws_s3_bucket.s3-static-website.id
  block_public_acls       = "false"
  ignore_public_acls      = "false"
  block_public_policy     = "false"
  restrict_public_buckets = "false"
}
```
This block configures the S3 bucket to block public access settings. By setting all options to "false", it ensures that public access is not restricted by ACLs, bucket policies, or bucket-level public access settings.

```
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3-static-website.id
  versioning_configuration {
    status = "Enabled"
  }
}
```
This block enables versioning for the S3 bucket, which allows you to keep multiple versions of objects in the bucket. It ensures that changes to objects are tracked and can be restored if needed.

```
resource "aws_s3_bucket_acl" "s3-static-website" {
  depends_on = [
    aws_s3_bucket_public_access_block.s3-static-website
  ]
  bucket = aws_s3_bucket.s3-static-website.id
  acl    = "public-read"
}
```
 This block sets a public-read ACL for the S3 bucket, allowing objects in the bucket to be publicly accessible. It depends on the completion of the public access block configuration.

 ```
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
```
These blocks upload the index.html and error.html files to the S3 bucket. They specify the content type as text/html and set the ACL to public-read to make the files publicly accessible.

```
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
```
This block configures the S3 bucket for website hosting, specifying the index and error documents. It depends on the completion of the ACL configuration to ensure that the website configuration is applied after public-read access is granted.




