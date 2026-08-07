select
	tcrr.SID as sid,
	dict2.DICT_KEY as holderAcctNum,
	dict2.DICT_VALUE as holderSname,
	tcrr.PAYMENT_DATE as theoryCouponDate,
	tcrr.EARLIEST_PAYMENT_DATE as updateTm,
	dict1.DICT_VALUE as principalAndCouponType,
	tcrr.BOND_CODE as bondCode,
	tcrr.BOND_NAME as bondSnameCn,
	FORMAT(tcrs.USUAL_BALANCE / 10000, 6) as accrualFaceAmt,
	FORMAT(tcrs.TEMP_QUANTITY / 10000, 6) as tempQuantity,
	FORMAT(tcrs.TEMP_AMOUNT / 10000, 2) as tempAmount,
	'' as detainPrncpl,
	'' as detainIntrst,
	FORMAT(a.principalAmount, 2) as toPayPrncpl,
	FORMAT(a.intAmount, 2) as toPayIntrst,
	FORMAT(a.totalPrinInt, 2) as toPayTotal
from
	TTRD_CBGS2_RESALE_REPORT tcrr
left join ccdc.TTRD_CBGS2_RESALE_RESULT as tcrs on tcrr.EVENT_ID = tcrs.EVENT_ID
left join (
	select
		tcrs.BOND_CODE,
		sum(
			case
				when tcrs.EVENT_TYPE in ('BPUT', 'REDM', 'MCAL', 'PRED') THEN tcrp.NET_AMOUNT
				else 0
			end
		) as principalAmount,
		sum(
			case
				when tcrs.EVENT_TYPE in ('INTR', 'CAPD') THEN tcrp.NET_AMOUNT
				else 0
			end
		) as intAmount,
		sum(tcrp.NET_AMOUNT) as totalPrinInt
	from
		ccdc.TTRD_CBGS2_RESALE_RESULT as tcrs
		left join ccdc.TTRD_CBGS2_RESALE_PAYMENT as tcrp on tcrs.SID = tcrp.SID
	group by tcrs.BOND_CODE ) as a on tcrr.BOND_CODE = a.BOND_CODE
left join ( select DICT_KEY, DICT_VALUE from nws.dict where DICT_TYPE = 'paymentSettleTransactionType' ) as dict1 on tcrr.EVENT_TYPE = dict1.DICT_KEY
cross join ( select DICT_KEY, DICT_VALUE from nws.dict where DICT_TYPE = 'hostedAccount' limit 1 ) as dict2
<where>
	<if test="bondCode != null and bondCode != ''">
		AND tcrr.BOND_CODE = #{bondCode}
	</if>
	<if test="bondSnameCn != null and bondSnameCn != ''">
		AND tcrr.BOND_NAME = #{bondSnameCn}
	</if>
	<if test="holderAcctNum != null and holderAcctNum != ''">
		AND dict2.DICT_KEY = #{holderAcctNum}
	</if>
	<if test="principalAndCouponType != null and principalAndCouponType != ''">
		AND tcrr.EVENT_TYPE = #{principalAndCouponType}
	</if>
	<if test="theoryCouponDateBegin != null and theoryCouponDateBegin != ''">
		AND tcrr.PAYMENT_DATE &gt;= #{theoryCouponDateBegin}
	</if>
	<if test="theoryCouponDateEnd != null and theoryCouponDateEnd != ''">
		AND tcrr.PAYMENT_DATE &lt;= #{theoryCouponDateEnd}
	</if>
	<if test="updateTmBegin != null and updateTmBegin != ''">
		AND tcrr.EARLIEST_PAYMENT_DATE &gt;= #{updateTmBegin}
	</if>
	<if test="updateTmEnd != null and updateTmEnd != ''">
		AND tcrr.EARLIEST_PAYMENT_DATE &lt;= #{updateTmEnd}
	</if>
</where>
union all
select
	pdo.SID as sid,
	pdo.HOLDER_ACCT_NUM as holderAcctNum,
	pdo.HOLDER_SNAME as holderSname,
	pdo.THEORY_COUPON_DATE as theoryCouponDate,
	pdo.UPDATE_TM as updateTm,
	d1.DICT_VALUE as principalAndCouponType,
	pdo.BOND_CODE as bondCode,
	pdo.BOND_SNAME_CN as bondSnameCn,
	FORMAT(pdo.ACCRUAL_FACE_AMT / 10000, 6) as accrualFaceAmt,
	'' as tempQuantity,
	'' as tempAmount,
	FORMAT(pdo.DETAIN_PRNCPL, 2) as detainPrncpl,
	FORMAT(pdo.DETAIN_INTRST, 2) as detainIntrst,
	FORMAT(pdo.TO_PAY_PRNCPL, 2) as toPayPrncpl,
	FORMAT(pdo.TO_PAY_INTRST, 2) as toPayIntrst,
	FORMAT(pdo.TO_PAY_PRNCPL + pdo.DETAIN_INTRST, 2) as toPayTotal
from
	TTRD_SHCH2_PRINCIPAL_DTL_OUT as pdo
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_PRINCIPAL_AND_COUPON_TYPE' ) d1 on pdo.PRINCIPAL_AND_COUPON_TYPE = d1.DICT_KEY
<where>
	<if test="bondCode != null and bondCode != ''">
		AND pdo.BOND_CODE = #{bondCode}
	</if>
	<if test="bondSnameCn != null and bondSnameCn != ''">
		AND pdo.BOND_SNAME_CN = #{bondSnameCn}
	</if>
	<if test="holderAcctNum != null and holderAcctNum != ''">
		AND pdo.HOLDER_ACCT_NUM = #{holderAcctNum}
	</if>
	<if test="principalAndCouponType != null and principalAndCouponType != ''">
		AND pdo.PRINCIPAL_AND_COUPON_TYPE = #{principalAndCouponType}
	</if>
	<if test="theoryCouponDateBegin != null and theoryCouponDateBegin != ''">
		AND pdo.THEORY_COUPON_DATE &gt;= #{theoryCouponDateBegin}
	</if>
	<if test="theoryCouponDateEnd != null and theoryCouponDateEnd != ''">
		AND pdo.THEORY_COUPON_DATE &lt;= #{theoryCouponDateEnd}
	</if>
	<if test="updateTmBegin != null and updateTmBegin != ''">
		AND pdo.UPDATE_TM &gt;= CONCAT(#{updateTmBegin}, ' 00:00:00')
	</if>
	<if test="updateTmEnd != null and updateTmEnd != ''">
		AND pdo.UPDATE_TM &lt; DATE_ADD(#{updateTmEnd}, INTERVAL 1 DAY)
	</if>
</where>