USE [SWLightSaberStore]
GO

/****** Object:  View [dbo].[vwOrdersByCustomerType]    Script Date: 1/12/2025 3:48:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwOrdersByCustomerType]

AS 

SELECT 
SUM(OrderCount) AS 'Orders'
,New_Customer
FROM 
(
SELECT 
c.Id as 'Customer_Id', 
CASE WHEN c.New_Customer = 1 THEN 'New' ELSE 'Old' END AS 'New_Customer',
COUNT(o.id) as 'OrderCount'
FROM Customer c 
JOIN Customer_Address ca ON ca.Customer_Id = c.Id
LEFT JOIN Orders o ON o.Customer_Id = c.id 
GROUP BY c.Id, CASE WHEN c.New_Customer = 1 THEN 'New' ELSE 'Old' END
) a
GROUP BY New_Customer
GO


