


--Session 12 SQL Programming


--Stored Procedures

--To create a procedure
CREATE PROCEDURE sp_sampleproc1 AS
BEGIN
	SELECT 5*5
END



--Call the stored procedure
EXECUTE sp_sampleproc1;

EXEC sp_sampleproc1

sp_sampleproc1


--create a procedure
CREATE OR ALTER PROCEDURE sp_sampleproc2 AS
BEGIN
	SELECT 'CLARUSWAY'
END


--Call the stored procedure
EXEC sp_sampleproc2


--create a procedure
CREATE OR ALTER PROCEDURE sp_sampleproc2 AS
BEGIN
	PRINT 'CLARUSWAY'
END

--Call the stored procedure
EXEC sp_sampleproc2



--create a table
CREATE TABLE ORDER_TBL 
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date--Tahmini Teslim Tarihi
);


--insert values
INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 7, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 8, 'Johnson',GETDATE(), GETDATE()+5 )


--control it
SELECT *
FROM ORDER_TBL




CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);


SET NOCOUNT ON 
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )



SELECT *
FROM	ORDER_DELIVERY


--create a procedure
CREATE OR ALTER PROC sp_sampleproc3 AS
BEGIN
	SELECT COUNT (ORDER_ID) AS CNT_ORDER 
	FROM ORDER_TBL
END

--Call the stored procedure
EXEC sp_sampleproc3

--insert new values
INSERT ORDER_TBL VALUES (9,9, 'Adam', NULL, NULL)


--control it
SELECT *
FROM ORDER_TBL

--Call the stored procedure
EXEC sp_sampleproc3


--When you want to remove the stored procedure, you can use:
DROP PROCEDURE sample_name

---PROCEDURE PARAMS
--A procedure can have a maximum of 2100 parameters; each assigned a name,
--data type, and direction. Optionally, parameters can be assigned default values.

--The parameter values supplied with a procedure call must be constants or a variable.
--Bir prosedür çaðrýsý ile saðlanan parametre deðerleri sabit veya deðiþken olmalýdýr.


                      ---------------------------------
--------create a procedure:
-- Create a procedure that takes one input parameter and returns one output parameter and a return code.

CREATE PROCEDURE sp_SecondProc @name varchar(20), @salary INT OUTPUT
AS
BEGIN

-- Set a value in the output parameter by using input parameter.
SELECT @salary = salary
FROM departments
WHERE name = @name

-- Returns salary of @name
RETURN @salary
END
GO



--------call/execute the procedure:
-- Declare the variables for the output salary.
DECLARE @salary_output INT

-- Execute the stored procedure and specify which variable are to receive the output parameter.
--stored procedure i yürütün ve çýktý parametresini hangi deðiþkenin alacaðýný belirtin.
EXEC sp_SecondProc @name = 'Eric', @salary = @salary_output OUTPUT

-- Show the values returned.
PRINT CAST(@salary_output AS VARCHAR(10)) + '$'
GO
--run all of these together



--Let's modify the procedure "sp_SecondProc":
ALTER PROCEDURE sp_SecondProc @name varchar(20) = 'Jack', @salary INT OUTPUT
AS
BEGIN

-- Set a value in the output parameter by using input parameter.
SELECT @salary = salary
FROM departments
WHERE name = @name

-- Returns salary of @name
RETURN @salary
END
GO


                      -------------------------------------------------------------------------------------



CREATE OR ALTER PROC sp_sampleproc4 (@DAY DATE = '01-01-2022')
AS
BEGIN
	SELECT COUNT (ORDER_ID) AS CNT_ORDER
	FROM	ORDER_TBL
	WHERE	ORDER_DATE = @DAY
END


EXEC sp_sampleproc4 '2022-09-29'

-----


CREATE OR ALTER PROC sp_sampleproc5 (@CUSTOMER VARCHAR(50), @DAY DATE = '01-01-2022')
AS
BEGIN
	SELECT COUNT (ORDER_ID) AS CNT_ORDER
	FROM	ORDER_TBL
	WHERE	ORDER_DATE = @DAY
	AND		CUSTOMER_NAME = @CUSTOMER
END


EXEC sp_sampleproc5 'Adam', '2022-10-02'


EXEC sp_sampleproc5 @CUSTOMER = 'Adam', @DAY = '2022-10-02'


---------

--QUERY PARAMS
DECLARE @V1 INT
DECLARE @V2 INT
DECLARE @RESULT INT


SET @V1 = 5
SET @V2 = 6
SET @RESULT = @V1*@V2


