# gcp-bookshelf-app
A final challenge task for the **_CloudX Associate: GCP Developer_** learning course.

The task aims to test the following topics knowledge and practical skills:
* Creating Docker images on a host. 
* Running Docker containers on a host. 
* Storing Docker images in the GCP Artifact Repository (AR). 
* Deploying AR images on Kubernetes.
* Pushing updates onto Kubernetes. 
* Automating deployments to Kubernetes using Cloud Build pipelines. 
* Creating a Cloud SQL Database with a public and private IP address. 
* Connecting to Database using Cloud SQL Auth Proxy. 
* Using database change management approach. 
* Using Cloud Secret Manager & k8s secrets to store secret data. 
* Exposing k8s service over Cloud Load Balancer with external IP address. 
* Creating VPC, networks, subnetworks and using firewall rules.

The application code itslef is not so important, therefore the existing GCP tutorials [Bookshelf app](https://github.com/GoogleCloudPlatform/getting-started-python/tree/main/bookshelf) in Python is used.

The main GCP resources provisioned by Terraform, the scripts can be found in the [infrastructure](infrastructure) sub-folder.
Although a few resources have to be created manually because of complicated terraform integration or not supported by GCP plugin yet, such as:
- OAuth resources including Branding, Consent, Client
- GitHub repo integration and CloudBuild trigger to build on git changes

### How to run CloudSQL Proxy Locally
Feel free to change the port if 5432 is already taken locally.
```shell
./cloud-sql-proxy --address 0.0.0.0 --port 5432 cloudx-gcp-developer-rrybalkin:europe-north2:bookshelf-cloud-sql-instance
```

### How to generate CloudSQL DB schema
Make sure the CloudSQL Auth Proxy is running locally. 
Also make sure you have `.env` file with required variables, check the `.env.template` file for reference.

In order to run DB migration sript:
```shell
./db_migration.sh
```

### How to submit CloudBuild from locally with a custom SA
```shell
gcloud builds submit --config=cloudbuild.yaml --service-account=projects/cloudx-gcp-developer-rrybalkin/serviceAccounts/cloud-build-sa@cloudx-gcp-developer-rrybalkin.iam.gserviceaccount.com .
```
