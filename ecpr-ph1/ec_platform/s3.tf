# set up aws S3 
resource "aws_s3_bucket" "pactera-ecplatform-website" {
  bucket = "pactera-ecplatform-website"
  acl    = "public-read"
}
