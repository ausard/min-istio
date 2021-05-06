locals {
  spring_dashboard = "spring-boot-statistics"
}

resource "null_resource" "echo" {
provisioner "local-exec" {
    command = "echo ${var.kubernetes_dashboard_view_only_token} > token.txt"
  }

 
}