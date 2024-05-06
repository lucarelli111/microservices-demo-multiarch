# Terraform

## GCP 

### Configuration step

Install the CLI following [the doc](https://cloud.google.com/sdk/docs/install)



Allow terraform to access your credential and authenticate
```
gcloud auth login #authenticate
gcloud auth application-default login
```


### Config and start cluster


Validate your terraform.tfvars config file
```
# terraform.tfvars
project_id = "datadog-sandbox"
region     = "us-central1"
```

You can retreive your project_id using ```gcloud config get-value project```
Then initialise TF
```
terraform init
```

Try and launch the cluster
```
terraform plan
terraform apply
```

### Enable kubectl with the cluster

```
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)
```

