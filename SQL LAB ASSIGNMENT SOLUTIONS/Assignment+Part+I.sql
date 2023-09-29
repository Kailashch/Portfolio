use supply_db ;


/*Question : Golf related products

List all products in categories related to golf. Display the Product_Id, Product_Name in the output. Sort the output in the order of product id.
Hint: You can identify a Golf category by the name of the category that contains golf. 
*/
SOLUTION:-

SELECT 
Product_Name, Product_Id
FROM product_info AS p
INNER JOIN category AS c
ON p.Category_Id = c.Id
WHERE c.Name LIKE "%golf%"
ORDER BY Product_Id;

-- **********************************************************************************************************************************


/*Question : Most sold golf products

Find the top 10 most sold products (based on sales) in categories related to golf. Display the Product_Name and Sales column in the output. Sort the output in the descending order of sales.
Hint: You can identify a Golf category by the name of the category that contains golf.

HINT:
Use orders, ordered_items, product_info, and category tables from the Supply chain dataset.
*/
SOLUTION:- 

SELECT Product_Name,
SUM(Sales) AS Sales
FROM orders AS o 
INNER JOIN ordered_items AS oi 
USING (Order_Id)
INNER JOIN product_info AS pi 
ON oi.Item_Id = pi.Product_Id
INNER JOIN category AS c 
ON pi.Category_Id = c.Id 
WHERE Name LIKE "%golf%"
GROUP BY Product_Name
ORDER BY Sales desc 
LIMIT 10;

-- **********************************************************************************************************************************


/*Question: Segment wise orders

Find the number of orders by each customer segment for orders. Sort the result from the highest to the lowest 
number of orders.The output table should have the following information:
-Customer_segment
-Orders
*/
SOLUTION:-

SELECT Segment AS customer_segment,
COUNT(Order_Id) AS Orders
FROM customer_info AS ci 
INNER JOIN orders AS o
ON ci.Id = o.Customer_Id
GROUP BY Segment
ORDER BY Orders DESC;



-- **********************************************************************************************************************************

/*Question : Percentage of order split

Description: Find the percentage of split of orders by each customer segment for orders that took six days 
to ship (based on Real_Shipping_Days). Sort the result from the highest to the lowest percentage of split orders,
rounding off to one decimal place. The output table should have the following information:
-Customer_segment
-Percentage_order_split

HINT:
Use the orders and customer_info tables from the Supply chain dataset.
*/
SOLUTION:-

WITH order_seg AS
(
SELECT ci.segment AS customer_segment,
COUNT(o.order_id) AS orders
FROM orders o
LEFT JOIN customer_info ci
ON o.customer_id = ci.id
WHERE real_shipping_days=6
GROUP BY 1
)
SELECT a.customer_segment,
ROUND(a.orders/SUM(b.orders)*100,1) AS percentage_order_split
FROM order_seg AS a
JOIN order_seg AS b
GROUP BY 1
ORDER BY 2 DESC;


-- **********************************************************************************************************************************
