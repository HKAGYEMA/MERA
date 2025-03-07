resource "aws_s3_bucket" "html_bucket" {
  bucket = "dynamic-string-html-bucket"
  force_destroy = true  
}

# Explicitly Disable BlockPublicPolicy
resource "aws_s3_bucket_public_access_block" "html_bucket" {
  bucket = aws_s3_bucket.html_bucket.id

  block_public_acls       = false  
  block_public_policy     = false 
  ignore_public_acls      = false  
  restrict_public_buckets = false  
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
  depends_on = [aws_s3_bucket_public_access_block.html_bucket]
}
