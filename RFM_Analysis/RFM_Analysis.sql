
CREATE DATABASE RFM_SegmentSales
COLLATE Latin1_General_CI_AS;

select * from dbo.sales_data_sample

--CHecking unique values
select distinct status from [dbo].[sales_data_sample] --Nice one to plot
select distinct YEAR_ID from [dbo].[sales_data_sample]
select distinct PRODUCTLINE from [dbo].[sales_data_sample] ---Nice to plot
select distinct COUNTRY from [dbo].[sales_data_sample] ---Nice to plot
select distinct DEALSIZE from [dbo].[sales_data_sample] ---Nice to plot
select distinct TERRITORY from [dbo].[sales_data_sample] ---Nice to plot

select distinct MONTH_ID from [dbo].[sales_data_sample]
where YEAR_ID = 2005

---ANALYSIS
----Let's start by grouping sales by productline
select PRODUCTLINE, sum(sales) Revenue
from [dbo].[sales_data_sample]
group by PRODUCTLINE
order by 2 desc

----Let's start by grouping sales by year
select YEAR_ID, sum(sales) Revenue
from [dbo].[sales_data_sample]
group by YEAR_ID
order by 2 desc

----Let's start by grouping sales by deal size
select  DEALSIZE,  sum(sales) Revenue
from [dbo].[sales_data_sample]
group by  DEALSIZE
order by 2 desc


----What was the best month for sales in a specific year? How much was earned that month? 
select  MONTH_ID, sum(sales) Revenue, count(ORDERNUMBER) Frequency
from [dbo].[sales_data_sample]
where YEAR_ID = 2003 --change year to see the rest
group by  MONTH_ID
order by 2 desc


--November seems to be the month, what product do they sell in November, Classic I believe
select  MONTH_ID, PRODUCTLINE, sum(sales) Revenue, count(ORDERNUMBER) Frequency
from [dbo].[sales_data_sample]
where YEAR_ID = 2003 and MONTH_ID = 11 --change year to see the rest
group by  MONTH_ID, PRODUCTLINE
order by 3 desc

--RFM ANALYSÝS
---*Recency   : last order date
---*Frequency :count of total orders
---*Monetary  :total spend

select*
from sales_data_sample

--
SELECT  CUSTOMERNAME ,
		sum(SALES) MonetaryValue,
		avg(SALES) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date
from [dbo].[sales_data_sample]
group by CUSTOMERNAME


---
SELECT  CUSTOMERNAME ,
		sum(SALES) MonetaryValue,
		avg(SALES) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,--Her müþteri için sipariþ sayýsýný bulur.
		max(ORDERDATE) last_order_date,--Her müþterinin en son yapýlan sipariþin tarihini bulur.
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date--Tüm müþterilerin sipariþ verdiði tarihin en yenisini bulur.
from [dbo].[sales_data_sample]
group by CUSTOMERNAME


--- müþterilerin toplam satýþ, ortalama satýþ, sipariþ sayýsý, en son sipariþ tarihi ve genel olarak en yeni sipariþ tarihini gösterir. 

select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
from [dbo].[sales_data_sample]
group by CUSTOMERNAME


-- müþteri bazýnda RFM analizine dayalý istatistiksel bilgileri içeren bir tablo oluþturur ve bu tablodan tüm sütunlarý seçer

;with rfm as -- "rfm" adýnda bir geçici tablo (Common Table Expression - CTE) oluþturur
(
	select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
	from [dbo].[sales_data_sample]
	group by CUSTOMERNAME
)
SELECT r.* FROM rfm r -- Oluþturulan rfm geçici tablosundan tüm sütunlarý seçer.



