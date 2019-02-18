provider "aws" {
}

terraform {
  # Remote backend definition
}

resource "aws_route53_record" "traefik" {
  zone_id = "${var.zone_id}"
  name    = "traefik.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = ["${var.external_ip}"]
}

resource "aws_route53_record" "api_gateway" {
  zone_id = "${var.zone_id}"
  name    = "api.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = ["${var.external_ip}"]
}