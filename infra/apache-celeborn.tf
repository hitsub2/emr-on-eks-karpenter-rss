resource "helm_release" "celeborn" {
  name      = "celeborn"
  chart     = "${path.module}/helm-charts/celeborn"
  namespace = "celeborn"
  create_namespace = true

  values = [
    file("${path.module}/helm-charts/celeborn/values.yaml")
  ]
}