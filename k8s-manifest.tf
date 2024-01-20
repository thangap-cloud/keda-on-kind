# Deployment manifest to deploy a nginx pod

resource "kubectl_manifest" "nginx-deployment" {
  
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
YAML

depends_on = [ helm_release.http-add-on ]
}

# Expose the nginx deployment as a node port service

resource "kubectl_manifest" "nginx-svc" {
  
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  selector:
    app: nginx
  type: NodePort
  ports:
    - name: http
      nodePort: 30910
      targetPort: 80
      port: 80

  YAML

  depends_on = [ kubectl_manifest.nginx-deployment ]
}  

# resource "null_resource" "localstack_port_forwarding" {
#   provisioner "local-exec" {
#     command = "kubectl port-forward svc/nginx 8085:80 --namespace default"
#   }

#   depends_on = [ kubectl_manifest.nginx-svc ]
# }

# Keda http scaled object creation and autoscaling configurations

resource "kubernetes_namespace_v1" "app-ns" {
  metadata {
    name = "app-ns"
  }
}

resource "kubectl_manifest" "py-app" {
  yaml_body = <<YAML

apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  namespace: app-ns
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: dmrsoft/myapp:latest
        ports:
        - containerPort: 5000
        env:
        - name: ENVIRONMENT
          value: "production"
 YAML

  depends_on = [ kubernetes_namespace_v1.app-ns ]
}

resource "kubectl_manifest" "py-app-svc" {
  
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: myapp
  namespace: app-ns
spec:
  selector:
    app: myapp
  ports:
  - name: http
    port: 80
    targetPort: 5000
YAML

  depends_on = [ kubectl_manifest.py-app]
}  

resource "kubectl_manifest" "keda-scaled-object" {
  
  yaml_body = <<YAML
kind: HTTPScaledObject
apiVersion: http.keda.sh/v1alpha1
metadata:
    name: nginx-http-scaledobject
spec:
    host: test-host.com
    targetPendingRequests: 1
    scaleTargetRef:
        deployment: nginx
        service: nginx
        port: 80
    replicas:
        min: 0
        max: 3
YAML

  depends_on = [ kubectl_manifest.nginx-svc ]
}  

#kube-prometheus-stackr-prometheus.prometheus.svc.cluster.local

resource "kubectl_manifest" "keda-scaled-object-prom" {
  
  yaml_body = <<YAML
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: prometheus-scaledobject
  namespace: app-ns
spec:
  scaleTargetRef:
    name: myapp
  triggers:
    - type: prometheus
      metadata:
        serverAddress: http://kube-prometheus-stackr-prometheus.prometheus.svc.cluster.local:9090
        threshold: '100'
        query: sum(rate(http_requests_total{deployment="myapp"}[2m]))
YAML

  depends_on = [ kubectl_manifest.nginx-svc ]
} 