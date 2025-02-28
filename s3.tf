resource "aws_s3_bucket" "html_bucket" {
  bucket = "dynamic-string-html-bucket"
}

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
}
