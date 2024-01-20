resource "kind_cluster" "default" {
  name = "cluster-1"
  wait_for_ready = true
  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      extra_port_mappings {
        container_port = 30910
        host_port = 30910
        listen_address = "127.0.0.1"
        protocol = "TCP"
      }
    }

    node {
      role = "worker"
      image = "kindest/node:v1.23.4"
    }
  }
}

resource "time_sleep" "wait" {
  depends_on = [kind_cluster.default]
  create_duration = "20s"
}

resource "helm_release" "keda" {
  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  namespace  = "keda"
  create_namespace = true
}

resource "helm_release" "http-add-on" {
    name        = "http-add-on"
    repository  = "https://kedacore.github.io/charts"
    chart       = "keda-add-ons-http"
    namespace   = "keda"
    create_namespace = false
    depends_on = [ helm_release.keda ]
}

resource "helm_release" "kube-prometheus" {
  name       = "kube-prometheus-stackr"
  namespace  = "prometheus"
  create_namespace = true
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  depends_on = [ helm_release.http-add-on ]
}