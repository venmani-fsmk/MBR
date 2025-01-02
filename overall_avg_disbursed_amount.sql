select  DATE_TRUNC('MONTH',LOAN_CREATED_AT_LCL_TS::date) as REFERENCE_DATE,     
    avg(loan_disbursal_lcl_amt) as metric,
    count(distinct(cmd_ctr_loan_id)) as num_loans,
    count(distinct(a.cmd_ctr_borrower_id)) as unique_borrowers
    from adm.transaction.loan_denorm_t a
    where a.loan_platform_country_code=%(country)s
    AND a.LOAN_ORIGINATION_LCL_AMT!=0
    and a.loan_stage_id = 5
    and loan_product_type!='FSMK_SOURCE_OF_FUND'
    group by reference_date
