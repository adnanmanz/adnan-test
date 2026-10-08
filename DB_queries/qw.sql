EXPLAIN ANALYZE
SELECT
    "PC0"."pyguid" AS "pyGUID", - PK
    "PC0"."fcpid" AS "FCPID",
    "PC0"."clearing_ref_number" AS "clearing_ref_number",
    "PC0"."contract_number" AS "contract_number",
    "PC0"."counter_party" AS "counter_party",
    "PC0"."country_of_domicile" AS "country_of_domicile",
    "PC0"."creditor_account_number" AS "creditor_account_number",
    "PC0"."currency_amount" AS "currency_amount",
    "PC0"."currency" AS "currency",
    "PC0"."currency_code" AS "currency_code",
    "PC0"."deal_code" AS "deal_code",
    "PC0"."deal_number" AS "deal_number",
    "PC0"."deal_portfolio" AS "deal_portfolio",
    "PC0"."deal_status" AS "deal_status",
    "PC0"."dealarea" AS "dealarea",
    "PC0"."debtor_account_number" AS "debtor_account_number",
    "PC0"."debtor_name" AS "debtor_name",
    "PC0"."device_id" AS "device_id",
    "PC0"."end_to_end_id" AS "end_to_end_id",
    "PC0"."entry_date" AS "entry_date",
    "PC0"."entry_time" AS "entry_time",
    "PC0"."executing_account_number" AS "executing_account_number",
    "PC0"."executing_party_number" AS "executing_party_number",
    "PC0"."expiry_date" AS "expiry_date",
    "PC0"."flow_id" AS "flow_id",
    "PC0"."initator" AS "initator",
    "PC0"."initiator_party_number" AS "initiator_party_number",
    "PC0"."initiator_registered_mobile" AS "initiator_registered_mobile",
    "PC0"."instruction_id" AS "instruction_id",
    "PC0"."ip_address" AS "ip_address",
    "PC0"."legal_account_beneficiary" AS "legal_account_beneficiary",
    "PC0"."legal_remitter_account_name" AS "legal_remitter_account_name",
    "PC0"."location" AS "location",
    "PC0"."login_id" AS "login_id",
    "PC0"."low_high_priority_flag" AS "low_high_priority_flag",
    "PC0"."merchant_category_code" AS "merchant_category_code",
    "PC0"."merchant_name_address" AS "merchant_name_address",
    "PC0"."original_deal_number" AS "original_deal_number",
    "PC0"."payment_flag" AS "payment_flag",
    "PC0"."payment_reference_text" AS "payment_reference_text",
    "PC0"."portfolio" AS "portfolio",
    "PC0"."postcode" AS "postcode",
    "PC0"."product" AS "product",
    "PC0"."pxcommitdatetime" AS "pxCommitDateTime",
    "PC0"."pxcreatedatetime" AS "pxCreateDateTime",
    "PC0"."pylabel" AS "pyLabel",
    "PC0"."rate" AS "rate",
    "PC0"."reason2" AS "reason2",
    "PC0"."receiver_adi" AS "receiver_adi",
    "PC0"."recipient_mobile" AS "recipient_mobile",
    "PC0"."recipient_name" AS "recipient_name",
    "PC0"."reference_number" AS "reference_number",
    "PC0"."remittance_information" AS "remittance_information",
    "PC0"."remitter_ext_account_number" AS "remitter_ext_account_number",
    "PC0"."sender_adi" AS "sender_adi",
    "PC0"."settlement_amount" AS "settlement_amount",
    "PC0"."settlement_amount_aud" AS "settlement_amount_aud",
    "PC0"."settlement_currency" AS "settlement_currency",
    "PC0"."settlement_date" AS "settlement_date",
    "PC0"."settlement_direction" AS "settlement_direction",
    "PC0"."short_name" AS "short_name",
    "PC0"."source_system_name" AS "source_system_name",
    "PC0"."staff_member_id" AS "staff_member_id",
    "PC0"."staff_member_name" AS "staff_member_name",
    "PC0"."staff_member_number_id" AS "staff_member_number_id",
    "PC0"."terminal_desc" AS "terminal_desc",
    "PC0"."tmc_location_of_debit" AS "tmc_location_of_debit",
    "PC0"."trade_date" AS "trade_date",
    "PC0"."trade_number" AS "trade_number",
    "PC0"."trade_rate" AS "trade_rate",
    "PC0"."trade_value1" AS "trade_value1",
    "PC0"."trade_value1_aud" AS "trade_value1_aud",
    "PC0"."trade_value2" AS "trade_value2",
    "PC0"."trade_value2_aud" AS "trade_value2_aud",
    "PC0"."transaction_country_name" AS "transaction_country_name",
    "PC0"."transaction_currency_code" AS "transaction_currency_code",
    "PC0"."transaction_amount" AS "transaction_amount",
    "PC0"."transaction_date" AS "transaction_date",
    "PC0"."transaction_description" AS "transaction_description",
    "PC0"."transaction_currency_amount" AS "transaction_currency_amount",
    "PC0"."transaction_id" AS "transaction_id",
    "PC0"."transaction_location" AS "transaction_location",
    "PC0"."transaction_reference_number" AS "transaction_reference_number",
    "PC0"."transaction_status" AS "transaction_status",
    "PC0"."transaction_sub_type" AS "transaction_sub_type",
    "PC0"."transaction_time" AS "transaction_time",
    "PC0"."transaction_type" AS "transaction_type",
    "PC0"."transactioncountryname" AS "transactioncountryname",
    "PC0"."travel_money_card_number" AS "travel_money_card_number",
    "PC0"."triggering_trans_indicator" AS "triggering_trans_indicator",
    "PC0"."typology" AS "typology",
    "PC0"."used_browser" AS "used_browser",
    "PC0"."value_date" AS "value_date",
    "PC0"."accountnumber" AS "AccountNumber",
    "PC0"."appl" AS "Appl",
    "PC0"."cifnbr" AS "CifNbr",
    "PC0"."customertype" AS "CustomerType",
    "PC0"."fullname" AS "FullName",
    "PC0"."isprimarycontact" AS "IsPrimaryContact",
    "PC0"."status" AS "Status",
    "PC0"."account_alias" AS "account_alias",
    "PC0"."account_number" AS "account_number",
    "PC0"."area" AS "area",
    "PC0"."authorization_type" AS "authorization_type",
    "PC0"."bank_product_flag" AS "bank_product_flag",
    "PC0"."beneficary_ext_account_number" AS "beneficary_ext_account_number",
    "PC0"."beneficiary_account_number" AS "beneficiary_account_number",
    "PC0"."beneficiary_party" AS "beneficiary_party",
    "PC0"."broker" AS "broker",
    "PC0"."bulk_transaction_indicator" AS "bulk_transaction_indicator",
    "PC0"."bysell" AS "bysell",
    "PC0"."caic" AS "caic",
    "PC0"."card_number" AS "card_number",
    "PC0"."ccy1" AS "ccy1",
    "PC0"."ccy2" AS "ccy2",
    "PC0"."branch" AS "branch",
    "PC0"."cba_atm_deposit_type" AS "cba_atm_deposit_type",
    "PC0"."transactional_date" AS "Transactional_date",
    "PC0"."remitter_country" AS "Remitter_Country",
    "PC0"."beneficiary_country" AS "Beneficiary_Country",
    "PC0"."intermediary_country_1" AS "intermediary_country_1",
    "PC0"."intermediary_country_2" AS "intermediary_country_2",
    "PC0"."intermediary_country_3" AS "intermediary_country_3",
    "PC0"."sender_info_text" AS "sender_info_text",
    "PC0"."receiver_info_text" AS "receiver_info_text",
    "PC0"."swift_message_type" AS "SWIFT_message_type",
    "PC0"."card_present_indicator" AS "card_present_indicator",
    "PC0"."mechanism_desc" AS "Mechanism_Desc"
FROM
    customerdata.pr_cbagrp_fch_data_alert_ee690 "PC0"
WHERE ("PC0"."fcpid" = '1378364' --- > - -- -->> 
    AND "PC0"."triggering_trans_indicator" = 'Y') 
   
ORDER BY
    1 ASC

    --- quey 

-- RD - 3 staages - what - execution - 
- - hitting db 
- - 2nd 
-- 90 - sugges

2, 
    -- 
    1 seconds 
    1 5 seconds 
     90 seconds 


--> RDp 
- iO wait_event
2k - 12k and 14k 



table(fcpid) where pyguid is not null, 


ALTER TABLE PEGADATA.Enrollment_Billing_Work DROP COLUMN delinquecysenddate;

ALTER TABLE DATA.Enrollment_Billing_Work DROP COLUMN autopayreminderdate;


remve columnm - pr_service util 


SELECT data_type, character_maximum_length 
FROM information_schema.columns 
WHERE table_name = 'your_table_name' 
  AND column_name = 'your_column_name';




SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'pr_mhsc_fw_fcrdfw_data_nyusyuk'
  AND table_schema = 'data';