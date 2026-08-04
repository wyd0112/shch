select
	isqo.SID as sid,
	isqo.EXT_ACCT_NUM as extAcctNum,
	isqo.EXT_ACCT_NAME as extAcctName,
	isqo.INTRST_SETTLEMENT_DT as intrstSettlementDt,
	isqo.ACCRUAL_BEGIN_DT as accrualBeginDt,
	isqo.ACCRUAL_END_DT as accrualEndDt,
	isqo.CUR_TERM_ACCRUAL_DAYS as curTermAccrualDays,
	isqo.DPST_INTRST_AMT as dpstIntrstAmt,
	case
		when exists (
			select 1
			from
				TTRD_SHCH2_WITHDRAW_LOG tswl
			where
				tswl.QRY_OUT_SID = isqo.SID
				and tswl.WITHDRAW_RESULT = '1'
		) then '已提款'
		else '未提款'
	end as withdrawStatus
from
	TTRD_SHCH2_INTRST_SET_QRY_OUT isqo
<where>
	<if test="extAcctNum != null and extAcctNum != ''">
		AND isqo.EXT_ACCT_NUM = #{extAcctNum}
	</if>
	<if test="intrstSettlementDtBegin != null and intrstSettlementDtBegin != ''">
		AND isqo.INTRST_SETTLEMENT_DT &gt;= #{intrstSettlementDtBegin}
	</if>
	<if test="intrstSettlementDtEnd != null and intrstSettlementDtEnd != ''">
		AND isqo.INTRST_SETTLEMENT_DT &lt;= #{intrstSettlementDtEnd}
	</if>
</where>