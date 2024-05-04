# World Layoffs Analysis with SQL

### Overview
This repository contains a data analysis project on global layoffs using SQL. The dataset provides insights into layoffs across different companies, locations, industries, and stages.

### Dataset
The dataset consists of the following columns:

* **`company`:** Name of the company
* **`location`:** Location of the layoffs
* **`industry`:** Industry of the company
* **`total_laid_off`:** Total number of employees laid off
* **`percentage_laid_off`:** Percentage of employees laid off
* **`date`:** Date of layoffs
* **`stage`:** Stage of the company (e.g., early-stage, late-stage)
* **`country`:** Country of the company
* **`funds_raised_millions`:** Funds raised by the company in millions

### Project Structure
* **`data/`:** Contains the raw dataset used for analysis.
* **`scripts/`:** SQL scripts used for data cleaning and analysis.

### Data Cleaning
The data cleaning process involved the following steps:

**1.** Removing duplicates.
**2.** Standardizing the data
**3.** Dealing with NULL values
**4.** Removing unnecessary rows and columns

### Exploratory Data Analysis (EDA)
Using SQL queries, the following insights were derived:

* Total number of layoffs by industry and country.
* Percentage of layoffs by company stage.
* Trends in layoffs over time.
* Relationship between layoffs and funds raised.

### Dependencies
* SQL database management system (e.g., MySQL, PostgreSQL)
* SQL client (e.g., MySQL Workbench, pgAdmin)

### Contributors
Haseebullah Sharifi
