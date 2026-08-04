select
	d1.DICT_VALUE as bondTradeType,
	gbi.BOND_CODE as bondCode,
	gbi.ISIN_CODE as isinCode,
	gbi.BOND_SNAME as bondSname,
	gbi.BOND_FACE_AMT as bondFaceAmt,
	gbi.FULL_PRICE as fullPrice,
	gbi.CLEAN_PRICE as cleanPrice,
	gbi.ACCRUED_INTRST as accruedIntrst,
	gbi.PLEDGOR_ACCT_NUM as pledgorAcctNum,
	gbi.PLEDGOR_SNAME as pledgorSname
from
	TTRD_SHCH2_TRADE_DETAIL_OUT tdo
left join
	TTRD_SHCH2_GROSS_BOND_INFO gbi on tdo.TRADE_ID = gbi.TRADE_ID
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_BOND_TRADE_TYPE' ) d1 on gbi.BOND_TRADE_TYPE = d1.DICT_KEY
<where>
	<if test="sid != null and sid != ''">
		AND tdo.SID = #{sid}
	</if>
</where>