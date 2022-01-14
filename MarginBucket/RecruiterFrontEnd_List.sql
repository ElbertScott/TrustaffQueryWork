USE Trustaff_med



select x.RecruiterName, x.Recruiter, x.FrontEnd, x.FrontEndName, Row
from 
(
	SELECT	u.Name as RecruiterName, c1.KEY4 as Recruiter, ISNULL(C2.U_GENER13,'None') as FrontEnd, c1.id, ul.Name as FrontEndName
			, ROW_NUMBER() OVER(Partition by C2.U_GENER13 order by c1.id desc) as Row
	FROM  dbo.CONTACT1 AS c1
	JOIN dbo.CONTACT2 C2 ON C2.ACCOUNTNO = c1.ACCOUNTNO
	JOIN  dbo.UserList u ON SUBSTRING(c1.KEY4,0,9) = SUBSTRING(u.GM_Username,0,9)
	JOIN  dbo.UserList as UL ON SUBSTRING(c2.U_GENER13,0,9) = SUBSTRING(UL.GM_Username,0,9)
	WHERE C2.U_GENER13 != NULL or U_GENER13 !=''
	and c1.KEY4 <> 'UNASSIGNED'
	--and c2.U_GENER13 = SUBSTRING('SBREWSTE',1,8)  --Pass in Front End User ID Trim to use first 8 characters of userid
	GROUP BY c1.Key4, C2.U_GENER13, c1.id, u.Name, ul.Name
	--order by C2.U_GENER13 desc
) as x
where Row = 1
order by FrontEnd
