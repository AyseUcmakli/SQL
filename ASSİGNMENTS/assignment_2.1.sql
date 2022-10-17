

                                     --**Product Sales**--
--You need to create a report on whether customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.
-- 'Polk Audio - 50 W Woofer - Black' -- (other_product)
--To generate this report, you are required to use the appropriate SQL Server Built-in functions or expressions as well as basic SQL knowledge.


--*
select *
from product.product
where product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

SELECT *
FROM sale.order_item

SELECT *
FROM  sale.orders

SELECT *
FROM sale.customer

--**
--find product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
SELECT DISTINCT D.customer_id, D.First_Name, D.Last_Name
FROM product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE A.product_id = B.product_id 
AND B.order_id = C.order_id
AND C.customer_id = D.customer_id 
AND product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

--***
-- create a new wiew named product_HDD
CREATE VIEW product_HDD
AS
SELECT DISTINCT A.customer_id, A.First_Name, A.Last_Name
      FROM sale.customer A, sale.orders B, sale.order_item C, product.product D
      WHERE A.customer_id = B.customer_id
      AND B.order_id = C.order_id
      AND C.product_id = D.product_id
      AND D.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
--****
----find product named 'Polk Audio - 50 W Woofer - Black' 
SELECT DISTINCT D.customer_id, D.First_Name, D.Last_Name
FROM product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE A.product_id = B.product_id 
AND B.order_id = C.order_id
AND C.customer_id = D.customer_id 
AND product_name = 'Polk Audio - 50 W Woofer - Black'

--*****
-- create a new wiew named product_Polk
CREATE VIEW product_Polk
AS
SELECT DISTINCT D.customer_id, D.First_Name, D.Last_Name
FROM product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE A.product_id = B.product_id 
AND B.order_id = C.order_id
AND C.customer_id = D.customer_id 
AND product_name = 'Polk Audio - 50 W Woofer - Black'

--******
SELECT* ,'YES' Other_Product
FROM product_HDD 
WHERE customer_id IN 
                    (
					SELECT customer_id
					FROM product_Polk
					)
          
SELECT* ,'NO' Other_Product
FROM product_HDD 
WHERE customer_id NOT IN 
                       (
					   SELECT customer_id
					   FROM product_Polk
					   )

--********
--create a new wiew named buy_one and buy_both 
CREATE VIEW buy_both AS
SELECT* ,'YES' Other_Product
FROM product_HDD 
WHERE customer_id IN 
                    (
					SELECT customer_id
					FROM product_Polk
					)

CREATE VIEW buy_one AS
SELECT* ,'NO' Other_Product
FROM product_HDD 
WHERE customer_id NOT IN 
                       (
					   SELECT customer_id
					   FROM product_Polk
					   )

---concat two tables with union
SELECT *
FROM buy_both
UNION
SELECT*
FROM buy_one





