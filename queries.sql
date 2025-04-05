-- File: queries.sql
-- Description: This file contains MySQL queries used for data preparation and exploratory data analysis (EDA)
-- of the advertising dataset for the Ad Campaign Optimization project.

-- Step 1: Show all tables in the database
-- I started by listing all tables in the database to confirm the presence of the advertising_dataset table.
SHOW TABLES;

-- Step 2: Show the structure of the advertising_dataset table
-- I checked the structure of the table to understand the columns and their data types.
DESCRIBE advertising_dataset;

-- Step 3: Count the total number of rows in the dataset
-- I counted the total number of rows to get an initial sense of the dataset size.
SELECT COUNT(*) AS total_rows FROM advertising_dataset;

-- Step 4: Check for missing values in key columns
-- I checked for NULL values in all key columns to identify any missing data. No missing values were found.
SELECT
    SUM(CASE WHEN Id IS NULL THEN 1 ELSE 0 END) AS null_id,
    SUM(CASE WHEN campaign_category IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN Cost IS NULL THEN 1 ELSE 0 END) AS null_cost,
    SUM(CASE WHEN Platform IS NULL THEN 1 ELSE 0 END) AS null_platform,
    SUM(CASE WHEN Impressions IS NULL THEN 1 ELSE 0 END) AS null_impressions,
    SUM(CASE WHEN Clicks IS NULL THEN 1 ELSE 0 END) AS null_clicks,
    SUM(CASE WHEN days_rn IS NULL THEN 1 ELSE 0 END) AS null_days,
    SUM(CASE WHEN signups IS NULL THEN 1 ELSE 0 END) AS null_signups,
    SUM(CASE WHEN Ad_type IS NULL THEN 1 ELSE 0 END) AS null_ad_type,
    SUM(CASE WHEN Target_audience IS NULL THEN 1 ELSE 0 END) AS null_target,
    SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS null_location
FROM advertising_dataset;

-- Step 5: Check for duplicate rows
-- I checked for duplicates by comparing the total number of rows with the number of unique rows based on the Id column.
-- Result: total_rows = unique_rows, meaning no duplicates were found.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Id) AS unique_rows
FROM advertising_dataset;

-- Step 6: Alternative duplicate check using grouping
-- I performed a more detailed duplicate check by grouping by Id and looking for counts greater than 1.
-- Result: No duplicates were found.
SELECT Id, COUNT(*) AS count
FROM advertising_dataset
GROUP BY Id
HAVING count > 1;

-- Step 7: Example query to remove duplicates (not executed)
-- If duplicates had been found, I would have used this query to remove them by keeping the row with the lowest row_id.
-- This query was not executed since no duplicates were found.
DELETE t1 FROM advertising_dataset t1
INNER JOIN advertising_dataset t2
WHERE t1.Id = t2.Id AND t1.row_id > t2.row_id; -- Assuming an auto-incremented row_id exists

-- Step 8: Check data types and sample data
-- I sampled the first 10 rows to verify the data types and ensure they are correct.
-- Result: All data types were correct (e.g., Cost as float, Platform as varchar).
SELECT
    Id,
    campaign_category,
    Cost,
    Platform,
    Impressions,
    Clicks,
    days_rn,
    signups,
    Ad_type,
    Target_audience,
    Location
FROM advertising_dataset
LIMIT 10;

-- Step 9: Check for outliers in numerical columns
-- I checked for potential outliers by looking for extreme values in numerical columns.
-- Result: No outliers were found, as the query returned only column names (no rows matched the conditions).
SELECT
    Id,
    campaign_category,
    Cost,
    Platform,
    Impressions,
    Clicks,
    days_rn,
    signups,
    Ad_type,
    Target_audience,
    Location
FROM advertising_dataset
WHERE Cost > 1000000 OR Impressions > 1000000 OR Clicks > 1000000 OR days_rn > 100 OR signups > 10000
   OR Ad_type > 100 OR Target_audience > 100 OR Location > 100
LIMIT 10;

