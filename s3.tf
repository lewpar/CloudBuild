resource "aws_s3_bucket" "this" {
    bucket = "cloudbuild-s3-bucket"
    
    force_destroy = true # Destroy any objects when the bucket is destroyed.

    tags = {
        Name = "cloudbuild-s3-bucket"
    }
}