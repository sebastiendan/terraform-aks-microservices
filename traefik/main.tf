provider "kubernetes" {
  alias = "kubernetes"
}

terraform {
  # Remote backend definition
}

resource "kubernetes_deployment" "deployment" {
  metadata {
    name = "traefik-ingress-controller"
    namespace = "kube-system"
    labels {
      k8s-app = "traefik-ingress-lb"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels {
        k8s-app = "traefik-ingress-lb"
      }
    }

    template {
      metadata {
        labels {
          k8s-app = "traefik-ingress-lb"
          name = "traefik-ingress-lb"
        }
      }

      spec {
        service_account_name = "traefik-ingress-controller"
        termination_grace_period_seconds = 60
        init_container {
          image = "busybox"
          name = "volume-mount-hack"
          command = ["sh", "-c", "chmod -R 600 /acme"]
          volume_mount {
            name = "acme"
            mount_path = "/acme"
          }
        }
        container {
          image = "traefik"
          name  = "traefik-ingress-lb"
          // AWS robot IAM identification for DNS challenge
          env = [
            {
              name = "AWS_ACCESS_KEY_ID"
              value = "${var.AWS_ACCESS_KEY_ID}"
            },
            {
              name = "AWS_SECRET_ACCESS_KEY"
              value = "${var.AWS_SECRET_ACCESS_KEY}"
            },
            {
              name = "AWS_HOSTED_ZONE_ID"
              value = "${var.AWS_HOSTED_ZONE_ID}"
            },
          ]
          volume_mount = [
            {
              name = "config"
              mount_path = "/config"
            },
            {
              name = "acme"
              mount_path = "/acme"
            },
            {
              name = "token"
              mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
              read_only = true
            },
          ]
          args = ["--api", "--kubernetes", "--configfile=/config/traefik.toml"]
          port = [
            {
              name = "http"
              container_port = 80
            },
            {
              name = "https"
              container_port = 443
            },
            {
              name = "admin"
              container_port = 8080
            }
          ]
        }
        volume = [
          {
            name = "config"
            config_map {
              name = "${kubernetes_config_map.config.metadata.0.name}"
            }
          },
          {
            name = "acme"
            host_path {
              path = "/srv/config-prod/acme.json"
            }
          },
          {
            name = "token"
            secret {
              default_mode = 420
              secret_name = "traefik-ingress-secret"
            }
          },
        ]
      }
    }
  }
}

resource "kubernetes_config_map" "config" {
  metadata {
    name = "traefik-conf"
    namespace = "kube-system"
  }

  data {
    traefik.toml = <<EOF
defaultEntryPoints = ["http","https"]
debug = false
logLevel = "INFO"
# Do not verify backend certificates (use https backends)
InsecureSkipVerify = true
[entryPoints]
  [entryPoints.http]
  address = ":80"
  compress = true
    [entryPoints.http.redirect]
    entryPoint = "https"
  [entryPoints.https]
  address = ":443"
  compress = true
    [entryPoints.https.tls]
[acme]
email = ""
storage = "/acme/acme.json"
caServer = "https://acme-staging-v02.api.letsencrypt.org/directory"
# or => caServer = "https://acme-v02.api.letsencrypt.org/directory"
entryPoint = "https"
onHostRule = true
acmeLogging = true
[acme.dnsChallenge]
  provider = "route53"
  delayBeforeCheck = 0
  # DNS server list for hosted zone on AWS
  resolvers = []
[[acme.domains]]
  main = "*.YOUR_DOMAIN"
  # List of sub-subdomains
  sans = []
[web]
  address = ":8080"
[kubernetes]
    EOF
  }
}

resource "kubernetes_service" "service" {
  metadata {
    name = "traefik-ingress-service"
    namespace = "kube-system"
  }
  spec {
    selector {
      k8s-app = "traefik-ingress-lb"
    }
    port = [
      {
        name = "http"
        port = 80
        target_port = 80
      },
      {
        name = "https"
        port = 443
        target_port = 443
      }
    ]
    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "ui_service" {
  metadata {
    name = "traefik-web-ui"
    namespace = "kube-system"
  }
  spec {
    selector {
      k8s-app = "traefik-ingress-lb"
    }
    port {
      name = "admin"
      port = 80
      target_port = 8080
    }
  }
}