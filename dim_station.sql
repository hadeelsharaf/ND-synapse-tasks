USE DWH_task2;

CREATE EXTERNAL TABLE [Dim_Station]
WITH (
    LOCATION = 'dim_station.csv',
    DATA_SOURCE = [csvfiles_synwarehousetask_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
) AS
SELECT
    station_id AS station_key,  -- Surrogate key
    name AS station_name,
    latitude,
    longitude
FROM dbo.staging_station;
