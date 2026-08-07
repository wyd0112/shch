select
	tdno.SID as sid,
	tdno.TRADE_ID as tradeId,
	tdno.SRC_TRADE_ID as srcTradeId,
	d1.DICT_VALUE as tradeStatus,
	tdno.BIZ_DATE as bizDate,
	d2.DICT_VALUE as tradeDealStatus,
	d3.DICT_VALUE as tradeSrc,
	tdno.TRADE_DATE as tradeDate,
	d4.DICT_VALUE as clearKind,
	d5.DICT_VALUE as clearNettingType,
	d6.DICT_VALUE as initSettleMode,
	tdno.INIT_SETTLE_DT as initSettleDt,
	FORMAT(tdno.INIT_SETTLE_AMT, 2) as initSettleAmt,
	d7.DICT_VALUE as dueSettleMode,
	tdno.DUE_SETTLE_DT as dueSettleDt,
	FORMAT(tdno.DUE_SETTLE_AMT, 2) as dueSettleAmt,
	tdno.SETTLE_CCY as settleCcy,
	FORMAT(tdno.ACCRUED_INTRST_TOTAL_AMT, 2) as accruedIntrstTotalAmt,
	tdno.REPO_DAYS as repoDays,
	FORMAT(tdno.REPO_IR, 4) as repoIr,
	tdno.BUYER_HOLDER_ACCT_NUM as buyerHolderAcctNum,
	tdno.BUYER_HOLDER_SNAME as buyerHolderSname,
	tdno.BUYER_AGENCY_HOLDER_ACCT_NUM as buyerAgencyHolderAcctNum,
	tdno.BUYER_AGENCY_HOLDER_SNAME as buyerAgencyHolderSname,
	d8.DICT_VALUE as buyerTradeStatus,
	tdno.SELLER_HOLDER_ACCT_NUM as sellerHolderAcctNum,
	tdno.SELLER_HOLDER_SNAME as sellerHolderSname,
	tdno.SELLER_AGENCY_HOLDER_ACCT_NUM as sellerAgencyHolderAcctNum,
	tdno.SELLER_AGENCY_HOLDER_SNAME as sellerAgencyHolderSname,
	d9.DICT_VALUE as sellerTradeStatus,
	tdno.REMARK as remark,
	tdno.IMPTIME as imptime,
	tdno.UPDATETIME as updatetime,
	bndo.BOND_SETTLE_ORDER_ID as bondSettleOrderId,
	cndo.CASH_SETTLE_ORDER_ID as cashSettleOrderId,
	d10.DICT_VALUE as bondSettleOrderStatus,
	d11.DICT_VALUE as cashSettleOrderStatus
from
	TTRD_SHCH2_TRD_DETAIL_NET_OUT tdno
left join
	TTRD_SHCH2_BOND_NET_DET_OUT bndo on tdno.SRC_TRADE_ID = bndo.SRC_TRADE_ID
left join
	TTRD_SHCH2_CASH_NET_DET_OUT cndo on tdno.SRC_TRADE_ID = cndo.SRC_TRADE_ID
left join
	TTRD_SHCH2_BND_SETTL_ORDER_OUT bsoo on bndo.BOND_SETTLE_ORDER_ID = bsoo.BOND_SETTLE_ORDER_ID
