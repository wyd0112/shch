select
	tdno.BIZ_DATE as bizDate,
	tdno.SRC_TRADE_ID as srcTradeId,
	tdno.TRADE_ID as tradeId,
	d1.DICT_VALUE as tradeSrc,
	'' as refSrcTradeId,
	'' as refTradeId,
	d2.DICT_VALUE as tradeDealStatus,
	tdno.TRADE_DATE as tradeDate,
	d3.DICT_VALUE as clearKind,
	d4.DICT_VALUE as clearNettingType,
	d5.DICT_VALUE as initSettleMode,
	tdno.INIT_SETTLE_DT as initSettleDt,
	tdno.SETTLE_AMT as settleAmt,
	tdno.SETTLE_CCY as settleCcy,
	tdno.ACCRUED_INTRST_TOTAL_AMT as accruedIntrstTotalAmt,
	tdno.DUE_YIELD as dueYield,
	tdno.SELLER_HOLDER_ACCT_NUM as sellerHolderAcctNum,
	tdno.BUYER_HOLDER_ACCT_NUM as buyerHolderAcctNum,
	tdno.SELLER_HOLDER_SNAME as sellerHolderSname,
	tdno.BUYER_HOLDER_SNAME as buyerHolderSname,
	tdno.SELLER_AGENCY_HOLDER_ACCT_NUM as sellerAgencyHolderAcctNum,
	tdno.BUYER_AGENCY_HOLDER_ACCT_NUM as buyerAgencyHolderAcctNum,
	tdno.SELLER_AGENCY_HOLDER_SNAME as sellerAgencyHolderSname,
	tdno.BUYER_AGENCY_HOLDER_SNAME as buyerAgencyHolderSname,
	d6.DICT_VALUE as sellerTradeStatus,
	d7.DICT_VALUE as buyerTradeStatus,
	d8.DICT_VALUE as tradeStatus,
	tdno.UPDATETIME as updatetime,
	tdno.IMPTIME as imptime,
	tdno.REMARK as remark
from
	TTRD_SHCH2_TRD_DETAIL_NET_OUT tdno
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_TRADE_SRC' ) d1 on tdno.TRADE_SRC = d1.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_TRADE_DEAL_STATUS' ) d2 on tdno.TRADE_DEAL_STATUS = d2.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_CLEAR_KIND' ) d3 on tdno.CLEAR_KIND = d3.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_CLEAR_NETTING_TYPE' ) d4 on tdno.CLEAR_NETTING_TYPE = d4.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SETTLE_MODE' ) d5 on tdno.INIT_SETTLE_MODE = d5.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SHCH_TRADE_STATUS' ) d6 on tdno.SELLER_TRADE_STATUS = d6.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SHCH_TRADE_STATUS' ) d7 on tdno.BUYER_TRADE_STATUS = d7.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_TRADE_STATUS' ) d8 on tdno.TRADE_STATUS = d8.DICT_KEY
<where>
	<if test="sid != null and sid != ''">
		AND tdno.SID = #{sid}
	</if>
</where>