
### Create a terraform state bucket if not yet
```shell
gcloud storage buckets create gs://my-bookshelf-app-terraform --location=europe-north2
```

### Make auth login to GCP
```shell
gcloud auth application-default login
```

### Init terraform
```shell
terraform init -backend-config=./backend.conf
```

### Terraform plan
```shell
terraform plan -var-file=./input.tfvars -out=./tfplan
```

### Validate plan and apply
If everything in the plan output looks good, you can apply the changes by running the command:
```shell
terraform apply "./tfplan"
```
