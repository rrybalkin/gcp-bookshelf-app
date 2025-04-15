# gcp-bookshelf-app
A final challenge task for GCP Developer learning course

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
