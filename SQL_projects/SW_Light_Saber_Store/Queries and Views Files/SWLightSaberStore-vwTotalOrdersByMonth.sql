USE [SWLightSaberStore]
GO

/****** Object:  View [dbo].[vwTotalOrdersByMonth]    Script Date: 1/12/2025 3:48:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwTotalOrdersByMonth]

AS 

SELECT 
MONTH(o.Order_Date) as 'Month', COUNT(o.id) as 'Total_Orders'
FROM Orders o
GROUP BY MONTH(o.Order_Date)
GO


