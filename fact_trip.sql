USE DWH_task2;

CREATE EXTERNAL TABLE [Fact_Trip]
WITH (
    LOCATION = 'fact_trip.csv',
    DATA_SOURCE = [csvfiles_synwarehousetask_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
) AS
SELECT
    t.trip_id AS trip_key,           -- Surrogate key
    r.rider_id AS rider_key,         -- Foreign key to Dim_Rider
    s1.station_id AS start_station_key, -- Foreign key to Dim_Station
    s2.station_id AS end_station_key,   -- Foreign key to Dim_Station
    d.date_key AS trip_date_key,     -- Foreign key to Dim_Date
    DATEDIFF(MINUTE, t.started_at, t.ended_at) AS trip_duration,  -- Trip duration in minutes
    DATEDIFF(YEAR, r.birthday, t.started_at) AS rider_age,        -- Rider age at the time of trip
    t.rideable_type                 -- Type of ride (e.g., bike)
FROM 
    staging_trip t
JOIN 
    Dim_Rider r ON t.rider_id = r.rider_id
JOIN 
    Dim_Station s1 ON t.start_station_id = s1.station_id
JOIN 
    Dim_Station s2 ON t.end_station_id = s2.station_id
JOIN 
    Dim_Date d ON CAST(CONVERT(VARCHAR, t.started_at, 112) AS INT) = d.date_key;
