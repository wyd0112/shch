select
	gbi.TRADE_ID as tradeId,
	'' as bondType,
	gbi.BOND_CODE as bondCode,
	gbi.BOND_SNAME as bondSname,
	gbi.ISIN_CODE as isinCode,
	gbi.BOND_FACE_AMT as bondFaceAmt,
	gbi.FULL_PRICE as fullPrice,
	gbi.CLEAN_PRICE as cleanPrice,
	gbi.ACCRUED_INTRST as accruedIntrst,
	gbi.PLEDGOR_ACCT_NUM as pledgorAcctNum,
	gbi.PLEDGOR_SNAME as pledgorSname,
	d1.DICT_VALUE as bondTradeType,
	'' as bondPledgeStatus,
	gbi.IMPTIME as imptime,
	gbi.UPDATETIME as updatetime
from
	TTRD_SHCH2_TRD_DETAIL_NET_OUT tdno
left join
	TTRD_SHCH2_GROSS_BOND_INFO gbi on tdno.TRADE_ID = gbi.TRADE_ID
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_BOND_TRADE_TYPE' ) d1 on gbi.BOND_TRADE_TYPE = d1.DICT_KEY
<where>
	<if test="sid != null and sid != ''">
		AND tdno.SID = #{sid}
	</if>
</where>