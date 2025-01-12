USE [SWLightSaberStore]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwMostPopularProducts]

AS 

SELECT 
p.Product_Desc as 'Product', COUNT(o.id) as 'Number_Of_Orders'
FROM Orders o 
JOIN Products p ON p.Id = o.Product_Id
GROUP BY p.Product_Desc
GO


