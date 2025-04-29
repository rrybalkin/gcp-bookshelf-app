
resource "null_resource" "get-k8s-credentials" {
  count = var.deploy_gke_cluster ? 1 : 0
  depends_on = [google_container_cluster.autopilot_gke]

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.autopilot_gke[0].name} --region ${var.region}"
  }
}

resource "null_resource" "do-k8s-deploy" {
  count = var.deploy_gke_cluster ? 1 : 0
  depends_on = [null_resource.get-k8s-credentials]

  provisioner "local-exec" {
    command = "cd ../kubernetes && ./k8s-deploy.sh dev"
  }
}
