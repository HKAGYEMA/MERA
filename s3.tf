resource "aws_s3_bucket" "html_bucket" {
  bucket = "dynamic-string-html-bucket"
  force_destroy = true  # Allows Terraform to delete the bucket if needed
}

# Explicitly Disable BlockPublicPolicy
resource "aws_s3_bucket_public_access_block" "html_bucket" {
  bucket = aws_s3_bucket.html_bucket.id

  block_public_acls       = false  # Allow public ACLs
  block_public_policy     = false  # Allow public policies
  ignore_public_acls      = false  # Do not ignore public ACLs
  restrict_public_buckets = false  # Allow unrestricted public buckets
}

# Explicit Dependency to Ensure Public Access Block is Applied First
resource "aws_s3_bucket_policy" "html_bucket_policy" {
  bucket = aws_s3_bucket.html_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.html_bucket.arn}/*"
        Principal = "*"
      }
    ]
  })

  # Ensure that public access block is applied before the policy
  depends_on = [aws_s3_bucket_public_access_block.html_bucket]
}
