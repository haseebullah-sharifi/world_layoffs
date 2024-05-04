-- Exploratory Data Analysis
-- Dataset: layoffs_staging2
-- Data Source: layoffs dataset's cleaned form


-- Overview of the dataset

SELECT *
FROM world_layoffs.layoffs_staging2;


-- Maximum total laid off and maximum percentage laid off

SELECT
	max(total_laid_off),
    max(percentage_laid_off)
FROM world_layoffs.layoffs_staging2;


-- Companies that laid off all of their employees (starting from highest number of laid off to the lowest number)

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off desc;


-- Companies that laid off all of their employees (starting from highest funds raised to lowest funds raised)

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions desc;


-- Total number of laid offs by company

SELECT
	company,
    sum(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 desc;


-- Starting and ending dates of the recorded data

SELECT
	min(`date`),
    max(`date`)
FROM world_layoffs.layoffs_staging2;


-- Total number of laid offs by industry

SELECT
	industry,
    sum(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 desc;


-- Total number of laid offs by country

SELECT
	country,
    sum(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 desc;


-- Total number of laid offs by year

SELECT
	YEAR(`date`) AS `year`,
	sum(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY `year`
ORDER BY 1 desc;


-- Total number of laid offs by stage

SELECT
	stage,
    sum(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY 2 desc;


-- Rolling sum of total laid off by month

SELECT *
FROM world_layoffs.layoffs_staging2;


SELECT
	substr(`date`, 1, 7) AS `month`,
    sum(total_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE substr(`date`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY 1;


# Rolling sum is the sum of each month's total laid off that is being added to previous values and keeps increasing

WITH Rolling_Total AS
	(
    SELECT
		substr(`date`, 1, 7) AS `month`,
		sum(total_laid_off) AS sum_of_total_laid_off
	FROM world_layoffs.layoffs_staging2
	WHERE substr(`date`, 1, 7) IS NOT NULL
	GROUP BY `month`
	ORDER BY 1
    )
SELECT
	`month`,
    sum_of_total_laid_off,
    sum(sum_of_total_laid_off) OVER(ORDER BY `month`) AS rolling_total
FROM Rolling_Total;


-- Top five companies with the highest number of laid offs in each year

SELECT
	company,
    YEAR(`date`) AS `year`,
    sum(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company, `year`
ORDER BY 3 desc;


WITH Company_Year (company, `year`, total_laid_off) AS
	(
    SELECT
		company,
		YEAR(`date`) AS `year`,
		sum(total_laid_off)
	FROM world_layoffs.layoffs_staging2
	GROUP BY company, `year`
    ),
Company_Year_Rank AS
	(
	SELECT *,
	DENSE_RANK() OVER (PARTITION BY `year` ORDER BY total_laid_off desc) AS ranking
	FROM Company_Year
	WHERE `year` IS NOT NULL
	)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;


-- Total number of employees and total laid offs by each company

WITH Total_Employees AS
	(
	SELECT *,
		total_laid_off/percentage_laid_off AS total_employees
	FROM world_layoffs.layoffs_staging2
    )
SELECT
	company,
    sum(total_laid_off),
    round(sum(total_employees), 0) AS `sum(total_employees)`
FROM Total_Employees
GROUP BY company
HAVING sum(total_laid_off) IS NOT NULL
AND sum(total_employees) IS NOT NULL
ORDER BY sum(total_employees) desc;


-- Total funds raised by company

SELECT
	company,
	sum(funds_raised_millions) AS total_funds_raised_millions
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY total_funds_raised_millions desc;


-- Total funds raised by industry

SELECT
	industry,
	sum(funds_raised_millions) AS total_funds_raised_millions
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY total_funds_raised_millions desc;


-- Top three countries with the highest number of laid offs in each year

SELECT
	country,
    YEAR(`date`) AS `year`,
    sum(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country, `year`
ORDER BY 3 desc;


WITH Country_Year (country, `year`, total_laid_off) AS
	(
    SELECT
		country,
		YEAR(`date`) AS `year`,
		sum(total_laid_off)
	FROM world_layoffs.layoffs_staging2
	GROUP BY country, `year`
    ),
Country_Year_Rank AS
	(
	SELECT *,
	DENSE_RANK() OVER (PARTITION BY `year` ORDER BY total_laid_off desc) AS ranking
	FROM Country_Year
	WHERE `year` IS NOT NULL
	)
SELECT *
FROM Country_Year_Rank
WHERE ranking <= 3;