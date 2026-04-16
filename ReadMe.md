# Citi Bike & Weather Analytics: NYC Insights Pipeline
### Data Engineering Zoomcamp 2026 Capstone Project

## 1. Project Overview
### Problem Statement
New York City's Citi Bike system generates millions of trip records monthly. However, ridership is heavily influenced by external factors—most notably weather conditions. This project builds an automated end-to-end data pipeline to ingest Citi Bike trip data and local NYC weather data into a Google Cloud-based data warehouse.

The goal is to enable analysts to answer questions like:
* **How does precipitation (rain/snow) impact daily ridership?**
* **Do riders prefer electric bikes over classic bikes during extreme temperatures?**
* **Which stations remain "hubs" even during inclement weather?**

## 2. Architecture
The pipeline follows a modern ELT (Extract, Load, Transform) pattern:

1.  **Orchestration:** [Kestra](https://kestra.io/) manages the workflow, scheduling, and error handling.
2.  **Data Sources:**
    * **Citi Bike Data:** Monthly CSV files from the public Citi Bike GCS Bucket.
    * **Weather Data:** Daily weather metrics from the [Visual Crossing API](https://www.visualcrossing.com/).
3.  **Data Lake:** Raw files are stored in **Google Cloud Storage (GCS)**.
4.  **Data Warehouse:** Data is staged via **External Tables** and moved into partitioned/clustered tables in **Google BigQuery**.
5.  **Transformation:** SQL-based transformations create normalized Dimension tables (`dim_weather`, `dim_stations`) and optimized analytics views.
6.  **Visualization:** A public **Looker Studio** dashboard for final analysis.

## 3. Technologies Used
* **Cloud:** Google Cloud Platform (GCS, BigQuery)
* **Infrastructure as Code:** Terraform
* **Workflow Orchestration:** Kestra
* **Containerization:** Docker
* **Data Modeling:** SQL (Star Schema)
* **Visualization:** Looker Studio

## 4. Dataset Description
* **Citi Bike Trips:** Contains trip duration, start/end times, station IDs, station names, latitude/longitude, and member status.
* **NYC Weather:** Contains daily max/min/avg temperatures, precipitation, snow depth, and wind speed (in US Imperial units).

## 5. Setup & Replication Guide

### Prerequisites
* Google Cloud Platform account with a Project ID.
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed.
* Docker and Docker Compose installed.

### Step 1: Infrastructure (Terraform)
1. Navigate to the `terraform/` directory.
2. Update `variables.tf` with your `GCP_PROJECT_ID`.
3. Authenticate and deploy:
   ```bash
   gcloud auth application-default login
   terraform init
   terraform apply