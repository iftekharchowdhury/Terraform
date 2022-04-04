# create bucket
resource "aws_s3_bucket" "test" {
  
  bucket = "iftekhar-test-bucket"
  # acl    = "private"
  
  tags={
    Name = "My first bucket"
    Environment = "Dev"
  }
}

// server side encryption
resource "aws_kms_key" "iftekhar-key"{

  description = "iftekhar-key"
  deletion_window_in_days = 7

}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.test.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.iftekhar-key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# How to upload a simple file to S3
# source - file location

resource "aws_s3_bucket_object" "object" {

  bucket = aws_s3_bucket.test.bucket 
  key    = "test-object"
  acl = "private"
  source = "testfile.txt"
  etag = filemd5("testfile.txt")
  content_type = "text/plain"

}
