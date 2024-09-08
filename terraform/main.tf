provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::101687857920:role/pytheas-terraform-upload"
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "chatyqg.ca"
}

locals {
  content_types = {
    "html" = "text/html",
    "js"   = "application/javascript",
    "css"  = "text/css",
    "json" = "application/json",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "gif"  = "image/gif",
    "svg"  = "image/svg+xml",
    "ico"  = "image/x-icon",
  }
  files = jsondecode(data.external.dist_files.result["files"])
}

data "external" "dist_files" {
  program = ["python3", "${path.module}/list_files.py"]
}

resource "aws_s3_object" "build_files" {
  for_each = toset(local.files)

  bucket = aws_s3_bucket.my_bucket.id
  key    = each.value
  source = "${path.module}/../dist/${each.value}"
  etag   = filemd5("${path.module}/../dist/${each.value}")

  content_type = lookup(
    local.content_types,
    split(".", each.value)[length(split(".", each.value)) - 1],
    "application/octet-stream"
  )
}