left join
	TTRD_SHCH2_CASH_SETTLE_ORD_OUT csoo on cndo.CASH_SETTLE_ORDER_ID = csoo.CASH_SETTLE_ORDER_ID
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_TRADE_STATUS' ) d1 on tdno.TRADE_STATUS = d1.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_TRADE_DEAL_STATUS' ) d2 on tdno.TRADE_DEAL_STATUS = d2.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_TRADE_SRC' ) d3 on tdno.TRADE_SRC = d3.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_CLEAR_KIND' ) d4 on tdno.CLEAR_KIND = d4.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_CLEAR_NETTING_TYPE' ) d5 on tdno.CLEAR_NETTING_TYPE = d5.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SETTLE_MODE' ) d6 on tdno.INIT_SETTLE_MODE = d6.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SETTLE_MODE' ) d7 on tdno.DUE_SETTLE_MODE = d7.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SHCH_TRADE_STATUS' ) d8 on tdno.BUYER_TRADE_STATUS = d8.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SHCH_TRADE_STATUS' ) d9 on tdno.SELLER_TRADE_STATUS = d9.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SETTLE_ORDER_STATUS' ) d10 on bsoo.BOND_SETTLE_ORDER_STATUS = d10.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SETTLE_ORDER_STATUS' ) d11 on csoo.CASH_SETTLE_ORDER_STATUS = d11.DICT_KEY
<where>
    tdno.CLEAR_KIND = 'NOR'
	<if test="(bondCode != null and bondCode != '') or (bondSname != null and bondSname != '')">
        and
		exists (
			select
				1
			from
				TTRD_SHCH2_GROSS_BOND_INFO gbi
			where
				tdno.TRADE_ID = gbi.TRADE_ID
				<if test="bondCode != null and bondCode != ''">
					and gbi.BOND_CODE = #{bondCode}
				</if>
				<if test="bondSname != null and bondSname != ''">
					and gbi.BOND_SNAME = #{bondSname}
				</if>
		)
	</if>
	<if test="ourPartyHolderAcctNum != null and ourPartyHolderAcctNum != ''">
		AND (
			(tdno.BUYER_HOLDER_ACCT_NUM in ('0000018','B8609033') and tdno.BUYER_HOLDER_ACCT_NUM = #{ourPartyHolderAcctNum})
			or
			(tdno.BUYER_HOLDER_ACCT_NUM not in ('0000018','B8609033') and tdno.SELLER_HOLDER_ACCT_NUM = #{ourPartyHolderAcctNum})
		)
	</if>
	<if test="counterpartyHolderAcctNum != null and counterpartyHolderAcctNum != ''">
		AND (
			(tdno.BUYER_HOLDER_ACCT_NUM in ('0000018','B8609033') and tdno.SELLER_HOLDER_ACCT_NUM = #{counterpartyHolderAcctNum})
			or
			(tdno.BUYER_HOLDER_ACCT_NUM not in ('0000018','B8609033') and tdno.BUYER_HOLDER_ACCT_NUM = #{counterpartyHolderAcctNum})
		)
	</if>
	<if test="tradeId != null and tradeId != ''">
		AND tdno.TRADE_ID = #{tradeId}
	</if>
	<if test="srcTradeId != null and srcTradeId != ''">
		AND tdno.SRC_TRADE_ID = #{srcTradeId}
	</if>
	<if test="tradeSrc != null and tradeSrc != ''">
		AND tdno.TRADE_SRC = #{tradeSrc}
	</if>
	<if test="tradeStatus != null and tradeStatus != ''">
		AND tdno.TRADE_STATUS = #{tradeStatus}
	</if>
	<if test="tradeDateBegin != null and tradeDateBegin != ''">
		AND tdno.TRADE_DATE &gt;= #{tradeDateBegin}
	</if>
	<if test="tradeDateEnd != null and tradeDateEnd != ''">
		AND tdno.TRADE_DATE &lt;= #{tradeDateEnd}
	</if>
	<if test="initSettleDtBegin != null and initSettleDtBegin != ''">
		AND tdno.INIT_SETTLE_DT &gt;= #{initSettleDtBegin}
	</if>
	<if test="initSettleDtEnd != null and initSettleDtEnd != ''">
		AND tdno.INIT_SETTLE_DT &lt;= #{initSettleDtEnd}
	</if>
	<if test="dueSettleDtBegin != null and dueSettleDtBegin != ''">
		AND tdno.DUE_SETTLE_DT &gt;= #{dueSettleDtBegin}
	</if>
	<if test="dueSettleDtEnd != null and dueSettleDtEnd != ''">
		AND tdno.DUE_SETTLE_DT &lt;= #{dueSettleDtEnd}
	</if>
</where>
order by
	tdno.TRADE_DATE desc,
	tdno.BIZ_DATE desc,
	tdno.INIT_SETTLE_DT desc,
	tdno.DUE_SETTLE_DT desc