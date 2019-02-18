output "external_ip" {
	description   = "Traefik service external ip"
	depends_on    = ["kubernetes_service.service"]
	value         = "${kubernetes_service.service.load_balancer_ingress.0.ip}"
}