--SELECT @RESULT AS RESULT

PRINT @RESULT

---


DECLARE @V1 INT = 5, @V2 INT = 6, @RESULT INT

SET @RESULT = @V1*@V2
SELECT @RESULT


---

DECLARE @V1 INT
DECLARE @V2 INT
DECLARE @RESULT INT

--SET @V1 = 5, @V2 = 6

SELECT @V1 = 5, @V2 = 6, @RESULT = @V1*@V2

SELECT @RESULT


------


DECLARE @DAY DATE

SET @DAY = '2022-09-28'

SELECT *
FROM	ORDER_TBL
WHERE	ORDER_DATE = @DAY

-----------

SELECT *
FROM	ORDER_TBL




--Declare a variable
DECLARE @Var1 VARCHAR(5)
DECLARE @Var2 VARCHAR(20)

--Set a value to the variable with "SET"
SET @Var1 = 'MSc'

--Set a value to the variable with "SELECT"

SELECT @Var2 = 'Computer Science'

--Get a result by using variable value
SELECT *
FROM departments
WHERE graduation = @Var1
AND dept_name = @Var2



--IF, ELSE IF, ELSE
--Here is the syntax of IF...ELSE
--IF Boolean_expression   
     --{ sql_statement | statement_block }   
--[ ELSE   
     --{ sql_statement | statement_block } ] 

--
IF DATENAME(weekday, GETDATE()) IN (N'Saturday', N'Sunday')
       SELECT 'Weekend' AS day_of_week;
ELSE 
       SELECT 'Weekday' AS day_of_week;

----
DECLARE @CUSTOMER_ID INT = 3

IF		@CUSTOMER_ID = 1
		PRINT 'CUSTOMER NAME IS ADAM'
ELSE IF	@CUSTOMER_ID = 2
		PRINT 'CUSTOMER NAME IS SMITH'
ELSE IF @CUSTOMER_ID = 3
		PRINT 'CUSTOMER NAME IS JOHN'



-----
IF EXISTS (SELECT 1)
	SELECT * FROM ORDER_TBL


IF NOT EXISTS (SELECT 1)
	SELECT * FROM ORDER_TBL


---

DECLARE @CUSTOMER_ID INT 

SET @CUSTOMER_ID = 5


IF EXISTS (SELECT * FROM ORDER_TBL WHERE CUSTOMER_ID = @CUSTOMER_ID)
	SELECT	COUNT (ORDER_ID)
	FROM	ORDER_TBL
	WHERE	CUSTOMER_ID = @CUSTOMER_ID


----------------------


DECLARE @CUSTOMER_ID INT 

SET @CUSTOMER_ID = 5


IF NOT EXISTS (SELECT * FROM ORDER_TBL WHERE CUSTOMER_ID = @CUSTOMER_ID)
	SELECT	COUNT (ORDER_ID)
	FROM	ORDER_TBL
	WHERE	CUSTOMER_ID = @CUSTOMER_ID


--iki deðiþken tanýmlayýn
--1. deðiþken ikincisinden büyük ise iki deðiþkeni toplayýn
--2. deðiþken birincisinden büyük ise 2. deðiþkenden 1. deðiþkeni çýkarýn
--1. deðiþken 2. deðiþkene eþit ise iki deðiþkeni çarpýn


DECLARE @V1 INT , @V2 INT

SELECT @V1 = 6, @V2 = 6

IF @V1 > @V2

	SELECT @V1+@V2 AS TOPLAM

ELSE IF @V2 > @V1 

	SELECT @V2-@V1 AS FARK

ELSE SELECT @V1*@V2 AS CARPIM

----------------

--istenilen tarihte verilen sipariþ sayýsý 5 ' ten küçükse 'lower than 5'
--5 ile 10 arasýndaysa sipariþ sayýsý (kaç ise sayý)
--10' dan büyük ise 'upper than 10' yazdýran bir sorgu yazýnýz.


DECLARE @DAY DATE
DECLARE @CNTORDER INT 

SET @DAY = '2022-10-03'

SELECT	@CNTORDER = COUNT (ORDER_ID)
FROM	ORDER_TBL
WHERE	ORDER_DATE = @DAY

IF @CNTORDER < 2
	PRINT 'lower than 5'

ELSE IF @CNTORDER BETWEEN 2 AND 3
	SELECT @CNTORDER cnt_order

ELSE	PRINT 'upper than 10'