--RFM analizi sonuçlarýna dayalý olarak müþterileri Recency, Frequency ve MonetaryValue özelliklerine göre dört eþit gruba böler.
;with rfm as -- "rfm" adýnda bir geçici tablo (Common Table Expression - CTE) oluþturur
(
	select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
	from [dbo].[sales_data_sample]
	group by CUSTOMERNAME
)
SELECT r.* ,
       NTILE(4) OVER (order by Recency desc) rfm_recency,--Recency deðerlerini büyükten küçüðe sýralayarak her müþteriyi dört eþit gruba böler (dört kuartile).
	   NTILE(4) OVER (order by Frequency) rfm_frequency,--Frequency deðerlerini küçükten büyüðe sýralayarak her müþteriyi dört eþit gruba böler.
	   NTILE(4) OVER (order by MonetaryValue) rfm_monetary--MonetaryValue deðerlerini küçükten büyüðe sýralayarak her müþteriyi dört eþit gruba böler.
FROM rfm r

---NEXT
;with rfm as -- "rfm" adýnda bir geçici tablo (Common Table Expression - CTE) oluþturur
(
	SELECT 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
	FROM [dbo].[sales_data_sample]
	GROUP BY CUSTOMERNAME
),--Yukarýda rfm adýnda geçici tablo(CTE)oluþturdu.
rfm_calc as
(
SELECT r.* ,
       NTILE(4) OVER (order by Recency desc) rfm_recency,--Recency deðerlerini büyükten küçüðe sýralayarak her müþteriyi dört eþit gruba böler (dört kuartile).
	   NTILE(4) OVER (order by Frequency) rfm_frequency,--Frequency deðerlerini küçükten büyüðe sýralayarak her müþteriyi dört eþit gruba böler.
	   NTILE(4) OVER (order by MonetaryValue) rfm_monetary--MonetaryValue deðerlerini küçükten büyüðe sýralayarak her müþteriyi dört eþit gruba böler.
FROM rfm r
)--Ardýndan, rfm_calc adýnda bir baþka CTE oluþturulur. Bu CTE, rfm tablosundan gelen verileri kullanarak her bir müþteriyi Recency,
--Frequency ve MonetaryValue deðerlerine göre dört eþit gruba bölen NTILE fonksiyonu kullanýlarak RFM segmentlerini hesaplar.
SELECT c.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell
FROM rfm_calc c
--Bu son sorgu, rfm_calc tablosundan gelen verilerle birlikte her bir müþterinin RFM hücre deðerini (rfm_cell) içeren sonuç kümesini döndürür. 
--RFM hücre deðeri, Recency, Frequency ve MonetaryValue deðerlerinin toplamýdýr.
--Bu deðer, müþteriyi belirli bir segmente yerleþtirmek için kullanýlabilir. 

--NEXT
;with rfm as -- "rfm" adýnda bir geçici tablo (Common Table Expression - CTE) oluþturur
(
	SELECT 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
	FROM [dbo].[sales_data_sample]
	GROUP BY CUSTOMERNAME
),--Yukarýda rfm adýnda geçici tablo(CTE)oluþturdu.
rfm_calc as
(
SELECT r.* ,-- ifadesi, rfm tablosundaki tüm sütunlarý seçer.
       NTILE(4) OVER (order by Recency desc) rfm_recency,--Recency deðerlerini büyükten küçüðe sýralayarak her müþteriyi dört eþit gruba böler (dört kuartile).
	   NTILE(4) OVER (order by Frequency) rfm_frequency,--Frequency deðerlerini küçükten büyüðe sýralayarak her müþteriyi dört eþit gruba böler.
	   NTILE(4) OVER (order by MonetaryValue) rfm_monetary--MonetaryValue deðerlerini küçükten büyüðe sýralayarak her müþteriyi dört eþit gruba böler.
FROM rfm r
)
SELECT c.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
       cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary  as varchar)rfm_cell_string
FROM rfm_calc c


---NEXT
--IF OBJECT_ID('tempdb..#rfm') IS NOT NULL DROP TABLE #rfm; BU KISIM ALTERNATÝF YÖNTEM

DROP TABLE IF EXISTS #rfm--Eðer #rfm adýnda bir geçici tablo zaten varsa, bu tabloyu siler. 
                          --Bu, her sorgu çalýþtýðýnda temiz bir baþlangýç saðlamak için yapýlýr.
