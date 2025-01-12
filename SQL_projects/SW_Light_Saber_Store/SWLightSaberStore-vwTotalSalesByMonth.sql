USE [SWLightSaberStore]
GO

/****** Object:  View [dbo].[vwTotalSalesByMonth]    Script Date: 1/12/2025 3:48:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwTotalSalesByMonth]

AS 

SELECT 
MONTH(o.Order_Date) as 'Month', 
CAST(SUM(o.order_Total) as MONEY) as 'Total_Sales'
FROM Orders o
GROUP BY MONTH(o.Order_Date)
GO


