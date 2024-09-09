USE DWH_task2;

-- Create the Date Dimension Table using a simple numbers table approach
CREATE EXTERNAL TABLE [Dim_Date]
WITH (
    LOCATION = 'dim_date.csv', 
    DATA_SOURCE = [csvfiles_synwarehousetask_dfs_core_windows_net], -- defined during ETL
    FILE_FORMAT = [SynapseDelimitedTextFormat]  -- defined during ETL
) AS
WITH Numbers AS (
    -- Generate numbers from 0 to (365 * 7) using a recursive CTE (this is supported in Synapse)
    SELECT 0 AS n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n < DATEDIFF(DAY, '2016-01-01', '2023-12-31')
)
SELECT
    CAST(CONVERT(VARCHAR, DATEADD(DAY, n, '2016-01-01'), 112) AS INT) AS date_key, 
    DATEADD(DAY, n, '2016-01-01') AS full_date,
    DATENAME(WEEKDAY, DATEADD(DAY, n, '2016-01-01')) AS day_of_week,
    DAY(DATEADD(DAY, n, '2016-01-01')) AS day_of_month,
    DATEPART(DAYOFYEAR, DATEADD(DAY, n, '2016-01-01')) AS day_of_year,
    DATEPART(WEEK, DATEADD(DAY, n, '2016-01-01')) AS week_of_year,
    DATENAME(MONTH, DATEADD(DAY, n, '2016-01-01')) AS month_name,
    MONTH(DATEADD(DAY, n, '2016-01-01')) AS month_number,
    DATEPART(QUARTER, DATEADD(DAY, n, '2016-01-01')) AS quarter,
    YEAR(DATEADD(DAY, n, '2016-01-01')) AS year,
    CASE 
        WHEN DATENAME(WEEKDAY, DATEADD(DAY, n, '2016-01-01')) IN ('Saturday', 'Sunday') THEN 1 
        ELSE 0 
    END AS is_weekend
FROM Numbers;
