variable "domain" {
  description = "Domain name"
}

variable "public_ip" {
  description = "Traefik k8s lb service ip on AKS cluster"
}

variable "zone_id" {
  description = "AWS hosted zone id"
}