select
	tdo.BIZ_DATE as bizDate,
	d1.DICT_VALUE as tradeSrc,
	d2.DICT_VALUE as tradeDealStatus,
	d3.DICT_VALUE as tradeKind,
	tdo.TRADE_SUBCAT_ID as tradeSubcatId,
	d4.DICT_VALUE as initSettleMode,
	d5.DICT_VALUE as dueSettleMode,
	tdo.SELLER_HOLDER_ACCT_NUM as sellerHolderAcctNum,
	tdo.SELLER_HOLDER_SNAME as sellerHolderSname,
	tdo.SELLER_INVESTOR_FLAGS as sellerInvestorFlags,
	tdo.SELLER_AGENCY_MEM_ACCT_NUM as sellerAgencyMemAcctNum,
	tdo.SELLER_AGENCY_MEM_SNAME as sellerAgencyMemSname,
	d6.DICT_VALUE as sellerTradeStatus,
	tdo.SELLER_TRADE_STATUS_UPDATE_TM as sellerTradeStatusUpdateTm,
	d7.DICT_VALUE as tradeStatus,
	tdo.UPDATE_TM as updateTm,
	tdo.REMARK as remark,
	tdo.SRC_TRADE_ID as srcTradeId,
	tdo.REF_SRC_TRADE_ID as refSrcTradeId,
	tdo.TRADE_DATE as tradeDate,
	'全额清算' as clearMode,
	tdo.TRADE_SUBCAT_NAME as tradeSubcatName,
	tdo.INIT_SETTLE_DT as initSettleDt,
	tdo.DUE_SETTLE_DT as dueSettleDt,
	tdo.BUYER_HOLDER_ACCT_NUM as buyerHolderAcctNum,
	tdo.BUYER_HOLDER_SNAME as buyerHolderSname,
	tdo.BUYER_INVESTOR_FLAGS as buyerInvestorFlags,
	tdo.BUYER_AGENCY_MEM_ACCT_NUM as buyerAgencyMemAcctNum,
	tdo.BUYER_AGENCY_MEM_SNAME as buyerAgencyMemSname,
	d8.DICT_VALUE as buyerTradeStatus,
	tdo.BUYER_TRADE_STATUS_UPDATE_TM as buyerTradeStatusUpdateTm,
	d9.DICT_VALUE as tradeAfterProcStatus,
	tdo.IMPTIME as imptime,
	tdo.TRADE_ID as tradeId,
	tdo.REF_TRADE_ID as refTradeId,
	tdo.TRADE_TM as tradeTm,
	tdo.SETTLE_CCY as settleCcy,
	FORMAT(tdo.INIT_SETTLE_AMT, 2) as initSettleAmt,
	FORMAT(tdo.DUE_SETTLE_AMT, 2) as dueSettleAmt,
	tdo.THIRD_HOLDER_ACCT_NUM as thirdHolderAcctNum,
	tdo.THIRD_HOLDER_SNAME as thirdHolderSname,
	tdo.THIRD_INVESTOR_FLAGS as thirdInvestorFlags,
	d10.DICT_VALUE as shchTradeStatus,
	tdo.SHCH_TRADE_STATUS_UPDATE_TM as shchTradeStatusUpdateTm,
	d11.DICT_VALUE as tradeExcepStatus
from
	TTRD_SHCH2_TRADE_DETAIL_OUT tdo
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_TRADE_SRC' ) d1 on tdo.TRADE_SRC = d1.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_TRADE_DEAL_STATUS') d2 on tdo.TRADE_DEAL_STATUS = d2.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_TRADE_KIND') d3 on tdo.TRADE_KIND = d3.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SETTLE_MODE') d4 on tdo.INIT_SETTLE_MODE = d4.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SETTLE_MODE') d5 on tdo.DUE_SETTLE_MODE = d5.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SHCH_TRADE_STATUS') d6 on tdo.SELLER_TRADE_STATUS = d6.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_TRADE_STATUS') d7 on tdo.TRADE_STATUS = d7.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SHCH_TRADE_STATUS') d8 on tdo.BUYER_TRADE_STATUS = d8.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_PROC_STATUS') d9 on tdo.TRADE_AFTER_PROC_STATUS = d9.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SHCH_TRADE_STATUS') d10 on tdo.SHCH_TRADE_STATUS = d10.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_EXCEP_STATUS') d11 on tdo.TRADE_EXCEP_STATUS = d11.DICT_KEY
<where>
	<if test="sid != null and sid != ''">
		AND tdo.SID = #{sid}
	</if>
</where>