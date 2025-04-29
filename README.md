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

### Challenge Task checklist

1. Manual Build Docker Image (10 points):
  * [x] Create a Cloud Source Repository with your app (HTTP Server). https://github.com/rrybalkin/gcp-bookshelf-app
  * [x] Add a Dockerfile file into your repository to build your app.
  * [x] Test the created Docker image.
  * [x] Push the Docker image into the Artifact Repository.

2. Automate Build Docker Image (10 points):
  * [x] Create a pipeline in Cloud Build to build a Docker image when the source code changes.

3. Manual Docker Image Deployment (10 points):
  * [x] Use the image to create a deployment in Kubernetes.
  * [x] Update the image and apply the change of the deployment.

4. Automate Docker Image Deployment (10 points):
  * [x] Create a pipeline in Cloud Build to deploy a new version of your image when the source code changes.

5. Expose your service over Cloud Load Balancer (Ingress) with an external static IP address (10 points)
  * [x] Create k8s service with Load Balancer to access application via external IP.

6. Connect to Database using Cloud SQL Auth Proxy (10 points):
  * [x] Create a Cloud SQL Database with a private IP address.
  * [x] Update application code to use new DAO for CloudSQL with new model, fix creating new books.
  * [x] Connect the Application to the Database over the private IP address using Cloud SQL Auth Proxy.
  * [x] Use Cloud Secret Manager & k8s secrets to store secret data such as DB username, password.

7. Manual SQL migration scripts (see details here https://cloud.google.com/architecture/devops/devops-tech-database-change-management) (10 points):
  * [x] Create and apply SQL database migration scripts using one of database migration tools when the SQL database migration scripts add.
  * [x] Connect the Migration Tool to the Database over the public IP address using Cloud SQL Auth Proxy.

8. Automate SQL migration scripts (10 points):
  * [x] Create a pipeline in Cloud Build to apply database migration scripts.

9. Create diagrams that describe request flow, CI/CD flow, etc. (10 points)
  * [x] [request flow diagram](./docs/req-res-flow.png)
  * [x] [CI/CD flow](./docs/ci-cd-flow.png)

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
