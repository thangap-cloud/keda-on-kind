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