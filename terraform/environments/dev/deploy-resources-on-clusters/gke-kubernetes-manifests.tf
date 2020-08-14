# data "google_client_config" "provider" {}

# data "google_container_cluster" "my_cluster" {
#   name     = google_container_cluster.primary.name
#   location = "us-central1"
# }

# provider "kubernetes" {
#   load_config_file = false

#   host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
#   token = data.google_client_config.provider.access_token
#   cluster_ca_certificate = base64decode(
#     data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
#   )
# }

# resource "kubernetes_deployment" "example" {
#   metadata {
#     name = "terraform-example"
#     labels = {
#       test = "MyExampleApp"
#     }
#   }

#   spec {
#     replicas = 2

#     selector {
#       match_labels = {
#         test = "MyExampleApp"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           test = "MyExampleApp"
#         }
#       }

#       spec {
#         container {
#           image = "springcommunity/spring-framework-petclinic"
#           name  = "example"
#           port {
#             name           = "http"
#             container_port = 8080
#             protocol       = "TCP"
#           }

#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "example" {
#   metadata {
#     name = "my-service"
#   }
#   spec {
#     selector = {
#       test  = kubernetes_deployment.example.spec.0.template.0.metadata[0].labels.test

#     }
#     port {
#       port        = 80
#       target_port = 8080
#     }

#     type = "ClusterIP"
#   }
# }