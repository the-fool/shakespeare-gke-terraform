#! /bin/bash

gcloud services enable container.googleapis.com
gcloud services enable cloudbuild.googleapis.com

terraform apply