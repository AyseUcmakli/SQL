
-------INDEX--------
--Indexes are special data structures associated with tables or views that help speed up the query. 
--Indexes are used to quickly locate data without having to search every row in a database table every time a database table is accessed. 
--SQL Server has two types of indexes: 
           --clustered index 
		   --non-clustered index.



--Bu tablo için ayrý bir database oluþturmanýz daha uygun olacaktýr.
--Index' in faydalarýnýn daha belirgin olarak görülmesi için bu þekilde bir tablo oluþturulmuþtur.

--önce tablonun çatýsýný oluþturuyoruz.


create table website_visitor 
(
visitor_id int,
first_name varchar(50),
last_name varchar(50),
phone_number bigint,
city varchar(50)
);
--ÝF YOU WANT TO DROP THÝS TABLE, YOU CAN USE DROP


--Tabloya rastgele veri atýyoruz konumuz haricindedir, þimdilik varlýðýný bilmeniz yeterli.


DECLARE @i int = 1
DECLARE @RAND AS INT
WHILE @i<200000
BEGIN
	SET @RAND = RAND()*81
	INSERT website_visitor
		SELECT @i , 'visitor_name' + cast (@i as varchar(20)), 'visitor_surname' + cast (@i as varchar(20)),
		5326559632 + @i, 'city' + cast(@RAND as varchar(2))
	SET @i +=1
END;



--Tabloyu kontrol ediniz.

SELECT top 10*
FROM website_visitor



--Ýstatistikleri (Process ve time) açýyoruz, bunu açmak zorunda deðilsiniz sadece yapýlan iþlemlerin detayýný görmek için açtýk.
SET STATISTICS IO on
SET STATISTICS TIME on--YAPILAN ÝÞLEMLERLE ÝLGÝLÝ SÜRE BÝLGÝSÝNÝ AÇTIK



--herhangi bir index olmadan visitor_id' ye þart verip tüm tabloyu çaðýrýyoruz


SELECT *
FROM website_visitor
where visitor_id = 100

--execution plan' a baktýðýnýzda Table Scan yani tüm tabloyu teker teker tüm deðerlere bakarak aradýðýný göreceksiniz.


---SYNTAX  FOR clustered index :
--CREATE CLUSTERED INDEX index_name ON schema_name.table_name (column_list);

--Visitor_id üzerinde bir index oluþturuyoruz

Create CLUSTERED INDEX CLS_INX_1 ON website_visitor (visitor_id);


--visitor_id' ye þart verip sadece visitor_id' yi çaðýrýyoruz



SELECT visitor_id
FROM website_visitor
where visitor_id = 100


--execution plan' a baktýðýnýzda Clustered index seek
--yani sadece clustered index' te aranýlan deðeri B-Tree yöntemiyle bulup getirdiðini görüyoruz.



--visitor_id' ye þart verip tüm tabloyu çaðýrýyoruz

SELECT *
FROM
website_visitor
where
visitor_id = 100

--execution plan' a baktýðýnýzda Clustered index seek yaptýðýný görüyoruz.
--Clustered index tablodaki tüm bilgileri leaf node'larda sakladýðý için ayrýca bir yere gitmek ihtiyacý olmadan
--primary key bilgisiyle (clustered index) tüm bilgileri getiriyor.
------------------------------


--Peki farklý bir sütuna þart verirsek;


SELECT first_name
FROM
website_visitor
where
first_name = 'visitor_name17'


--Execution Plan' da Görüleceði üzere Clustered Index Scan yapýyor.
--Dikkat edin Seek deðil Scan. Aradýðýmýz sütuna ait deðeri clustered index' in leaf page' lerinde tutulan bilgilerde arýyor
--Tabloda arar gibi, index yokmuþçasýna.


---Non-Clustered Indexes
---SYNTAX  FOR NON-clustered index :
--CREATE [NONCLUSTERED] INDEX index_name ON table_name(column_list);

--Yukarýdaki gibi devamlý sorgu atýlan non-key bir attribute söz konusu ise;
--Bu þekildeki sütunlara clustered index tanýmlayamayacaðýmýz için NONCLUSTERED INDEX tanýmlamamýz gerekiyor.