;with rfm as 
(
	select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
	from [dbo].[sales_data_sample]
	group by CUSTOMERNAME
),
rfm_calc as
(

	select r.*,-- ifadesi, rfm tablosundaki tüm sütunlarý seçer.
		NTILE(4) OVER (order by Recency desc) rfm_recency,
		NTILE(4) OVER (order by Frequency) rfm_frequency,
		NTILE(4) OVER (order by MonetaryValue) rfm_monetary
	from rfm r
)
select 
	c.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
	cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary  as varchar)rfm_cell_string
into #rfm
from rfm_calc c
--SELECT ... INTO #rfm ...: Bu kýsým, rfm_calc tablosundan gelen verilerle birlikte, her bir müþterinin RFM hücre deðerini (rfm_cell)
--içeren sonuç kümesini oluþturur ve bu verileri #rfm adýndaki geçici tabloya ekler. Ayrýca, rfm_recency, rfm_frequency, 
--ve rfm_monetary deðerlerini birleþtirerek bir karakter dizesi oluþturup rfm_cell_string adýnda bir sütun oluþturur.


--KONTROL EDELÝM..
SELECT *
FROM #rfm





----Who is our best customer (this could be best answered with RFM)
DROP TABLE IF EXISTS #rfm--Eðer #rfm adýnda bir geçici tablo zaten varsa, bu tabloyu siler. 
                         --Bu, her sorgu çalýþtýðýnda temiz bir baþlangýç saðlamak için yapýlýr.
;with rfm as 
(
	select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
	from [dbo].[sales_data_sample]
	group by CUSTOMERNAME
),
rfm_calc as
(

	SELECT r.*,
		NTILE(4) OVER (order by Recency DESC) rfm_recency,
		NTILE(4) OVER (order by Frequency) rfm_frequency,
		NTILE(4) OVER (order by MonetaryValue) rfm_monetary
	from rfm r
)
SELECT 
	c.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
	cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary  as varchar)rfm_cell_string
INTO #rfm
FROM rfm_calc c

SELECT CUSTOMERNAME , rfm_recency, rfm_frequency, rfm_monetary,
	CASE
		WHEN rfm_cell_string in (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141) THEN 'lost_customers'  --lost customers
		WHEN rfm_cell_string in (133, 134, 143, 244, 334, 343, 344, 144) then 'slipping away, cannot lose' -- (Big spenders who havent purchased lately) slipping away
		WHEN rfm_cell_string in (311, 411, 331) THEN 'new customers'
		WHEN rfm_cell_string in (222, 223, 233, 322) THEN 'potential churners'
		WHEN rfm_cell_string in (323, 333,321, 422, 332, 432) THEN 'active' --(Customers who buy often & recently, but at low price points)
		WHEN rfm_cell_string in (433, 434, 443, 444) THEN 'loyal'
	END rfm_segment

FROM #rfm
 

SELECT*
FROM sales_data_sample
--What products are most often sold together? 
WITH OrderProducts AS (
    SELECT
        ORDERNUMBER,
        STRING_AGG(PRODUCTLINE, ',') WITHIN GROUP (ORDER BY PRODUCTLINE) AS CombinedProducts
    FROM
        [dbo].[sales_data_sample]
    GROUP BY
        ORDERNUMBER
    HAVING
        COUNT(DISTINCT PRODUCTLINE) > 1
)
SELECT
    DISTINCT CombinedProducts,
    COUNT(*) AS OccurrenceCount
FROM
    OrderProducts
GROUP BY
    CombinedProducts
ORDER BY
    OccurrenceCount DESC;




