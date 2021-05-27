output "website_bucket_id" {
  description = "This is actually the bucket name. Discussion here - https://github.com/hashicorp/terraform/issues/9845"
  value = "${aws_s3_bucket.website_bucket.id}"
}

output "bucket_domain_name" {
  value = "${aws_s3_bucket.website_bucket.bucket_domain_name}"
}

output "bucket_arn" {
  value = "${aws_s3_bucket.website_bucket.arn}"
}

output "website_endpoint" {
  value = "${aws_s3_bucket.website_bucket.website_endpoint}"
}