--Non clustered index tanýmlayalým ad sütununa
CREATE NONCLUSTERED INDEX ix_NoN_CLS_1 ON website_visitor (first_name);


--Ad sütununa þart verip kendisini çaðýralým:

SELECT first_name
FROM
website_visitor
where
first_name = 'visitor_name17'


--Execution Plan' da Görüleceði üzere üzere ayný yukarýda visitor id'de olduðu gibi index seek yöntemiyle verileri getirdi.
--Tek fark NonClustered indexi kullandý.


--Peki ad sütunundan baþka bir sütun daha çaðýrýrsak ne olur?
--Günlük hayatta da ad ile genellikle soyadý birlikte sorgulanýr.


SELECT first_name, last_name
FROM
website_visitor
where
first_name = 'visitor_name17'


--Execution Plan' da Görüleceði üzere burada ad ismine verdiðimiz þart için NonClustered index seek kullandý,
--Sonrasýnda soyad bilgisini de getirebilmek için Clustered index e Key lookup yaptý.
--Yani clustered index' e gidip sorgulanan ad' a ait primary key' e baþvurdu
--Sonrasýnda farklý yerlerden getirilen bu iki bilgiyi Nested Loops ile birleþtirdi.


--Bir sorgunun en performanslý hali idealde Sorgu costunun %100 Index Seek yöntemi ile getiriliyor olmasýdýr!


--Þu demek oluyor ki, bu da tam olarak performans isteðimizi karþýlamadý, daha performanslý bir index oluþturabilirim.

--Burada yapabileceðim, ad sütunu ile devamlý olarak birlikte sorgulama yaptýðým sütunlara INCLUDE INDEX oluþturma iþlemidir.
--Bunun çalýþma mantýðý;
--NonClustered index' te leaf page lerde sadece nonclustered index oluþturulan sütunun ve primary keyinin bilgisi tutulmaktaydý.
--Include index oluþturulduðunda verilen sütun bilgileri bu leaf page lere eklenmesi ve ad ile birlikte kolayca getirilmesi amaçlanmýþtýr.



--CREATE UNIQUE INDEX index_name ON table_name(column_list);
--Include indexi oluþturalým:
Create unique NONCLUSTERED INDEX ix_NoN_CLS_2 ON website_visitor (first_name) include (last_name)


--ad ve soyadý ad sütununa þart vererek birlikte çaðýralým
SELECT first_name, last_name
FROM
website_visitor
where
first_name = 'visitor_name17'

--Execution Plan' da Görüleceði üzere sadece Index Seek ile sonucu getirmiþ oldu.


--soyad sütununa þart verip sadece kendisini çaðýrdýðýmýzda 
--Kendisine tanýmlý özel bir index olmadýðý için Index seek yapamadý, ad sütunun indexinde tüm deðerlere teker teker bakarak
--Yani Scan yöntemiyle sonucu getirdi.

SELECT last_name
FROM
website_visitor
where
last_name = 'visitor_surname10'

--Execution Plan' da Görüleceði üzere bize bir index tavsiyesi veriyor.

CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[website_visitor] ([last_name])

SELECT last_name
FROM
website_visitor
where
last_name = 'visitor_surname10'
--bu kýsmý tekrar çalýþtýrýnca seek ile oldugunu görüyoruz


--ALTER INDEX index_name ON table_name DISABLE;  ---disable unused indexes for a while before deleting them
                                                 ---kullanýlmayan dizinleri silmeden önce bir süreliðine devre dýþý býrakýn

--ALTER INDEX ALL ON table_name DISABLE;   ---disable all indexes of a table
                                           ---bir tablonun tüm dizinlerini devre dýþý býrak


--The DROP INDEX statement removes one or more indexes from the current database. 
--Here is the syntax of the DROP INDEX statement:
--DROP INDEX [IF EXISTS] index_name ON table_name;

-- Note: 
--DROP INDEX statement does not remove indexes created by PRIMARY KEY or UNIQUE constraints. 
--To drop indexes associated with these constraints, you use the ALTER TABLE DROP CONSTRAINT statement.
--ALTER TABLE table_name DROP CONSTRAINTS index_name 