

---SQL Server Built-in Functions


--Date formats



CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

select * from t_date_time

SELECT GETDATE() AS TIME---just returns datetime format.

INSERT t_date_time 
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())


select * from t_date_time


INSERT t_date_time 
VALUES ('12:20:00', '2022-09-17','2022-09-17', '2022-09-17', '2022-09-17', '2022-09-17')


-------------////////////////
---DATENAME(datepart, date)-- returns the name or value of a specific part of the date in nvarchar format.
SELECT DATENAME (DW, GETDATE())
SELECT DATENAME(WEEKDAY, '2021-11-11') AS sample;


--DATEPART(datepart, date)--returns the value of a specific part of the date in integer format.
SELECT DATEPART (SECOND, GETDATE())
SELECT DATEPART (MONTH, GETDATE())
SELECT DATEPART(MINUTE, GETDATE()) AS sample;


--DAY(date)--returns the day of the date in integer format.
SELECT DAY (GETDATE())
SELECT DAY('2021-12-15') AS sample;


--MONTH(date)-- returns the month of the date in integer format.
SELECT MONTH (GETDATE())
SELECT MONTH('2021-09-19') AS sample;


--YEAR(date)--returns the year of the date in integer format.
SELECT YEAR (GETDATE())


--DATEDIFF(datepart, startdate, enddate)-- returns the difference between two dates in integer format.
SELECT DATEDIFF(SECOND, '2021-12-21', GETDATE())
SELECT DATEDIFF(week, '2021-01-01', '2021-02-12') AS DateDifference


--ORDER TABLOSUNDAKÝ ORDER DATE ÝLE SHIP DATE ARASINDAKÝ GÜN FARKINI BULUNUZ.

SELECT *
FROM sale.orders

SELECT	*, DATEDIFF(DAY , order_date, shipped_date) shipped_day
FROM	sale.orders


--DATEADD(datepart, number, date)--enables you to add an interval to part of a specific date.
SELECT DATEADD(DAY, 3 , '2022-09-17')
SELECT DATEADD(DAY, -3 , '2022-09-17')
SELECT DATEADD(YEAR, -3 , '2022-09-17')
SELECT DATEADD (SECOND, 1, '2021-12-31 23:59:59') AS NewDate



--EOMONTH(startdate [, month to add])--returns the last day of the month containing a specified date, with an optional offset.
SELECT EOMONTH('2023-03-10')
SELECT EOMONTH('2021-02-10') AS EndofFeb


--ISDATE(expression)--returns 1 if the expression is a valid datetime value; otherwise, 0.
SELECT ISDATE('2022-09-17')
SELECT ISDATE('20220917')
SELECT ISDATE('17-09-2022')
SELECT ISDATE('15/2008/04') AS isdate_


---sipariþ tarihinden iki gün sonra kargolanan sipariþleri döndüren bir sorgu yazýn
SELECT *, DATEDIFF(DAY , order_date, shipped_date) AS day_diff
FROM		sale.orders


SELECT *, DATEDIFF(DAY , order_date, shipped_date) AS day_diff
FROM		sale.orders
WHERE		DATEDIFF(DAY , order_date, shipped_date) > 2


--LEN(input string)-- function returns the number of characters of a string (excluding spaces end of the text)
SELECT LEN('Clarusway')
SELECT LEN('Clarusway  ')
SELECT LEN('  Clarusway  ')
SELECT LEN(NULL) AS col1, LEN(10) AS col2, LEN(10.5) AS col3



---CHARINDEX(substring, string , [start location]) 
SELECT CHARINDEX('a', 'Clarusway')
SELECT CHARINDEX('a', 'Clarusway', 4)
SELECT CHARINDEX('yourself', 'Reinvent yourself') AS start_position;


--If either pattern or expression is NULL, PATINDEX() returns NULL.
--The starting position for PATINDEX() is 1.
--PATINDEX(%pattern%, input string)---case insensitive
SELECT PATINDEX('sw', 'Clarusway')
SELECT PATINDEX('%sw%', 'Clarusway')
SELECT PATINDEX('%r_sw%', 'Clarusway')
SELECT PATINDEX('___r_sw%', 'Clarusway')
SELECT PATINDEX('%ern%', 'this is not a pattern') AS sample



SELECT LEFT('Clarusway',3)
SELECT RIGHT('Clarusway',3)



--SUBSTRING(string, start_postion, [length])
--If any argument is NULL, the SUBSTRING() function will return NULL.
SELECT SUBSTRING('Clarusway', 1, 3) AS substr
SELECT SUBSTRING('clarusway.com', LEN('clarusway.com')-1, LEN('clarusway.com'));
SELECT SUBSTRING ('Clarusway', 3,2)
SELECT SUBSTRING ('Clarusway', 0,2)
SELECT SUBSTRING ('Clarusway', -1,2)
SELECT SUBSTRING ('Clarusway', -1,3)
SELECT SUBSTRING('Clarusway', -6, 2) AS substr


