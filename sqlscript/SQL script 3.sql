--First create dedicated sql pool and then connect to it while writing the script
--create table inside the db..
CREATE TABLE [dbo].[employees]
(
    empID INT NOT NULL,
    empName NVARCHAR(50),
    gender NVARCHAR(20),
    dept NVARCHAR(20)
)
WITH
(
   DISTRIBUTION = HASH(empID),
   CLUSTERED COLUMNSTORE index
);
GO


--inserting data into the table
INSERT INTO [dbo].[employees] VALUES (1,'Navya','Female','IT');
INSERT INTO [dbo].[employees] VALUES (2,'Gaanavi','Female','HR');
INSERT INTO [dbo].[employees] VALUES (3,'Sahasra','Female','Sales');
INSERT INTO [dbo].[employees] VALUES (4,'Nikshit','Male','Sales');
INSERT INTO [dbo].[employees] VALUES (5,'Chaitanya','Male','Research');
INSERT INTO [dbo].[employees] VALUES (6,'Ramya','Female','HR');
INSERT INTO [dbo].[employees] VALUES (7,'Phani','Male','IT');
INSERT INTO [dbo].[employees] VALUES (8,'Gayatri','Female','IT');
INSERT INTO [dbo].[employees] VALUES (9,'Srinidhi','Female','HR');
INSERT INTO [dbo].[employees] VALUES (10,'Sri Maha','Female','Sales');
GO

select * from [dbo].[employees] ORDER by empID


--CTAS --creating another table by inserting the data from the previous table.. with same column for hashing

CREATE TABLE [dbo].[employees_1]
WITH
(
    DISTRIBUTION = HASH(empID),
    CLUSTERED COLUMNSTORE INDEX
)
AS 
SELECT * from [dbo].[employees] WHERE dept = 'IT' 
GO

--checking the data inside the 2nd table

select * from [dbo].[employees_1] ORDER BY empID



--CTAS --creating another table by inserting the data from the previous table.. with different column for hashing

CREATE TABLE [dbo].[employees_2]
WITH
(
    DISTRIBUTION = HASH(empName),
    CLUSTERED COLUMNSTORE INDEX
)
AS 
SELECT * from [dbo].[employees] WHERE dept = 'IT' 
GO

--checking the data inside the 2nd table

select * from [dbo].[employees_2] ORDER BY empID



--CTAS --creating another table by inserting the data from the previous table.. with different distribution

CREATE TABLE [dbo].[employees_3]
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
)
AS 
SELECT * from [dbo].[employees] WHERE dept = 'IT' 
GO

--checking the data inside the 2nd table

select * from [dbo].[employees_3] ORDER BY empID
