# Citi Bike & Weather Analytics: NYC Insights Pipeline
### Data Engineering Zoomcamp 2026 Capstone Project

## 1. Project Overview
### Problem Statement
New York City's Citi Bike system generates millions of trip records monthly. However, ridership is heavily influenced by external factors—most notably weather conditions. This project builds an automated end-to-end data pipeline to ingest Citi Bike trip data and local NYC weather data into a Google Cloud-based data warehouse.

The goal is to enable analysts to answer questions like:
* **How does precipitation impact daily ridership?**
* **What is the influence of temperature on different types of riders (member vs casual)?**
* **Which stations remain "hubs" even during inclement weather?**

## 2. Architecture
The pipeline follows a modern ELT (Extract, Load, Transform) pattern:

1.  **Orchestration:** [Kestra](https://kestra.io/) manages the workflow, scheduling, and error handling.
2.  **Data Sources:**
    * **Citi Bike Data:** Monthly CSV files from the public Citi Bike AWS Bucket.
    * **Weather Data:** Daily weather metrics from the [Visual Crossing API](https://www.visualcrossing.com/).
3.  **Data Lake:** Raw files are stored in **Google Cloud Storage (GCS)**.
4.  **Data Warehouse:** Data is staged via **External Tables** and moved into partitioned/clustered tables in **Google BigQuery**.
5.  **Transformation:** SQL-based transformations create normalized tables (`vw_reporting_weather`, `vw_reporting_citibikes`) and optimized analytics views (`vw_reporting_citibike_analysis`).
6.  **Visualization:** A public [Looker Studio Dashboard](https://datastudio.google.com/s/usF5QrWla9M) for final analysis.

## 3. Technologies Used
* **Infrastructure as Code:** Terraform
* **Cloud:** Google Cloud Platform (GCS Bucket, BigQuery)
* **Containerization:** Docker
* **Workflow Orchestration:** Kestra
* **Visualization:** Looker Studio

## 4. Dataset Description
* **Citi Bike Trips:** Contains trip duration, start/end times, station IDs, station names, latitude/longitude, and member status.
* **NYC Weather:** Contains daily max/min/avg temperatures, precipitation, snow depth, and wind speed (in US Imperial units).

## 5. Setup & Replication Guide

### Prerequisites
* Terraform installed locally to manage infrastrcuture.
* Google Cloud Platform (GCP) account with a Project ID.
* GCP service account able to manage resources like buckets and Big Query for terraform and kestra operations.
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed.
* Docker and Docker Compose installed.
* [Visual Crossing API](https://www.visualcrossing.com/) Key (create an account on the website and on the user settings you will have your key).

### Step 1: Infrastructure (Terraform)
1. Navigate to the `terraform/` directory.
2. Create a folder `keys/` and place the json file with the secret of the service account for GCP.
3. Update `variables.tf` with your `GCP_PROJECT_ID` and the path to your `CREDENTIALS`.
4. Authenticate and deploy:
   ```bash
   gcloud auth application-default login
   terraform init
   terraform apply

### Step 2: Orchestration (Kestra)
1. Navigate to the `kestra/` directory.
2. Create a folder `keys/` and place the `.json` file with the secret of the service account for GCP and also a `.txt` file with the Visual Crossing API Key. 
3. Going back to the `kestra/` directory create a `.env` file.
4. Now you need to encode the information of the json file with the secret for the service account and add to the `.env` file:
    ```bash
    echo SECRET_GCP_SERVICE_ACCOUNT=$(cat *secretfilename.json* | base64 -w 0) >> .env
5. Repeat the same step for the Visual Crossing API Key:
    ```bash
    echo SECRET_VISUAL_CROSSING_API_KEY=$(cat *keyfilename.txt* | base64 -w 0) >> .env
6. Launch Kestra locally using Docker Compose:
   ```bash
   docker-compose up -d
7. Access the UI at `http://localhost:8080`.
8. Set variables (`GCP_PROJECT_ID`, `GCP_DATASET`, `GCP_BUCKET_NAME`) in the Kestra Settings, you can use the `gcp_kv.yaml` file in `kestra/flows`. The secrets are already defined by the docker compose file.
9. Import flows from the `kestra/` directory:
   * `gcp_kv.yaml`: Creates the necessary keys in the Key Vault.
   * `gcp_citibike_scheduled.yaml`: Orchestrates the monthly trip data ingestion.
   * `gcp_nyc_weather_daily.yaml`: Orchestrates the daily weather API calls.

### Step 3: Data Transformation
The flows automatically handle the heavy lifting once the data is in BigQuery:

* __Partitioning__: The main tables are partitioned by datetime (weather) and started_at (trips) to optimize query performance and reduce scan costs.

* __Idempotency__: The weather ingestion task uses a MERGE statement. This ensures that if a flow is re-run for a specific date, it updates the existing record rather than creating a duplicate.

* __Dimension Modeling__: SQL scripts generate the vw_reporting_weather, vw_reporting_citibikes, vw_reporting_citibike_analysis tables (`gcp/bigQuery/views`). The weather dimension categorizes raw numbers into human-readable buckets like "Freezing," "Moderate Rain," and "Heavy Snow".

### Step 4: Visualization
A [single-page dashboard](https://datastudio.google.com/s/usF5QrWla9M) was built in Looker Studio using a joined BigQuery view (vw_reporting_citibike_analysis) to avoid the performance limitations of browser-side data blending.

__Key Visuals Included:__

* __Weather Resilience__: A combo chart showing Trip Volume vs. Average Temperature.

* __Precipitation Impact__: A scatter plot correlating Rain inches with Daily Record Counts.

* __Rider Profiles__: A heatmap showing how "Member" vs "Casual" trip count changes across temperature categories.

* __Busiest Start Stations__: Table with top 10 stations with the most trip count.