----Aþagýdaki sorgu 'Shipped' durumundaki sipariþlerin her birinin sipariþ numarasýný ve her bir sipariþin kaç defa tekrarlandýðýný
----içeren bir sonuç kümesini döndürür. rn sütunu, her bir sipariþin tekrar sayýsýný gösterir.
SELECT ORDERNUMBER, count(*) rn-- ORDERNUMBER sütununu ve bu sütundaki deðerlerin kaç defa tekrarlandýðýný sayan bir sayacý (rn) içerir.
FROM [dbo].[sales_data_sample]
WHERE STATUS = 'Shipped'
GROUP BY ORDERNUMBER

--
--SELECT * FROM [dbo].[sales_data_sample] WHERE ORDERNUMBER= 10411

--NEXT
--Bu SQL sorgusu, [dbo].[sales_data_sample] tablosundan "Shipped" (gönderilmiþ) durumundaki sipariþleri içeren ve her bir sipariþ
--numarasýnýn kaç defa tekrarlandýðýný sayan bir alt sorgu içerir. Daha sonra, bu alt sorgunun sonucunda elde edilen geçici tablo 
--veya sonuç kümesi üzerinde rn (row number) deðeri 3 olan sipariþ numaralarýný seçer.
SELECT ORDERNUMBER FROM
   (
	SELECT ORDERNUMBER, count(*) rn-- ORDERNUMBER sütununu ve bu sütundaki deðerlerin kaç defa tekrarlandýðýný sayan bir sayacý (rn) içerir.(row number)
	FROM [dbo].[sales_data_sample]
	WHERE STATUS = 'Shipped'
	GROUP BY ORDERNUMBER
	)m--oluþturulan geçici tabloya bir takma ad (alias) verir
WHERE rn = 3


--NEXTT
SELECT ',' + PRODUCTCODE
FROM [dbo].[sales_data_sample]
WHERE ORDERNUMBER IN(
	SELECT ORDERNUMBER FROM
	   (
		SELECT ORDERNUMBER, count(*) rn-- ORDERNUMBER sütununu ve bu sütundaki deðerlerin kaç defa tekrarlandýðýný sayan bir sayacý (rn) içerir.(row number)
		FROM [dbo].[sales_data_sample]
		WHERE STATUS = 'Shipped'
		GROUP BY ORDERNUMBER
		)m--oluþturulan geçici tabloya bir takma ad (alias) verir
	WHERE rn = 2
	)
	FOR XML PATH('')--SQL sorgusunda, sonuç kümesini bir XML belgesine dönüþtürmek için kullanýlýr. Bu ifade, 
	                --sorgu sonuçlarýný XML formatýnda birleþtirilmiþ bir dize olarak döndürmeye olanak tanýr.

--NEXTTT
SELECT stuff(  --STUFF fonksiyonu ise baþtaki virgülü kaldýrarak düzgün birleþmiþ bir dize elde etmeye yardýmcý olur.

	(SELECT ',' + PRODUCTCODE
	 FROM [dbo].[sales_data_sample]
	 WHERE ORDERNUMBER IN
	      (
		   SELECT ORDERNUMBER FROM
		   (
			SELECT ORDERNUMBER, count(*) rn-- ORDERNUMBER sütununu ve bu sütundaki deðerlerin kaç defa tekrarlandýðýný sayan bir sayacý (rn) içerir.(row number)
			FROM [dbo].[sales_data_sample]
			WHERE STATUS = 'Shipped'
			GROUP BY ORDERNUMBER
			)m--oluþturulan geçici tabloya bir takma ad (alias) verir
		WHERE rn = 2--(yani, iki farklý ürün içeren sipariþler)
		)
		FOR XML PATH(''))
		,1,1,'')



--NEXTTT
SELECT DISTINCT ORDERNUMBER, STUFF(
	(SELECT ',' + PRODUCTCODE
	 FROM [dbo].[sales_data_sample] p
	 WHERE ORDERNUMBER IN
	      (
		   SELECT ORDERNUMBER 
		   FROM(
			   SELECT ORDERNUMBER, count(*) rn-- ORDERNUMBER sütununu ve bu sütundaki deðerlerin kaç defa tekrarlandýðýný sayan bir sayacý (rn) içerir.(row number)
			   FROM [dbo].[sales_data_sample]
			   WHERE STATUS = 'Shipped'
			   GROUP BY ORDERNUMBER
			    )m--oluþturulan geçici tabloya bir takma ad (alias) verir
		   WHERE rn = 2
		  )
	  AND p.ORDERNUMBER = s.ORDERNUMBER
	  FOR XML PATH(''))
		,1,1,'') ProductCodes
