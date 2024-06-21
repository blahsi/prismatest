# Configure the AWS provider
provider "aws" {
  region = "us-west-2"  # Specify your desired region
}

# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "buckettest"  # Replace with your bucket name
  acl    = "private"  # Default ACL, you can adjust as needed

  tags = {
    Name        = "MyS3Bucket"
    Environment = "Dev"
  }
}

# Define an IAM policy allowing access to the S3 bucket
resource "aws_iam_policy" "s3_bucket_policy" {
  name        = "S3BucketAccessPolicy"
  description = "IAM policy to allow access to S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:ListBucket"]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.my_bucket.arn}"
      },
      {
        Action   = ["s3:GetObject", "s3:PutObject"]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.my_bucket.arn}/*"
      }
    ]
  })
}

# Apply a bucket policy to the S3 bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["${aws_s3_bucket.my_bucket.arn}/*"]
        Condition = {
          StringEquals = {
            "aws:Referer" = ["http://example.com"]
          }
        }
      },
      {
        Effect    = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::ACCOUNT_ID:role/SOME_ROLE",
            "arn:aws:iam::ACCOUNT_ID:role/ANOTHER_ROLE"
          ]
        }
        Action    = ["s3:PutObject"]
        Resource  = ["${aws_s3_bucket.my_bucket.arn}/*"]
      }
    ]
  })
}
