-- Data Cleaning with MySQL
-- Dataset: layoffs
-- Data source: https://www.kaggle.com/datasets/swaptr/layoffs-2022


-- Overview of the dataset

SELECT *
FROM world_layoffs.layoffs;


-- Creating a new table (layoffs_staging) in order to keep raw data as it is

CREATE TABLE world_layoffs.layoffs_staging
LIKE world_layoffs.layoffs;


INSERT world_layoffs.layoffs_staging
SELECT *
FROM world_layoffs.layoffs;


SELECT *
FROM world_layoffs.layoffs_staging;


-- Four (4) steps of data cleaning in layoffs dataset:

-- 1. Removing Duplicates:

# Checking for dupicates

SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs;


SELECT *
FROM (
		SELECT *,
			ROW_NUMBER() OVER(
			PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
				AS row_num
		FROM world_layoffs.layoffs) AS duplicates
WHERE row_num > 1;


-- Creating a new table (layoffs_staging2) in order to delete duplicates there

CREATE TABLE `world_layoffs`.`layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO world_layoffs.layoffs_staging2
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs;


-- Overview of the new table

SELECT *
FROM world_layoffs.layoffs_staging2;


# Deleting Duplicates

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE row_num > 1;


DELETE
FROM world_layoffs.layoffs_staging2
WHERE row_num > 1;


-- 2. Standardizing the Data

# Trimming

SELECT
	company,
	TRIM(company) AS company_trimmed
FROM world_layoffs.layoffs_staging2;


UPDATE world_layoffs.layoffs_staging2
SET company = TRIM(company);


# Updating the industry column (Changing all 'Crypto%' to Crypto)

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY 1;


SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry LIKE 'Crypto%';


UPDATE world_layoffs.layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


# Updating country column (Removing '.' from United States)

SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
ORDER BY 1;


SELECT
	DISTINCT country,
	TRIM(TRAILING '.' FROM country)
FROM world_layoffs.layoffs_staging2
ORDER BY 1;


UPDATE world_layoffs.layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);


# Updating date column from text to standard date format

SELECT `date`
FROM world_layoffs.layoffs_staging2;


SELECT
	`date`,
    str_to_date(`date`, '%m/%d/%Y')
FROM world_layoffs.layoffs_staging2;


UPDATE world_layoffs.layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');


ALTER TABLE world_layoffs.layoffs_staging2
MODIFY COLUMN `date` DATE;


-- 3. Dealing with NULL values

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL
OR industry = '';


SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company = 'Airbnb';


SELECT
	t1.industry,
	t2.industry
FROM world_layoffs.layoffs_staging2 t1
JOIN world_layoffs.layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';


UPDATE world_layoffs.layoffs_staging2 t1
JOIN world_layoffs.layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


-- 4. Removing unnecessary rows and columns

# Removing unnecessary rows

SELECT *
FROM world_layoffs.layoffs_staging2;


SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


# Removing unnecessary columns

ALTER TABLE world_layoffs.layoffs_staging2
DROP COLUMN row_num;


SELECT *
FROM world_layoffs.layoffs_staging2;