--LOWER, UPPER,
SELECT LOWER ('CLARUSWAY'), UPPER ('clarusway')


--STRING_SPLIT(string, seperator)--
SELECT value from string_split('John,is,a,very,tall,boy.', ',')

SELECT	value
FROM	STRING_SPLIT('Ezgi/Senem/Mustafa', '/')


---clarusway kelimesinin sadece ilk harfini büyültün.

select replace('clarusway', 'c', 'C')
select upper ('c') + ('larusway')
SELECT SUBSTRING('clarusway', 2, LEN('clarusway'))
SELECT UPPER(LEFT('clarusway',1)) + LOWER (SUBSTRING('clarusway', 2, LEN('clarusway')))
SELECT UPPER (SUBSTRING('clarusway.com', 0 , CHARINDEX('.','clarusway.com')));--CHARINDEX('.','clarusway.com') return 10.

SELECT	*, UPPER(LEFT(email,1)) + LOWER (SUBSTRING(email, 2, LEN(email))) 
FROM	sale.store


--TRIM([characters FROM] string)--removes specified characters from both ends of the string
SELECT TRIM ('   CLARUSWAY   ')
SELECT TRIM('?' FROM '?    CLARUSWAY   ?')  --- sadece soru iþaretini kýrptý
SELECT TRIM('?, ' FROM '?    CLARUSWAY   ?')  --- boþluklarda gitti
SELECT LTRIM('    CLARUSWAY    ')  --- soldaki boþluk gitti
SELECT RTRIM('    CLARUSWAY    ')  --- saðdaki boþluk gitti
SELECT TRIM('?, *, ' FROM '?*    CLARUSWAY    *') ---baþtan ve sondan soru iþaretini,  yýldýzý ve boþluklarý kaldýr
SELECT TRIM('@' FROM '@@@clarusway@@@@') AS new_string;
SELECT TRIM('ca' FROM 'cadillac') AS new_string;
SELECT TRIM(' 789Sun is shining789');


--REPLACE(string expression, string pattern, string replacement)--
--string expression:  The string that you want to perform the replacement.
--string pattern:  The substring to be found in the original string
--string replacement:  The replacement string
SELECT REPLACE('CLARUSWAY', 'C', 'A')
SELECT REPLACE('CLAR USWAY', ' ', '')
SELECT REPLACE('REIMVEMT','M','N');
SELECT REPLACE('I do it my way.','do','did') AS song_name;



--STR(float expression [, length [, decimal]])
--float expression:  Is an expression of approximate numeric (float) data type with a decimal point.
--length:  (Optional) Is the total length. This includes decimal point, sign, digits, and spaces. The default is 10.
--decimal:  (Optional) Is the number of places to the right of the decimal point. decimal must be less than or equal to 16
SELECT STR(1234.25, 7, 2)--- 7 karakter yer ayýr ve virgülden sonra 2 tane yaz
SELECT STR(1234.25, 7, 1)
SELECT STR(123.45, 2, 2) AS num_to_str;
SELECT STR(FLOOR (123.45), 8, 3) AS num_to_str;

--***example***--
--Which of the following query returns the "Reinvent Yourself!" statement from the"' Reinvent $Yourself! "--
SELECT REPLACE (TRIM(' Reinvent $Yourself! '), '$', '')


--CAST ( expression AS data_type [ ( length ) ] )  --These functions convert an expression of one data type to another.
SELECT 'customer' + '_' + CAST(1 AS VARCHAR(1)) AS col
SELECT CAST(123.56 AS VARCHAR(6))--123.56
SELECT CAST(4599.999999 AS numeric(5,1))--4600.0
SELECT CAST(123.56 AS INT);-- decimal bir veriyi, integer'a (tam sayýya) çevirdi.
SELECT CAST(12 AS DECIMAL(5,2) ) AS decimal_value;-- integer bir veriyi 5 karakter yer ayýrýp ve virgülden sonra 2 karakter yazýp decimal'e çevirdi.
SELECT CAST(123.56 AS NUMERIC(4,1))
SELECT CAST(' 5800.79 ' AS DECIMAL (7,2)) AS decimal_value;-- char (string) olan ama rakamdan oluþan veriyi decimal'e çevirdi.




SELECT GETDATE() AS current_time, CONVERT(DATE, GETDATE()) AS current_date
SELECT GETDATE() AS current_time, CONVERT(NVARCHAR, GETDATE(), 11) AS current_date
SELECT GETDATE()
SELECT CONVERT (VARCHAR , GETDATE(), 6)
SELECT CONVERT (NUMERIC(4,1) , 123.56)
SELECT CONVERT (DATE, '19 Sep 22', 6)


