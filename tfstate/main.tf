# This bucket needs to be created once only.
resource "aws_s3_bucket" "remote_tfstate_bucket" {
  bucket = "ties4560-tfstate-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
