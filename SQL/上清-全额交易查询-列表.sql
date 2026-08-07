select
	tdo.SID as sid,
	tdo.TRADE_ID as tradeId,
	tdo.SRC_TRADE_ID as srcTradeId,
	d1.DICT_VALUE as tradeStatus,
	'全额结算' as clearMode,
	tdo.BIZ_DATE as bizDate,
	tdo.INIT_SETTLE_DT as initSettleDt,
	tdo.BUYER_HOLDER_SNAME as buyerHolderSname,
	tdo.SELLER_HOLDER_SNAME as sellerHolderSname,
	d2.DICT_VALUE as buyerTradeStatus,
	d3.DICT_VALUE as sellerTradeStatus,
	tdo.IMPTIME as imptime,
	tdo.UPDATE_TM as updateTm
from
	TTRD_SHCH2_TRADE_DETAIL_OUT tdo
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_TRADE_STATUS' ) d1 on tdo.TRADE_STATUS = d1.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SHCH_TRADE_STATUS' ) d2 on tdo.BUYER_TRADE_STATUS = d2.DICT_KEY
left join ( select DICT_KEY, DICT_VALUE from nws.DICT where DICT_TYPE = 'SQ_SHCH_TRADE_STATUS' ) d3 on tdo.SELLER_TRADE_STATUS = d3.DICT_KEY
<where>
	<if test="(bondCode != null and bondCode != '') or (bondSname != null and bondSname != '')">
		and exists (
			select
				1
			from
				TTRD_SHCH2_GROSS_BOND_INFO gbi
			where
				tdo.TRADE_ID = gbi.TRADE_ID
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
			(tdo.BUYER_HOLDER_ACCT_NUM in ('0000018','B8609033') and tdo.BUYER_HOLDER_ACCT_NUM = #{ourPartyHolderAcctNum})
			or
			(tdo.BUYER_HOLDER_ACCT_NUM not in ('0000018','B8609033') and tdo.SELLER_HOLDER_ACCT_NUM = #{ourPartyHolderAcctNum})
		)
	</if>
	<if test="counterpartyHolderAcctNum != null and counterpartyHolderAcctNum != ''">
		AND (
			(tdo.BUYER_HOLDER_ACCT_NUM in ('0000018','B8609033') and tdo.SELLER_HOLDER_ACCT_NUM = #{counterpartyHolderAcctNum})
			or
			(tdo.BUYER_HOLDER_ACCT_NUM not in ('0000018','B8609033') and tdo.BUYER_HOLDER_ACCT_NUM = #{counterpartyHolderAcctNum})
		)
	</if>
	<if test="ourPartyTradeStatus != null and ourPartyTradeStatus != ''">
		AND (
			(tdo.BUYER_HOLDER_ACCT_NUM in ('0000018','B8609033') and tdo.BUYER_TRADE_STATUS = #{ourPartyTradeStatus})
			or
			(tdo.BUYER_HOLDER_ACCT_NUM not in ('0000018','B8609033') and tdo.SELLER_TRADE_STATUS = #{ourPartyTradeStatus})
		)
	</if>
	<if test="counterpartyTradeStatus != null and counterpartyTradeStatus != ''">
		AND (
			(tdo.BUYER_HOLDER_ACCT_NUM in ('0000018','B8609033') and tdo.SELLER_TRADE_STATUS = #{counterpartyTradeStatus})
			or
			(tdo.BUYER_HOLDER_ACCT_NUM not in ('0000018','B8609033') and tdo.BUYER_TRADE_STATUS = #{counterpartyTradeStatus})
		)
	</if>
	<if test="srcTradeId != null and srcTradeId != ''">
		AND tdo.SRC_TRADE_ID = #{srcTradeId}
	</if>
	<if test="tradeId != null and tradeId != ''">
		AND tdo.TRADE_ID = #{tradeId}
	</if>
	<if test="tradeStatus != null and tradeStatus != ''">
		AND tdo.TRADE_STATUS = #{tradeStatus}
	</if>
	<if test="tradeDateBegin != null and tradeDateBegin != ''">
		AND tdo.TRADE_DATE &gt;= #{tradeDateBegin}
	</if>
    <if test="tradeDateEnd != null and tradeDateEnd != ''">
		AND tdo.TRADE_DATE &lt;= #{tradeDateEnd}
	</if>
	<if test="tradeKind != null and tradeKind != ''">
		AND tdo.TRADE_KIND = #{tradeKind}
	</if>
	<if test="initSettleDtBegin != null and initSettleDtBegin != ''">
		AND tdo.INIT_SETTLE_DT &gt;= #{initSettleDtBegin}
	</if>
    <if test="initSettleDtEnd != null and initSettleDtEnd != ''">
		AND tdo.INIT_SETTLE_DT &lt;= #{initSettleDtEnd}
	</if>
	<if test="dueSettleDtBegin != null and dueSettleDtBegin != ''">
		AND tdo.DUE_SETTLE_DT &gt;= #{dueSettleDtBegin}
	</if>
    <if test="dueSettleDtEnd != null and dueSettleDtEnd != ''">
		AND tdo.DUE_SETTLE_DT &lt;= #{dueSettleDtEnd}
	</if>
	<if test="settleCcy != null and settleCcy != ''">
		AND tdo.SETTLE_CCY = #{settleCcy}
	</if>
</where>