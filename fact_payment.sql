USE DWH_task2;

CREATE EXTERNAL TABLE [Fact_Payment]
WITH (
    LOCATION = 'fact_payment.csv',
    DATA_SOURCE = [csvfiles_synwarehousetask_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
) AS
SELECT
    p.payment_id AS payment_key,      -- Surrogate key
    r.rider_id AS rider_key,          -- Foreign key to Dim_Rider
    d.date_key AS payment_date_key,   -- Foreign key to Dim_Date
    p.amount                          -- Payment amount
FROM 
    staging_payment p
JOIN 
    Dim_Rider r ON p.account_number = r.account_number
JOIN 
    Dim_Date d ON CAST(CONVERT(VARCHAR, p.date, 112) AS INT) = d.date_key;