--ROUND(numeric_expression , length [ ,function ])
	--YUVARLAMA FONKSÝYONLARI:
--ROUND = sayýyý istenilen haneye göre yuvarlama.
--(Positive number rounds on the right side of the decimal point! Negative number rounds on the left side of the decimal point!)
--FLOOR = sayýyý aþaðýya yuvarlama.
--CEILING = sayýyý yukarýya yuvarlama.SELECT ROUND(12.4512,2)  --sayýyý virgülden sonra 2 haneye yuvarlar.
SELECT FLOOR(12.4512) AS deger -- sayýnýn virgülden sonraki deðerini atarak 12 olarak yuvarlar.
SELECT CEILING(12.4512) AS deger -- sayýnýn virgülden sonraki hanesini yukarý yuvarlar ve 13 elde edilir.

-- Desimal (Ondalýk) veri türü ve çeþitli uzunluk parametreleriyle yuvarlama:
DECLARE @value decimal(10,2) -- deðiþken deklare ettik.
SET @value = 11.05 -- deðiþkene deðer atadýk.SELECT ROUND(@value, 1) -- 11.10
SELECT ROUND(@value, -1) -- 10.00 SELECT ROUND(@value, 2) -- 11.05 
SELECT ROUND(@value, -2) -- 0.00 SELECT ROUND(@value, 3) -- 11.05
SELECT ROUND(@value, -3) -- 0.00SELECT CEILING(@value) -- 12 
SELECT FLOOR(@value) -- 11 


-- Numeric (sayýsal) veri türü ile yuvarlama :
DECLARE @value numeric(10,10)
SET @value = .5432167890SELECT ROUND(@value, 1) -- 0.5000000000 
SELECT ROUND(@value, 2) -- 0.5400000000
SELECT ROUND(@value, 3) -- 0.5430000000
SELECT ROUND(@value, 4) -- 0.5432000000
SELECT ROUND(@value, 5) -- 0.5432200000
SELECT ROUND(@value, 6) -- 0.5432170000
SELECT ROUND(@value, 7) -- 0.5432168000
SELECT ROUND(@value, 8) -- 0.5432167900
SELECT ROUND(@value, 9) -- 0.5432167890
SELECT ROUND(@value, 10) -- 0.5432167890SELECT CEILING(@value) -- 1
SELECT FLOOR(@value) -- 0

--Float veri türü ile yuvarlama fonksiyonlarý.
DECLARE @value float(10)
SET @value = .1234567890SELECT ROUND(@value, 1) -- 0.1
SELECT ROUND(@value, 2) -- 0.12
SELECT ROUND(@value, 3) -- 0.123
SELECT ROUND(@value, 4) -- 0.1235
SELECT ROUND(@value, 5) -- 0.12346
SELECT ROUND(@value, 6) -- 0.123457
SELECT ROUND(@value, 7) -- 0.1234568
SELECT ROUND(@value, 8) -- 0.12345679
SELECT ROUND(@value, 9) -- 0.123456791
SELECT ROUND(@value, 10) -- 0.123456791SELECT CEILING(@value) -- 1
SELECT FLOOR(@value) -- 0


--Pozitif bir tamsayý yuvarlama (1 keskinlik deðeri için):
DECLARE @value int
SET @value = 6SELECT ROUND(@value, 1) -- 6 - No rounding with no digits right of the decimal pointSELECT CEILING(@value) -- 6 - Smallest integer value
SELECT FLOOR(@value) -- 6 - Largest integer value 


--Kesinlik deðeri olarak bir negatif sayýnýn etkilerini de görelim:
DECLARE @value int
SET @value = 6SELECT ROUND(@value, -1) -- 10 - Rounding up with digits on the left of the decimal point
SELECT ROUND(@value, 2) -- 6 - No rounding with no digits right of the decimal point 
SELECT ROUND(@value, -2) -- 0 - Insufficient number of digits
SELECT ROUND(@value, 3) -- 6 - No rounding with no digits right of the decimal point
SELECT ROUND(@value, -3) -- 0 - Insufficient number of digits   Bu örnekteki rakamlarý geniþletelim ve ROUND fonksiyonu kullanarak etkilerini görelim:SELECT ROUND(444, 1) -- 444 - No rounding with no digits right of the decimal point
SELECT ROUND(444, -1) -- 440 - Rounding down
SELECT ROUND(444, 2) -- 444 - No rounding with no digits right of the decimal point
SELECT ROUND(444, -2) -- 400 - Rounding down
SELECT ROUND(444, 3) -- 444 - No rounding with no digits right of the decimal point
SELECT ROUND(444, -3) -- 0 - Insufficient number of digits
SELECT ROUND(444, 4) -- 444 - No rounding with no digits right of the decimal point
SELECT ROUND(444, -4) -- 0 - Insufficient number of digits


