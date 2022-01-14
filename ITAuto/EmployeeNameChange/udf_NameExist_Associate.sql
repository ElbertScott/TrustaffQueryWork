--USE HR


CREATE FUNCTION dbo.udf_NameExist_Associate (@v_userName varchar(100), @v_firstname varchar(200), @v_lastname varchar(200))
RETURNS varchar(60)
AS 
BEGIN

	--SELECT dbo.udf_NameExists_Associate ('CARMOGIDA', 'Christopher','Armogida')
	DECLARE @userName varchar(100) =  @v_userName --'CARMOGIDA'
	DECLARE @firstname varchar(200) = @v_firstname --'Christopher'
	DECLARE @lastname varchar(200) = @v_lastname --'Armogida'
	DECLARE @UsernameExists varchar(40) = 'User Name Exists. Use Middle Initial.'
	DECLARE @nameExists varchar(40) = 'Name Exists. Use Middle Initial.'
	DECLARE @bothExists varchar(50) = 'UserName and Name Exists. Use Middle Initial.'
	DECLARE @finalMessage varchar(50)
	DECLARE @usercount bit = 0
	DECLARE @namecount bit = 0


	IF EXISTS (select * from HR.dbo.Associate where Username = @userName)
		BEGIN
			SET @usercount = 1
		END

	IF EXISTS (select * from HR.dbo.Associate where (FirstName = @firstname and LastName = @lastname))
		BEGIN
			SET @namecount = 1
		END

	IF @usercount = 1 and @namecount = 1 
		SET @finalMessage = @bothExists
	ELSE
		IF @usercount = 1
			SET @finalMessage = @UsernameExists
	ELSE 
		IF @namecount = 1
			SET @finalMessage = @nameExists

	RETURN @finalMessage

END