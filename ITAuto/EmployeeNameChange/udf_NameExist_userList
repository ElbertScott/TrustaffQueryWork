

CREATE OR ALTER FUNCTION dbo.udf_NameExist_userList (@v_userName varchar(100), @v_name varchar(200))
RETURNS varchar(60)
AS 
BEGIN

	--SELECT dbo.udf_NameExists_userList ('ABLACK', 'Alli Black')
	DECLARE @userName varchar(100) =  @v_userName --'ABLACK'
	DECLARE @name varchar(200) = @v_name --'Alli Black'
	DECLARE @UsernameExists varchar(40) = 'User Name Exists. Use Middle Initial.'
	DECLARE @nameExists varchar(40) = 'Name Exists. Use Middle Initial.'
	DECLARE @bothExists varchar(50) = 'UserName and Name Exists. Use Middle Initial.'
	DECLARE @finalMessage varchar(50)
	DECLARE @usercount bit = 0
	DECLARE @namecount bit = 0


	IF EXISTS (select * from Trustaff_Med.dbo.UserList where GM_Username = @userName)
		BEGIN
			SET @usercount = 1
		END

	IF EXISTS (select * from Trustaff_Med.dbo.UserList where Name = @Name)
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