--Negatif bir tamsayý yuvarlayalým ve etkilerini görelim:
SELECT ROUND(-444, -1) -- -440 - Rounding down
SELECT ROUND(-444, -2) -- -400 - Rounding downSELECT ROUND(-555, -1) -- -560 - Rounding up
SELECT ROUND(-555, -2) -- -600 - Rounding upSELECT ROUND(-666, -1) -- -670 - Rounding up
SELECT ROUND(-666, -2) -- -700 - Rounding up
SELECT ROUND (123.56,1)
SELECT ROUND (123.54, 1)
SELECT ROUND (123.54, 1, 0)
SELECT ROUND (123.56, 1, 0)
SELECT ROUND (123.56, 1, 1)
SELECT ROUND (123.54, 1, 1)
SELECT ROUND(123.9994, 3) AS col1, ROUND(123.9995, 3) AS col2;
SELECT ROUND(123.4545, 2) col1, ROUND(123.45, -2) AS col2;


--ISNULL(check expression, replacement value)
--If you want to fill the null values with a specific value, you can use ISNULL() function.
SELECT ISNULL(NULL, 0)
SELECT ISNULL(1, 0)
SELECT ISNULL('NOTNULL', 0)

SELECT phone, ISNULL(phone, 0)
FROM sale.customer

SELECT phone 
FROM sale.customer
select ROUND(1034.845299,3)


--COALESCE(expression [, ...n])--COALESCE(expression [, ...n])
--You can use the NULLIF() function to find the product whose price does not change.
--If all arguments are NULL, COALESCE returns NULL.
--At least one of the null values must be a typed NULL.
SELECT COALESCE(NULL, NULL, 'ALÝ', NULL)
SELECT NULLIF(0, 0)
SELECT NULLIF(4,4) AS Same, NULLIF(5,7) AS Different;
SELECT NULLIF('2021-01-01', '2021-01-01') AS col
SELECT NULLIF(1, 3) AS col


SELECT phone, ISNULL(phone, 0), NULLIF (ISNULL(phone, 0), '0')
FROM sale.customer


-------
--Valid numeric data types are: bigint, int, smallint, tinyint, bit, decimal, numeric, float, real, money, smallmoney.
SELECT ISNUMERIC(1)
SELECT ISNUMERIC('1')
SELECT ISNUMERIC('1,5')
SELECT ISNUMERIC('1.5')
SELECT ISNUMERIC('1ALÝ')
SELECT ISNUMERIC ('William') AS col

-----------

-- How many customers have yahoo mail?
SELECT COUNT (*) as cnt_cust
FROM sale.customer
WHERE email LIKE '%yahoo%'

---other method
SELECT COUNT(email)
FROM sale.customer 
WHERE email LIKE '%yahoo.com'

---other method
SELECT	COUNT (PATINDEX('%yahoo%', email))
FROM	sale.customer
WHERE	PATINDEX('%yahoo%', email) > 0

---other method
SELECT	COUNT (*)
FROM	sale.customer
WHERE	PATINDEX('%yahoo%', email) > 0



--Write a query that returns the characters before the '@' character in the email column.
SELECT	email, LEFT (email, CHARINDEX('@', email)-1) AS chars
FROM	sale.customer


---other method
SELECT email
FROM sale.customer 
WHERE email LIKE '%yahoo.com'


---Add a new column to the customers table that contains the customers' contact information.
--If the phone is not null, the phone information will be printed, if not, the email information will be printed.
SELECT phone, email, COALESCE(phone, email, 'no contact') contact 
FROM	sale.customer
ORDER BY 3--- 3.sütuna göre sýrala demek

---other method
SELECT phone, ISNULL(phone, email) as contact
FROM sale.customer


--Write a query that returns streets. The third character of the streets is numerical.
--street sütununda soldan üçüncü karakterin rakam olduðu kayýtlarý getiriniz.



SELECT	street, SUBSTRING(street, 3,1) third_char, ISNUMERIC (SUBSTRING(street, 3,1)) isnumerical
FROM	SALE.customer
WHERE	ISNUMERIC (SUBSTRING(street, 3,1)) = 1


SELECT	street
FROM	SALE.customer
WHERE	ISNUMERIC (SUBSTRING(street, 3,1)) = 1


-- PRACTÝCE
SELECT COALESCE(NULLIF(ISNUMERIC(STR(12255.212, 7)), 1), 9999);
select STR(12255.212, 7)--12255
select ISNUMERIC(12255)--1
select NULLIF(1, 1)--NULL
SELECT COALESCE(NULL, 9999);--9999






