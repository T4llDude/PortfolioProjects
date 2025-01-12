USE [SWLightSaberStore]
GO

/****** Object:  View [dbo].[vwMostPopularProductCombos]    Script Date: 1/12/2025 3:47:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwMostPopularProductCombos]

AS 

SELECT 
p.Product_Desc as 'Product', pc.Color as 'Product_Color', COUNT(o.id) as 'Number_Of_Orders'
FROM Orders o 
JOIN Products p ON p.Id = o.Product_Id
JOIN Product_Color pc ON pc.Id = o.Product_Color_Id
GROUP BY p.Product_Desc, pc.Color
GO


