resource "kubernetes_service" "redis-master" {
  metadata {
    name = "redis-master"
  }
  spec {
    selector = {
      app  = "redis"
      role = "master"
      tier = "backend"
    }
    port {
      port        = 6379
      target_port = 6379
    }
  }
}

resource "kubernetes_service" "redis-slave" {
  metadata {
    name = "redis-slave"

    labels = {
      app  = "redis"
      role = "slave"
      tier = "backend"
    }
  }

  spec {
    selector = {
      app  = "redis"
      role = "slave"
      tier = "backend"
    }

    port {
      port        = 6379
      target_port = 6379
    }
  }
}