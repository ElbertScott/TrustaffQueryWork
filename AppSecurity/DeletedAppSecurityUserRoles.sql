USE AppSecurity


delete from dbo.ADUserGroupList
where id in 
(
	select id
	from 
	(
		select id, SamAccountName, UserName, Email, ADGroup
		from ADUserGroupList
		where ADGroup in ('AppAccessRecruiter','AppAccessMC')
		--order by SamAccountName
	) as x
	where ADGroup = 'AppAccessMC'
)
