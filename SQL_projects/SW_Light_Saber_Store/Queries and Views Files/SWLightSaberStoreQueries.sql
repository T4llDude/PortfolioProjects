--Orders by Customer
SELECT 
c.Id as 'Customer_Id',CONCAT(c.FirstName, ' ', c.LastName) as 'Customer', c.Email, COUNT(o.id) as 'OrderCount'
FROM Customer c 
JOIN Customer_Address ca ON ca.Customer_Id = c.Id
LEFT JOIN Orders o ON o.Customer_Id = c.id 
GROUP BY c.Id, c.FirstName, c.LastName, c.Email

--Orders by Customer type
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

--Total Sales by Month
SELECT 
MONTH(o.Order_Date) as 'Month', 
CAST(SUM(o.order_Total) as MONEY) as 'Total_Sales'
FROM Orders o
GROUP BY MONTH(o.Order_Date)

--Total Orders by Month
SELECT 
MONTH(o.Order_Date) as 'Month', COUNT(o.id) as 'Total_Orders'
FROM Orders o
GROUP BY MONTH(o.Order_Date)


--Most Popular products
SELECT 
p.Product_Desc as 'Product', COUNT(o.id) as 'Number_Of_Orders'
FROM Orders o 
JOIN Products p ON p.Id = o.Product_Id
GROUP BY p.Product_Desc
ORDER BY 2 DESC


--Most Popular product combination
SELECT 
p.Product_Desc as 'Product', pc.Color as 'Product_Color', COUNT(o.id) as 'Number_Of_Orders'
FROM Orders o 
JOIN Products p ON p.Id = o.Product_Id
JOIN Product_Color pc ON pc.Id = o.Product_Color_Id
GROUP BY p.Product_Desc, pc.Color
ORDER BY 3 DESC