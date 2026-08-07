select
	tswl.CASH_ACCT_NUM as cashAcctNum,
	tswl.CASH_ACCT_NAME as cashAcctName,
	tswl.EXT_ACCT_NUM as extAcctNum,
	tswl.EXT_ACCT_NAME as extAcctName,
	FORMAT(tswl.WITHDRAW_AMT, 2) as withdrawAmt,
	tswl.ACTIVE_WITHDRAW_PATH_NUM as withdrawPath,
	tswl.PS as postscript,
	DATE(tswl.WITHDRAW_TIME) as withdrawDate
from
	TTRD_SHCH2_WITHDRAW_LOG tswl
order by
	tswl.WITHDRAW_TIME desc