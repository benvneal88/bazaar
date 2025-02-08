job "web1" {
  datacenters = ["dc1"]
  namespace   = "namespace-1"

  group "web" {
    count = 2 # Two instances of the web app

    network {
      port "http" {
        static = 8080
      }
    }

    task "web" {
      driver = "docker"

      config {
        image = "ghcr.io/your-github-user/web-app:latest"
        ports = ["http"]
      }

      env {
        DATABASE_URL = "postgres://user:password@db.service.consul:5432/mydb"
      }

      service {
        name = "web1"
        provider = "nomad"
        port = "http"

        check {
          type     = "http"
          path     = "/health"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256 MB RAM
      }
    }
  }
}
