--create database
create DATABASE demoDb
GO

--Use this database as primary..by default master will be there
use demoDb
Go


--Create master key encryption usinh scoped credential
create MASTER KEY ENCRYPTION BY PASSWORD = 'Password@123'
GO

CREATE DATABASE SCOPED CREDENTIAL myCredential
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
secret = 'SAS TOKEN'
--this secret key can be found inside storage account in shared access signature-genaerate sas token--
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
    LOCATION = 'synapsecontainer/NYCTaxi/DATA',               --location inside the synapse container--
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

    BULK 'https://synapsestorage1505.dfs.core.windows.net/synapsecontainer/NYCTaxi/DATA/AC33B604-2030-4E4C-ACB8-3F4E5256968F_2_0-1.parquet',
    FORMAT = 'parquet'
) 
AS[result]



