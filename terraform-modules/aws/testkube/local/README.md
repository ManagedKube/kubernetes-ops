# testkube local
This is an example on how to structure your testkube so that you can use the kubernetes-ops `base-tests`
and have your own `local` tests (this directory).  While this `local` directory resides in this kubernetes-ops
repo, it is really meant to go into your own repo and you can reference the source from there.  The reason
is that the set of tests here in this module is specific to you and really to no one else.

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_manifest_set"></a> [manifest\_set](#module\_manifest\_set) | github.com/ManagedKube/kubernetes-ops.git//terraform-modules/aws/kubernetes/manifest_set | v2.0.12 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_x2_namespace"></a> [x2\_namespace](#input\_x2\_namespace) | The namespace that the X2 applications are in | `string` | `"ops"` | no |

## Outputs

No outputs.
