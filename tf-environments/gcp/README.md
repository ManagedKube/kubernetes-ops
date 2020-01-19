Folder Layout
==============

This folder is here to hold all Terraform resources for our GCP deployments.

# ./gcp folder
This folder holds each named environment we have: dev, qa, stage, prod, special-project, etc

This can hold any number of environments

# ./gcp/<environment name>
Under the named environment folder we have another folder that is named exactly the same.  Yes, this is a little redundant and not too DRY but let me explain why this is done.

In the folder `./gcp/<environment name>/` folder we have a `terragrunt.hcl` file that holds the state store information:

```
remote_state {
  backend = "gcs"
  config = {
    bucket = "kubernetes-ops-terraform-state-${get_env("STATE_STORE_UNIQUE_KEY", "default-value-1234")}"
    prefix  = path_relative_to_include()
    project = "managedkube"
    location = "us-central1"
  }
}
```

Creating a directory structure like this allows us to keep this file "DRY" and with no specific changes needed for it besides the `project` var if you wanted to store the state in another GCP project.

The alternative is to hold this file in each of the top level named environment dir and then set the `prefix` with the environment name.  However, this means that if I create another environment I have to copy this file over to that directory and remember to change the environment name in the `prefix` variable.  While I like that idea, I have seen many times when someone creates a new environment they don't chane that var and then start overwritting another environment's state store.  With this method, the environment name (which is the directory name) is always there and in the GCS bucket that means these paths will always be unique because on your local file system you cannot create a folder name with the same name.

Another thing that this provide us is a way to keep the state store in another GCP project.  Your pre-production infra might be in one GCP project and your production infra could be in another project.  This allows us to specify which project to target.