-- Step 10: Check min and max values for numerical columns
-- I calculated the minimum and maximum values for numerical columns to further confirm the absence of anomalies.
-- Result: All values were within normal ranges (e.g., no negative Costs, no unrealistically high Impressions).
SELECT
    MIN(Cost) AS min_cost, MAX(Cost) AS max_cost,
    MIN(Impressions) AS min_impressions, MAX(Impressions) AS max_impressions,
    MIN(Clicks) AS min_clicks, MAX(Clicks) AS max_clicks,
    MIN(signups) AS min_signups, MAX(signups) AS max_signups,
    MIN(days_rn) AS min_days, MAX(days_rn) AS max_days
FROM advertising_dataset;

-- Step 11: Basic EDA - Statistical summary of numerical columns
-- I calculated average, minimum, and maximum values for numerical columns to understand their distribution.
SELECT
    ROUND(AVG(Cost), 2) AS avg_cost,
    MIN(Cost) AS min_cost,
    MAX(Cost) AS max_cost,
    ROUND(AVG(Impressions), 0) AS avg_impressions,
    MIN(Impressions) AS min_impressions,
    MAX(Impressions) AS max_impressions,
    ROUND(AVG(Clicks), 0) AS avg_clicks,
    MIN(Clicks) AS min_clicks,
    MAX(Clicks) AS max_clicks,
    ROUND(AVG(signups), 0) AS avg_signups,
    MIN(signups) AS min_signups,
    MAX(signups) AS max_signups,
    ROUND(AVG(days_rn), 0) AS avg_days,
    MIN(days_rn) AS min_days,
    MAX(days_rn) AS max_days
FROM advertising_dataset;

-- Step 12: Basic EDA - Distribution of categorical columns (Platform)
-- I analyzed the distribution of campaigns by Platform and calculated the average cost per platform.
-- Result: Most campaigns were on Facebook, but Google Ads had a higher average cost.
SELECT
    Platform, COUNT(*) AS campaign_count,
    ROUND(AVG(Cost), 2) AS avg_cost_per_platform
FROM advertising_dataset
GROUP BY Platform
ORDER BY campaign_count DESC;

-- Step 13: Basic EDA - Distribution of categorical columns (Ad_type)
-- I analyzed the distribution of campaigns by Ad_type to understand which types were most common.
SELECT
    Ad_type, COUNT(*) AS campaign_count
FROM advertising_dataset
GROUP BY Ad_type
ORDER BY campaign_count DESC;

-- Step 14: Overall metrics for the entire dataset
-- I calculated overall metrics like average cost, total impressions, clicks, signups, CTR, signup rate, and cost per signup.
-- Result: avg_cost: 2053.67, total_signups: 10343194, overall_ctr_pct: 1.99, overall_signup_rate_pct: 2.20, overall_cost_per_signup: 9.93
SELECT
    ROUND(AVG(Cost), 2) AS avg_cost,
    SUM(Impressions) AS total_impressions,
    SUM(Clicks) AS total_clicks,
    SUM(signups) AS total_signups,
    ROUND(SUM(Clicks) / SUM(Impressions) * 100, 2) AS overall_ctr_pct,
    ROUND(SUM(signups) / SUM(Clicks) * 100, 2) AS overall_signup_rate_pct,
    ROUND(SUM(Cost) / SUM(signups), 2) AS overall_cost_per_signup,
    ROUND(SUM(Cost) / SUM(Clicks), 2) AS overall_cost_per_click
FROM advertising_dataset
WHERE Clicks > 0 AND signups > 0;

-- Step 15: Metrics by Platform
-- I calculated key metrics (campaign count, average cost, total signups, CTR, signup rate, cost per signup) for each platform.
-- Result: Google Ads had the highest signups (4348945), while LinkedIn had the best signup rate (3.05%).
SELECT
    Platform,
    COUNT(*) AS campaign_count,
    ROUND(AVG(Cost), 2) AS avg_cost,
    SUM(Impressions) AS total_impressions,
    SUM(Clicks) AS total_clicks,
    SUM(signups) AS total_signups,
    ROUND(SUM(Clicks) / SUM(Impressions) * 100, 2) AS ctr_pct,
    ROUND(SUM(signups) / SUM(Clicks) * 100, 2) AS signup_rate_pct,
    ROUND(SUM(Cost) / SUM(signups), 2) AS cost_per_signup,
    ROUND(SUM(Cost) / SUM(Clicks), 2) AS cost_per_click