FROM [dbo].[sales_data_sample] s
ORDER BY 2 DESC



-----EXTRAs----
--What city has the highest number of sales in a specific country
select CITY, sum (sales) Revenue
from [dbo].[sales_data_sample]
where country = 'UK'
group by CITY
order by 2 desc



---What is the best product in United States?
select country, YEAR_ID, PRODUCTLINE, sum(sales) Revenue
from [dbo].[sales_data_sample]
where country = 'USA'
group by  country, YEAR_ID, PRODUCTLINE
order by 4 desc


select * from sales_data_sample

--En Fazla Ürün Çeþidi Satýn Alan Müþteriler:
SELECT
    CUSTOMERNAME,
    COUNT(DISTINCT PRODUCTCODE) AS UniqueProductsCount
FROM [dbo].[sales_data_sample]
GROUP BY CUSTOMERNAME
ORDER BY UniqueProductsCount DESC;


--Her Müþteri Ýçin En Yüksek Tutarlý Sipariþ:
SELECT 
    CUSTOMERNAME,
    ORDERNUMBER,
    MAX(sales) AS MaxOrderAmount
FROM [dbo].[sales_data_sample]
GROUP BY CUSTOMERNAME, ORDERNUMBER
ORDER BY MaxOrderAmount DESC;


---Bu sorgu, her bir ayýn altýnda farklý ürün kategorileri ve bu kategorilere ait toplam satýþlarý içeren bir pivot tablosu oluþturur. 
WITH OrderCategoryTotals AS --geçici bir tablo (CTE) oluþturulur. Bu tablo, sipariþ tarihlerini yýl ve ay düzeyinde gruplandýrýr
                             --ve her bir ürün kategorisi için toplam satýþ miktarýný hesaplar.
  (
	SELECT
        CONVERT(VARCHAR(7), ORDERDATE, 120) AS OrderMonth,--VARCHAR(7): Bu, dönüþtürülen karakter dizisinin maksimum uzunluðunu belirtir.
		                                                  --Yani, en fazla 7 karakter uzunluðunda bir karakter dizisi oluþturulacaktýr.
														  --120: Bu, tarih ve saat biçimini belirten bir stil kodudur. 120 stili, 
														  --"yyyy-mm" yýl ve ay formatýndaki bir tarih biçimini ifade eder.
        PRODUCTLINE,
        SUM(SALES) AS TotalSales
    FROM [dbo].[sales_data_sample]
    GROUP BY CONVERT(VARCHAR(7), ORDERDATE, 120), PRODUCTLINE
  )

SELECT
    *
FROM
    (
        SELECT 
            OrderMonth,
            PRODUCTLINE,
            TotalSales
        FROM OrderCategoryTotals
    ) AS SourceTable
PIVOT
(
    SUM(TotalSales)
    FOR PRODUCTLINE IN ([Classic Cars], [Trucks and Buses], [Planes], [Vintage Cars], [Motorcycles], [Ships], [Trains])
) AS PivotTable
ORDER BY OrderMonth;


--PRODUCTLINE'a göre toplam satýþlarý ve yýllara göre bu toplamlarý içeren bir tablo olacaktýr. 
SELECT
    *
FROM 
    (
        SELECT 
            YEAR_ID,
            PRODUCTLINE,
            SALES
        FROM sales_data_sample
    ) AS DENEME
PIVOT
   (
    SUM(SALES)
    FOR YEAR_ID IN ([2003], [2004], [2005])
   )
 AS PivotTable
ORDER BY 2 DESC;


