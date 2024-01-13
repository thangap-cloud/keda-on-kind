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

## Inputs

No inputs.

## Outputs

No outputs.
