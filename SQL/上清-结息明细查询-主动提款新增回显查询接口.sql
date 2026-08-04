select
	'0000018' as cashAcctNum,
	'开发银行' as cashAcctName,
	isqo.EXT_ACCT_NUM as extAcctNum,
	isqo.EXT_ACCT_NAME as extAcctName
from
	TTRD_SHCH2_INTRST_SET_QRY_OUT isqo
<where>
	<if test="sid != null and sid != ''">
		AND isqo.SID = #{sid}
	</if>
</where>