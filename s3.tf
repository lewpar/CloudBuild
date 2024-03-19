# CloudBuild S3 Bucket
resource "aws_s3_bucket" "this" {
    bucket = "cloudbuild-s3-bucket"

    force_destroy = true # Destroy any objects when the bucket is destroyed.

    tags = {
        Name = "cloudbuild-s3-bucket"
    }
}

# CloudBuild S3 Bucket Public Access Block
# Leaving this empty will set the S3 bucket to use: 
# "Bucket owner enforced (default)" object ownership settings.
resource "aws_s3_bucket_public_access_block" "cloudbuild-s3-bucket-public-access-block" {
    bucket = aws_s3_bucket.this.id
}

resource "aws_s3_bucket_policy" "cloudbuild-s3-bucket-policy" {
    bucket = aws_s3_bucket.this.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Principal = "*"
                Action = [
                    "s3:GetObject"
                ]
                Effect = "Allow"
                Resource = [
                    "${aws_s3_bucket.this.arn}",
                    "${aws_s3_bucket.this.arn}/*"
                ]
            }
        ]
    })

    depends_on = [ aws_s3_bucket_public_access_block.cloudbuild-s3-bucket-public-access-block ]
}