----WHILE
--The statements are executed repeatedly as long as the specified condition is true
--The execution of statements in the WHILE loop can be controlled from inside the loop with the BREAK and CONTINUE keywords.
--Syntax:
--WHILE Boolean_expression   
--     { sql_statement | statement_block | BREAK | CONTINUE }  

------------------------------------------------------------
-- Declaring a @count variable to delimited the while loop.
DECLARE @count as int

--Setting a starting value to the @count variable
SET @count=1

--Generating the while loop

WHILE  @count < 30 -- while loop condition
BEGIN  	 	
	SELECT @count, @count + (@count * 0.20) -- Result that is returned end of the statement.
	SET @count +=1 -- the variable value raised one by one to continue the loop.
	IF @count % 3 = 0 -- this is the condition to break the loop.
		BREAK -- If the condition is met, the loop will stop.
	ELSE
		CONTINUE -- If the condition isn't met, the loop will continue.
END;
--------------------------------------------------------



DECLARE @COUNTER INT = 1

WHILE @COUNTER < 21
BEGIN
		PRINT @COUNTER
		
		SET @COUNTER = @COUNTER+1
END


----------------------

SELECT *
FROM	ORDER_TBL

-----------------
--
DECLARE @ID INT = 10

WHILE @ID <21
BEGIN
	
	INSERT ORDER_TBL VALUES (@ID, @ID, NULL, NULL, NULL)
	SET @ID += 1
END
--------------------------------
SELECT * FROM ORDER_TBL


--FUNCTIONS
--Why use user-defined functions (UDFs)?:

----They allow modular programming.
----You can create the function once, store it in the database, and call it any number of times in your program. 
--User-defined functions can be modified independently of the program source code.
----They allow faster execution.
----Similar to stored procedures, user-defined functions reduce the compilation cost of the code by 
--caching the plans and reusing them for repeated executions.
----They can reduce network traffic.
----An operation that filters data based on some complex constraint that cannot be expressed in a
--single scalar expression can be expressed as a function. The function can then be invoked 
--in the WHERE clause to reduce the number of rows sent to the client.


--SCALAR VALUED FUNCTIONS
--Tek bir deðer döndürür

--CREATE FUNCTION FUNCTION_NAME(@PAREMETER TYPE)      
--RETURNS TYPE                                        
--AS												   	
--BEGIN 												
--    SQL_STATEMENT										
--RETURN VALUE 										
--END;	
--DECLARE @COUNTER INT  = 1

--create a func
CREATE FUNCTION fn_upper_first_char() 
RETURNS NVARCHAR(MAX)
AS
BEGIN
	RETURN UPPER (LEFT ('character', 1)) + LOWER (RIGHT ('character', len ('character')-1))

END

--call the func.
SELECT dbo.fn_upper_first_char()



--create a func
CREATE OR ALTER FUNCTION fn_upper_first_char(@CHAR NVARCHAR (MAX)) 
RETURNS NVARCHAR(MAX)
AS
BEGIN
	RETURN UPPER (LEFT (@CHAR, 1)) + LOWER (RIGHT (@CHAR, len (@CHAR)-1))

END


--call the func
SELECT dbo.fn_upper_first_char('UFUK')


SELECT *, dbo.fn_upper_first_char(CUSTOMER_NAME) AS NEW_NAME
FROM	ORDER_TBL


----


---TABLE VALUED FUNCTIONS
--bir tablo döndürür.

--create a func
CREATE FUNCTION fn_order_tbl()
RETURNS TABLE
AS
	RETURN	SELECT * 
			FROM ORDER_TBL 
			WHERE CUSTOMER_NAME = 'Adam'


--call the func
SELECT *
FROM	dbo.fn_order_tbl()

--create a func
CREATE FUNCTION fn_order_tbl_2 (@CUSTOMER_NAME NVARCHAR(MAX))
RETURNS TABLE
AS
	RETURN	SELECT * 
			FROM ORDER_TBL 
			WHERE CUSTOMER_NAME = @CUSTOMER_NAME


--call the func
SELECT	ORDER_DATE
FROM	dbo.fn_order_tbl_2('Adam')


----------------------
--create a func
CREATE FUNCTION fn_order_tbl_3 ()
RETURNS @tbl TABLE (ORDER_ID INT , ORDER_DATE DATE)
AS
BEGIN
		INSERT 	@tbl VALUES (1, '2022-10-03')

		RETURN
END

--call the func
SELECT * 
FROM	dbo.fn_order_tbl_3 ()




-------------



DECLARE @TBL TABLE (ORDER_ID INT, ORDER_DATE DATE)

SELECT *
FROM @TBL
  


  -----index

