with t1 as (
	select
		case
			when BUYER_HOLDER_ACCT_NUM in ('0000018','B8609033') then BUYER_TRADE_STATUS
			else SELLER_TRADE_STATUS
		end as ourPartyTradeStatus,
		case
			when BUYER_HOLDER_ACCT_NUM in ('0000018','B8609033') then SELLER_TRADE_STATUS
			else BUYER_TRADE_STATUS
		end as counterpartyTradeStatus
	from
		TTRD_SHCH2_TRADE_DETAIL_OUT
),
t2 as (
	select
		GROSS_SETTLE_ORDER_STATUS as grossSettleOrderStatus
	from
		ccdc.TTRD_SHCH2_GROSS_SETTL_ORD_OUT
),
t3 as (
	SELECT
		CASH_SETTLE_ORDER_STATUS as cashSettleOrderStatus
	FROM
		TTRD_SHCH2_CASH_SETTLE_ORD_OUT
),
t4 as (
	SELECT
		BOND_SETTLE_ORDER_STATUS as bondSettleOrderStatus
	FROM
		TTRD_SHCH2_BND_SETTL_ORDER_OUT
),
t5 as (
	SELECT
		PAY_FEE_STATUS as payFeeStatus
	FROM
		TTRD_SHCH2_FEE_BILL_QUERY_OUT
	WHERE
		PRIMARY_FEE_ITEM_CN IN ('债券全额业务费用','兑付兑息服务费','发行登记服务费')
),
t6 as (
	SELECT
		PAY_FEE_STATUS as payFeeStatus
	FROM
		TTRD_SHCH2_FEE_BILL_QUERY_OUT
	WHERE
		PRIMARY_FEE_ITEM_CN IN ('债券净额业务费用','中央债券借贷费用')
)
select
	( select
		count(*)
	from
		t1
	where
		t1.ourPartyTradeStatus = 'C') as unfinishedTradeByUs,
	( select
		count(*)
	from
		t1
	where
		t1.counterpartyTradeStatus = 'C') as unfinishedTradeByCounter,
	( select
		count(*)
	from
		t2
	where
		t2.grossSettleOrderStatus = '3') as unfinishedInsByMoney,
	( select
		count(*)
	from
		t2
	where
		t2.grossSettleOrderStatus = '1') as unfinishedInsByBond,
	( select
		count(*)
	from
		t2
	where
		t2.grossSettleOrderStatus = 'F') as unfinishedInsByFailing,
	( select
		count(*)
	from
		t2
	where
		t2.grossSettleOrderStatus = 'X') as unfinishedInsByCanceling,
	( select
		count(*)
	from
		t3
	where
		t3.cashSettleOrderStatus = '0') as unfinishedNetMoneyInsByPending,
	( select
		count(*)
	from
		t3
	where
		t3.cashSettleOrderStatus = '1') as unfinishedNetMoneyInsByTrading,
	( select
		count(*)
	from
		t3
	where
		t3.cashSettleOrderStatus = '2') as unfinishedNetMoneyInsByCutoff,
	( select
		count(*)
	from
		t3
	where
		t3.cashSettleOrderStatus = '8') as unfinishedNetMoneyInsByPreSuccess,
	( select
		count(*)
	from
		t3
	where
		t3.cashSettleOrderStatus = 'D') as unfinishedNetMoneyInsByDefault,
	( select
		count(*)
	from
		t3
	where
		t3.cashSettleOrderStatus = 'DY') as unfinishedNetMoneyInsByDefaultSettled,
	( select
		count(*)
	from
		t3
	where
		t3.cashSettleOrderStatus = 'B') as unfinishedNetMoneyInsByPendingDispose,
	( select
		count(*)
	from
		t3
	where
		t3.cashSettleOrderStatus = 'BY') as unfinishedNetMoneyInsByDisposed,
	( select
		count(*)
	from
		t4
	where
		t4.bondSettleOrderStatus = '0') as unfinishedNetBondInsByPending,
	( select
		count(*)
	from
		t4
	where
		t4.bondSettleOrderStatus = '1') as unfinishedNetBondInsByTrading,
	( select
		count(*)
	from
		t4
	where
		t4.bondSettleOrderStatus = '2') as unfinishedNetBondInsByCutoff,
	( select
		count(*)
	from
		t4
	where
		t4.bondSettleOrderStatus = '8') as unfinishedNetBondInsByPreSuccess,
	( select
		count(*)
	from
		t4
	where
		t4.bondSettleOrderStatus = 'D') as unfinishedNetBondInsByDefault,
	( select
		count(*)
	from
		t4
	where
		t4.bondSettleOrderStatus = 'DY') as unfinishedNetBondInsByDefaultSettled,
	( select
		count(*)
	from
		t4
	where
		t4.bondSettleOrderStatus = 'B') as unfinishedNetBondInsByPendingDispose,
	( select
		count(*)
	from
		t4
	where
		t4.bondSettleOrderStatus = 'BY') as unfinishedNetBondInsByDisposed,
	( select
		count(*)
	from
		t5
	where
		t5.payFeeStatus in ('N', 'P')) as bondGrossUnpaidFee,
	( select
		count(*)
	from
		t6
	where
		t6.payFeeStatus in ('N', 'P')) as bondNetUnpaidFee