


------Factorial Function

--Create a scalar-valued function that returns the factorial of a number you gave it.




---WITH WHILE-----
CREATE OR ALTER FUNCTION Factorial(@num int)
RETURNS INT
AS 
BEGIN
DECLARE @i int = 1

 WHILE @num>1
  BEGIN
    SET @i = @num *  @i
    SET @num=@num-1
  END

RETURN @i
END

SELECT dbo.Factorial(5)


---WITH IF-----
CREATE OR ALTER FUNCTION Factor(@num int)
RETURNS INT
AS
BEGIN
DECLARE @i  int

    IF @num <= 1
        SET @i = 1
    ELSE
        SET @i = @num * dbo.Factor( @num - 1 )
RETURN (@i)
END

SELECT dbo.Factor(6)