FROM advertising_dataset
WHERE Clicks > 0 AND signups > 0
GROUP BY Platform
ORDER BY total_signups DESC;

-- Step 16: Additional metric - Click-through probability by Platform
-- I calculated the click-through probability (CTP) to understand the likelihood of a user clicking on an ad after seeing it.
-- Result: Google Ads had the highest CTP (80.89%), followed by LinkedIn (74.72%).
SELECT
    Platform,
    COUNT(DISTINCT Clicks) AS unique_visitors_clicked,
    COUNT(DISTINCT Impressions) AS total_unique_visitors,
    ROUND(COUNT(DISTINCT Clicks) / COUNT(DISTINCT Impressions) * 100, 2) AS click_through_probability_pct
FROM advertising_dataset
GROUP BY Platform
ORDER BY click_through_probability_pct DESC;

-- Step 17: Metrics by Ad_type
-- I analyzed key metrics by Ad_type to understand the performance of different ad formats.
-- Result: Image ads had the highest signups (4650902) and the lowest cost per signup ($9.36).
SELECT
    Ad_type,
    COUNT(*) AS campaign_count,
    ROUND(AVG(Cost), 2) AS avg_cost,
    SUM(signups) AS total_signups,
    ROUND(SUM(Clicks) / SUM(Impressions) * 100, 2) AS ctr_pct,
    ROUND(SUM(signups) / SUM(Clicks) * 100, 2) AS signup_rate_pct,
    ROUND(SUM(Cost) / SUM(signups), 2) AS cost_per_signup
FROM advertising_dataset
WHERE Clicks > 0 AND signups > 0
GROUP BY Ad_type
ORDER BY total_signups DESC;

-- Step 18: Metrics by Campaign Duration
-- I categorized campaigns by duration (Short, Medium, Long) and calculated key metrics for each group.
-- Result: Long campaigns (>60 days) had the highest signups (3611598), while Short campaigns had the lowest cost per signup ($8.99).
SELECT
    CASE
        WHEN days_rn < 30 THEN 'Short (<30 days)'
        WHEN days_rn BETWEEN 30 AND 60 THEN 'Medium (30-60 days)'
        ELSE 'Long (>60 days)'
    END AS campaign_duration,
    COUNT(*) AS campaign_count,
    ROUND(AVG(Cost), 2) AS avg_cost,
    SUM(signups) AS total_signups,
    ROUND(SUM(Clicks) / SUM(Impressions) * 100, 2) AS ctr_pct,
    ROUND(SUM(signups) / SUM(Clicks) * 100, 2) AS signup_rate_pct,
    ROUND(SUM(Cost) / SUM(signups), 2) AS cost_per_signup
FROM advertising_dataset
WHERE Clicks > 0 AND signups > 0
GROUP BY campaign_duration
ORDER BY total_signups DESC;

-- Step 19: Metrics by Target_audience
-- I analyzed key metrics by Target_audience to understand which audience segments performed best.
SELECT
    Target_audience,
    COUNT(*) AS campaign_count,
    ROUND(AVG(Cost), 2) AS avg_cost,
    SUM(Impressions) AS total_impressions,
    SUM(Clicks) AS total_clicks,
    SUM(signups) AS total_signups,
    ROUND(SUM(Clicks) / SUM(Impressions) * 100, 2) AS ctr_pct,
    ROUND(SUM(signups) / SUM(Clicks) * 100, 2) AS signup_rate_pct,
    ROUND(SUM(Cost) / SUM(signups), 2) AS cost_per_signup,
    ROUND(SUM(Cost) / SUM(Clicks), 2) AS cost_per_click
FROM advertising_dataset
WHERE Clicks > 0 AND signups > 0
GROUP BY Target_audience
ORDER BY total_signups DESC;

