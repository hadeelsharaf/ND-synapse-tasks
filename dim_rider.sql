USE DWH_task2;

CREATE EXTERNAL TABLE [Dim_Rider]
WITH (
    LOCATION = 'dim_rider.csv',
    DATA_SOURCE = [csvfiles_synwarehousetask_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
) AS
SELECT
    rider_id AS rider_key,   -- Surrogate key
    first AS first_name,
    last AS last_name,
    address,
    birthday
FROM staging_rider;
