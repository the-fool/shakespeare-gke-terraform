resource "kubernetes_deployment" "redis-master" {
  metadata {
    name = "redis-master"
    labels = {
      app  = "redis"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app  = "redis"
        role = "master"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app  = "redis"
          role = "master"
          tier = "backend"
        }
      }

      spec {
        container {
          image = "k8s.gcr.io/redis:e2e"
          name  = "master"

          port {
            container_port = 6379
          }

          resources {
            requests {
              cpu    = "100m"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "redis-slave" {
  metadata {
    name = "redis-slave"

    labels = {
      app  = "redis"
      role = "slave"
      tier = "backend"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app  = "redis"
        role = "slave"
        tier = "backend"
      }
    }

    template {

      metadata {
        labels = {
          app  = "redis"
          role = "slave"
          tier = "backend"
        }
      }

      spec {

        container {
          image = "gcr.io/google_samples/gb-redisslave:v1"
          name  = "slave"

          port {
            container_port = 6379
          }

          env {
            name  = "GET_HOSTS_FROM"
            value = "dns"
          }

          resources {
            requests {
              cpu    = "100m"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }
}