-- Step 20: Metrics by Location
-- I analyzed key metrics by Location to identify the best-performing regions.
SELECT
    Location,
    COUNT(*) AS campaign_count,
    ROUND(AVG(Cost), 2) AS avg_cost,
    SUM(Impressions) AS total_impressions,
    SUM(Clicks) AS total_clicks,
    SUM(signups) AS total_signups,
    ROUND(SUM(Clicks) / SUM(Impressions) * 100, 2) AS ctr_pct,
    ROUND(SUM(signups) / SUM(Clicks) * 100, 2) AS signup_rate_pct,
    ROUND(SUM(Cost) / SUM(signups), 2) AS cost_per_signup,
    ROUND(SUM(Cost) / SUM(Clicks), 2) AS cost_per_click
FROM advertising_dataset
WHERE Clicks > 0 AND signups > 0
GROUP BY Location
ORDER BY total_signups DESC;

-- Step 21: Metrics by Campaign_category
-- I analyzed key metrics by Campaign_category to understand the performance of different campaign types.
SELECT
    campaign_category,
    COUNT(*) AS campaign_count,
    ROUND(AVG(Cost), 2) AS avg_cost,
    SUM(Impressions) AS total_impressions,
    SUM(Clicks) AS total_clicks,
    SUM(signups) AS total_signups,
    ROUND(SUM(Clicks) / SUM(Impressions) * 100, 2) AS ctr_pct,
    ROUND(SUM(signups) / SUM(Clicks) * 100, 2) AS signup_rate_pct,
    ROUND(SUM(Cost) / SUM(signups), 2) AS cost_per_signup,
    ROUND(SUM(Cost) / SUM(Clicks), 2) AS cost_per_click
FROM advertising_dataset
WHERE Clicks > 0 AND signups > 0
GROUP BY campaign_category
ORDER BY total_signups DESC;

-- Step 22: Combination of dimensions (Platform and Target_audience)
-- I analyzed the combination of Platform and Target_audience to identify the best-performing combinations.
SELECT 
    Platform, Target_audience,
    COUNT(*) AS campaign_count,
    SUM(signups) AS total_signups,
    ROUND(SUM(Clicks) / SUM(Impressions) * 100, 2) AS ctr_pct,
    ROUND(SUM(signups) / SUM(Clicks) * 100, 2) AS signup_rate_pct,
    ROUND(SUM(Cost) / SUM(signups), 2) AS cost_per_signup
FROM advertising_dataset
WHERE Clicks > 0 AND signups > 0
GROUP BY Platform, Target_audience
ORDER BY total_signups DESC;

-- Step 23: Segmentation by Budget Range
-- I segmented campaigns by budget range (Low, Medium, High) to analyze their performance.
SELECT 
    CASE 
        WHEN Cost < 1000 THEN 'Low Budget (<1000)'
        WHEN Cost BETWEEN 1000 AND 3000 THEN 'Medium Budget (1000-3000)'
        ELSE 'High Budget (>3000)'
    END AS budget_range,
    COUNT(*) AS campaign_count,
    SUM(signups) AS total_signups,
    ROUND(SUM(Cost) / SUM(signups), 2) AS cost_per_signup
FROM advertising_dataset
WHERE signups > 0
GROUP BY budget_range;

-- Step 24: Final query for export to CSV
-- I prepared a final dataset for Tableau by aggregating key metrics and categorizing campaign duration and budget range.
SELECT 
    Platform, Target_audience, Location, Ad_type,
    CASE 
        WHEN days_rn < 30 THEN 'Short (<30 days)'
        WHEN days_rn BETWEEN 30 AND 60 THEN 'Medium (30-60 days)'
        ELSE 'Long (>60 days)'
    END AS campaign_duration,
    CASE 
        WHEN Cost < 1000 THEN 'Low Budget (<1000)'
        WHEN Cost BETWEEN 1000 AND 3000 THEN 'Medium Budget (1000-3000)'
        ELSE 'High Budget (>3000)'
    END AS budget_range,
    SUM(signups) AS total_signups,
    ROUND(SUM(Clicks) / SUM(Impressions) * 100, 2) AS ctr_pct,
    ROUND(SUM(signups) / SUM(Clicks) * 100, 2) AS signup_rate_pct,
    ROUND(SUM(Cost) / SUM(signups), 2) AS cost_per_signup
FROM advertising_dataset
WHERE Clicks > 0 AND signups > 0
GROUP BY Platform, Target_audience, Location, Ad_type, campaign_duration, budget_range;
