select
	pdo.PRINCIPAL_AND_COUPON_NUM as principalAndCouponNum,
	pdo.HOLDER_ACCT_NUM as holderAcctNum,
	pdo.HOLDER_SNAME as holderSname,
	pdo.BOND_CODE as bondCode,
	pdo.BOND_SNAME_CN as bondSnameCn,
	d1.DICT_VALUE as principalAndCouponType,
	pdo.ACCRUAL_BEGIN_DAY as accrualBeginDay,
	pdo.ACCRUAL_END_DAY as accrualEndDay,
	pdo.COUPON_RECORD_DATE as couponRecordDate,
	pdo.THEORY_COUPON_DATE as theoryCouponDate,
	pdo.UPDATE_TM as updateTm,
	pdo.ACCRUAL_FACE_AMT as accrualFaceAmt,
	pdo.TO_PAY_PRNCPL as toPayPrncpl,
	pdo.DETAIN_PRNCPL as detainPrncpl,
	pdo.TO_PAY_INTRST as toPayIntrst,
	pdo.DETAIN_INTRST as detainIntrst,
	pdo.TO_PAY_PRNCPL + TO_PAY_INTRST as toPayTotal,
	pdo.WITHHOLD_REMIT_TAX_EXPENSE as withholdRemitTaxExpense
from
	TTRD_SHCH2_PRINCIPAL_DTL_OUT pdo
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_PRINCIPAL_AND_COUPON_TYPE' ) d1 on pdo.PRINCIPAL_AND_COUPON_TYPE = d1.DICT_KEY
<where>
	<if test="couponRecordDateBegin != null and couponRecordDateBegin != ''">
		AND pdo.COUPON_RECORD_DATE &gt;= #{couponRecordDateBegin}
	</if>
    <if test="couponRecordDateEnd != null and couponRecordDateEnd != ''">
		AND pdo.COUPON_RECORD_DATE &lt;= #{couponRecordDateEnd}
	</if>
	<if test="bondCode != null and bondCode != ''">
		AND pdo.BOND_CODE = #{bondCode}
	</if>
	<if test="bondSnameCn != null and bondSnameCn != ''">
		AND pdo.BOND_SNAME_CN = #{bondSnameCn}
	</if>
	<if test="principalAndCouponNum != null and principalAndCouponNum != ''">
		AND pdo.PRINCIPAL_AND_COUPON_NUM = #{principalAndCouponNum}
	</if>
	<if test="holderAcctNum != null and holderAcctNum != ''">
		AND pdo.HOLDER_ACCT_NUM = #{holderAcctNum}
	</if>
	<if test="principalAndCouponType != null and principalAndCouponType != ''">
		AND pdo.PRINCIPAL_AND_COUPON_TYPE = #{principalAndCouponType}
	</if>
</where>