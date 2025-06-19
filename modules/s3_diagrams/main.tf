resource "aws_s3_bucket" "diagrams" {
  bucket = "securemyweb-diagrams-${random_id.suffix.hex}"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "securemyweb-diagrams"
    Env  = "dev"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

