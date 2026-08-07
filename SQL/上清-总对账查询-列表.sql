select
	bbqo.HOLDER_ACCT_NUM as holderAcctNum,
	bbqo.HOLDER_ACCT_SNAME as holderAcctSname,
	bbqo.BOND_CODE as bondCode,
	bbqo.BOND_SNAME as bondSname,
	bbqo.ISIN_CODE as isinCode,
	bbqo.BOND_TITLE_CODE as bondTitleCode,
	bbqo.BOND_TITLE_NAME as bondTitleName,
	d1.DICT_VALUE as bondBalDirection,
	FORMAT(bbqo.BOND_TITLE_BAL, 2) as bondTitleBal,
	bbqo.IMPTIME as imptime,
	bbqo.UPDATETIME as updatetime
from
	TTRD_SHCH2_BOND_BAL_QRY_OUT bbqo
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_BOND_BAL_DIRECTION' ) d1 on bbqo.BOND_BAL_DIRECTION = d1.DICT_KEY
<where>
	<if test="holderAcctNum != null and holderAcctNum != ''">
		AND bbqo.HOLDER_ACCT_NUM = #{holderAcctNum}
	</if>
	<if test="isinCode != null and isinCode != ''">
		AND bbqo.ISIN_CODE = #{isinCode}
	</if>
	<if test="bondCode != null and bondCode != ''">
		AND bbqo.BOND_CODE = #{bondCode}
	</if>
	<if test="bondSname != null and bondSname != ''">
		AND bbqo.BOND_SNAME = #{bondSname}
	</if>
	<if test="bondBalDirection != null and bondBalDirection != ''">
		AND bbqo.BOND_BAL_DIRECTION = #{bondBalDirection}
	</if>
	<if test="bondTitleCode != null and bondTitleCode != ''">
		AND bbqo.BOND_TITLE_CODE = #{bondTitleCode}
	</if>
	<if test="bizDateBegin != null and bizDateBegin != ''">
		AND bbqo.BIZ_DATE &gt;= #{bizDateBegin}
	</if>
		<if test="bizDateEnd != null and bizDateEnd != ''">
		AND bbqo.BIZ_DATE &lt;= #{bizDateEnd}
	</if>
</where>