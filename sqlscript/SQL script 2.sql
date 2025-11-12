--create database
create DATABASE demoDb1
GO

--Use this database as primary..by default master will be there
use demoDb1
Go


--Create master key encryption using Managed identity--no need to pass the storage account sas token here..
create MASTER KEY ENCRYPTION BY PASSWORD = 'Password@123'
GO

CREATE DATABASE SCOPED CREDENTIAL myCredential
WITH IDENTITY = 'Managed identity'
GO


--create external datasource
create EXTERNAL DATA SOURCE  myDataSource with(

    LOCATION = 'https://synapsestorage1505.blob.core.windows.net/',   --location can be found in accountstorage level-settings-primaryendpoint--
    CREDENTIAL = myCredential
)
GO


--create extrenal file format
CREATE EXTERNAL FILE FORMAT parquetFileFormat WITH(
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
)
GO


--create schema
create SCHEMA NYCTaxi
GO


--create external table inside the schema(cetas)

CREATE EXTERNAL TABLE NYCTaxi.passengerDetails WITH(
    LOCATION = 'synapsecontainer/NYCTaxi_2/DATA',               --location inside the synapse container--
    DATA_SOURCE = myDataSource,
    FILE_FORMAT = parquetFileFormat
)
AS
SELECT TOP 100 * FROM
OPENROWSET(

    BULK 'https://synapsestorage1505.dfs.core.windows.net/synapsecontainer/Data/NYCTripSmall.parquet',
    FORMAT = 'parquet'
) 
AS[result]
GO

--to check the data in the extrenal db
select * from NYCTaxi.passengerDetails

--can also do this by reading the parquet file in the extrnal datasource location..
SELECT TOP 100 * FROM
OPENROWSET(

    BULK 'https://synapsestorage1505.dfs.core.windows.net/synapsecontainer/NYCTaxi_2/DATA/98A04E24-7493-49DF-A1CB-30561682C3CA_6_0-1.parquet',
    FORMAT = 'parquet'
) 
AS[result]



