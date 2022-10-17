








---- 1. List all the cities in the Texas and the numbers of customers in each city.----

SELECT DISTINCT city, count(customer_id) as count_cust
FROM SALE.CUSTOMER
WHERE state = 'TX'
GROUP BY (city)


---- 2. List all the cities in the California which has more than 5 customer, by showing the cities which have more customers first.---
SELECT city, count(customer_id) as customer_first
FROM sale.customer
WHERE state = 'CA'
GROUP BY city
HAVING count(customer_id) >5
ORDER BY customer_first 



---- 3. List the top 10 most expensive products----

SELECT TOP 10 product_name, list_price 
FROM product.product
ORDER BY list_price desc



---- 4. List store_id, product name and list price and the quantity of the products 
---- which are located in the store id 2 and the quantity is greater than 25----


SELECT ps.store_id, pp.product_name, pp.list_price, ps.quantity
FROM product.stock ps, product.product pp
WHERE ps.product_id = pp.product_id and ps.store_id = 2 and ps.quantity > 25
ORDER BY quantity

---- 5. Find the sales order of the customers who lives in Boulder order by order date----

SELECT sc.first_name, sc.last_name, order_date, sc.city
FROM sale.orders so, sale.customer sc
WHERE so.customer_id = sc.customer_id and sc.city = 'Boulder'
ORDER BY order_date

---- 6. Get the sales by staffs and years using the AVG() aggregate function.

SELECT ss.first_name, ss.last_name,
     YEAR(so.order_date) as order_year,
     AVG(soi.quantity*soi.list_price*(1-soi.discount)) as sales
FROM sale.staff as ss
JOIN sale.orders as so
     ON ss.staff_id=so.staff_id
JOIN sale.order_item as soi
     ON so.order_id=soi.order_id
GROUP BY so.staff_id, ss.first_name, ss.last_name, YEAR(so.order_date)
ORDER BY so.staff_id, YEAR(so.order_date)



---- 7. What is the sales quantity of product according to the brands and sort them highest-lowest----

SELECT SUM(C.quantity) Quantity, B.brand_name
FROM product.product A, product.brand B, sale.order_item C
WHERE A.brand_id = B.brand_id
AND A.product_id = C.product_id
GROUP BY B.brand_name
ORDER BY Quantity DESC;


----GROUP BY DENEME
SELECT SUM(C.quantity) Quantity, B.brand_name, A.product_name
FROM product.product A, product.brand B, sale.order_item C
WHERE A.brand_id = B.brand_id
AND A.product_id = C.product_id
GROUP BY B.brand_name, A.product_name
ORDER BY brand_name 

SELECT SUM(C.quantity) Quantity, B.brand_name
FROM product.product A, product.brand B, sale.order_item C
WHERE A.brand_id = B.brand_id
AND A.product_id = C.product_id
GROUP BY B.brand_name
ORDER BY brand_name 
-----

SELECT sum(soi.quantity) as quantity, pb.brand_name
FROM product.product pp
JOIN sale.order_item soi
     on pp.product_id = soi.product_id
JOIN product.brand pb
     on pp.brand_id = pb.brand_id
GROUP BY brand_name
ORDER BY quantity desc

select C.brand_name, SUM(quantity) as total_of_sales 
from sale.order_item A
join product.product AS B
ON A.product_id = B.product_id
join product.brand AS C
ON B.brand_id = C.brand_id
group by brand_name
order by total_of_sales DESC;



---- 8. What are the categories that each brand has?----

SELECT DISTINCT pb.brand_name, pc.category_name
FROM product.product pp, product.brand pb, product.category pc
WHERE pp.brand_id = pb.brand_id and pp.category_id = pc.category_id
ORDER BY brand_name desc

SELECT C.brand_name, A.category_name
FROM product.category AS A, product.product AS B, product.brand AS C
WHERE A.category_id = B.category_id AND B.brand_id = C.brand_id
GROUP BY brand_name, category_name
ORDER BY brand_name DESC;


---- 9. Select the avg prices according to brands and categories----
SELECT pb.brand_name, pc.category_name, avg(pp.list_price) AS average_price
FROM product.product pp, product.brand pb, product.category pc
WHERE pp.brand_id = pb.brand_id and pp.category_id = pc.category_id
GROUP BY pb.brand_name, pc.category_name
ORDER BY average_price desc


---- 10. Select the annual amount of product produced according to brands----
SELECT brand_name, pp.model_year, sum(quantity) AS annual_amount
FROM product.product pp, product.brand pb, product.stock ps
WHERE pp.brand_id = pb.brand_id and pp.product_id = ps.product_id
GROUP BY brand_name, model_year
ORDER BY brand_name, model_year




SELECT A.brand_name, A.model_year, sum(B.quantity) AS qUANTÝTY
FROM product.product A, product.brand B, product.stock C 
WHERE A.brand_id = B.brand_id 
and A.product_id = C.product_id
GROUP BY brand_name, model_year
ORDER BY brand_name, model_year


select A.model_year, C.brand_name, sum(B.quantity+D.quantity) Quantity
from product.product A, product.stock B,product.brand C, sale.order_item D
where A.product_id=B.product_id
and A.brand_id=C.brand_id
and D.product_id=A.product_id
group by  C.brand_name, A.model_year
order by C.brand_name, A.model_year
---- 11. Select the store which has the most sales quantity in 2018.----

SELECT TOP 1 so.store_id, sst.store_name, sum(quantity) AS sales_quantity_2018
FROM sale.orders so, sale.order_item soi, sale.store sst
WHERE so.order_id = soi.order_id AND so.store_id = sst.store_id AND order_date BETWEEN '2018-01-01' AND '2018-12-31'
GROUP BY so.store_id, sst.store_name
ORDER BY sales_quantity_2018 DESC

---- 12 Select the store which has the most sales amount in 2018.----

SELECT TOP 1 so.store_id, sst.store_name, sum(quantity*list_price*(1-discount)) AS sales_amount_2018
FROM sale.orders so, sale.order_item soi, sale.store sst
WHERE so.order_id = soi.order_id AND so.store_id = sst.store_id AND order_date BETWEEN '2018-01-01' AND '2018-12-31'
GROUP BY so.store_id, sst.store_name
ORDER BY sales_amount_2018 DESC

---- 13. Select the personnel which has the most sales amount in 2019.----

SELECT TOP 1 so.staff_id, sst.first_name, sst.last_name, sum(quantity*list_price*(1-discount)) AS sales_amount_2019
FROM sale.orders so, sale.order_item soi, sale.staff sst
WHERE so.order_id = soi.order_id AND so.staff_id = sst.staff_id AND order_date BETWEEN '2019-01-01' AND '2019-12-31'
GROUP BY so.staff_id, sst.first_name, sst.last_name
ORDER BY sales_amount_2019 DESC
