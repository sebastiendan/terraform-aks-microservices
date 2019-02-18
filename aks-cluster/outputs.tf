output "id" {
  value = "${azurerm_kubernetes_cluster.cluster.id}"
}

output "client_key" {
  value = "${azurerm_kubernetes_cluster.cluster.kube_config.0.client_key}"
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.cluster.kube_config_raw}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.cluster.kube_config.0.host}"
}

output "configure" {
  value = <<CONFIGURE
    $ terraform output kube_config > ~/.kube/aksconfig
    $ export KUBECONFIG=~/.kube/aksconfig
    $ kubectl get nodes
  CONFIGURE
}
