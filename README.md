# Keda Deployment on Kind K8s Cluster

More details about Keda can be found here https://keda.sh/, This deployment helps to understand how keda works, the deployment explains how a k8s pod scales based on the provided load

## How to Deploy and Test

```bash
terraform init
terraform plan -out tf.plan
terraform apply tf.plan

# once the deployment is done

kubectl get po -n default # nginx deployment will be scaled down to 0 because in the scaledobject configuration we set min replica to 0
kubectl port-forward svc/keda-add-ons-http-interceptor-proxy -n keda 30910:8080 # we make sure all the request to nginx service comes in thru keda-add-ons-http-interceptor-proxy

# Open a new window  

curl localhost:30910 -H 'Host: test-host.com' # mimic as if the request is coming from test-host.com

kubectl get po -n default # now you can see the po being scaled up and the replica count increased to 1
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.2.0 |
| <a name="requirement_kind"></a> [kind](#requirement\_kind) | 0.0.12 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.2.0 |
| <a name="provider_kind"></a> [kind](#provider\_kind) | 0.0.12 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.http-add-on](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.keda](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kind_cluster.default](https://registry.terraform.io/providers/tehcyx/kind/0.0.12/docs/resources/cluster) | resource |
| [kubectl_manifest.keda-scaled-object](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.nginx-deployment](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.nginx-svc](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [time_sleep.wait](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |


