USE [SWLightSaberStore]
GO

/****** Object:  View [dbo].[vwOrdersByCustomer]    Script Date: 1/12/2025 3:47:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwOrdersByCustomer]

AS 

SELECT 
c.Id as 'Customer_Id',CONCAT(c.FirstName, ' ', c.LastName) as 'Customer', c.Email, COUNT(o.id) as 'OrderCount'
FROM Customer c 
JOIN Customer_Address ca ON ca.Customer_Id = c.Id
LEFT JOIN Orders o ON o.Customer_Id = c.id 
GROUP BY c.Id, c.FirstName, c.LastName, c.Email;
GO


