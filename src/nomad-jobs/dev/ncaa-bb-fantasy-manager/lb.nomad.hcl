job "lb" {
  datacenters = ["dc1"]
  namespace   = "namespace-1"

  group "load-balancer" {
    count = 1 # Only one instance of the LB

    network {
      port "http" {
        static = 80
      }
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "ghcr.io/your-github-user/nginx-lb:latest"
        ports = ["http"]
      }

      env {
        CONSUL_TEMPLATE_FILE = "/etc/nginx/nginx.conf"
      }

      template {
        data = <<EOF
        upstream web_backend {
          {% for service in service "web1" %}
          server {{ service.Address }}:{{ service.Port }};
          {% endfor %}
        }

        server {
          listen 80;

          location / {
            proxy_pass http://web_backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
          }
        }
        EOF
        destination = "/etc/nginx/nginx.conf"
        change_mode = "restart"
      }

      service {
        name = "lb"
        provider = "nomad"
        port = "http"

        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
