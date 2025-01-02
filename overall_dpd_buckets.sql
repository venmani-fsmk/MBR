-- Code for extracting DPD Buckets
select reference_date,     
    sum(principal_outstanding_lcl_amt) as total_outstanding,
    sum(case when A.loan_max_dpd_unpaid_lcl_days>30 and is_non_recoverable_flag=False then principal_outstanding_lcl_amt else 0 end) as metric,
    sum(case when A.loan_max_dpd_unpaid_lcl_days<=0 and is_non_recoverable_flag=False then principal_outstanding_lcl_amt else 0 end) as principal_outs_0,
    sum(case when A.loan_max_dpd_unpaid_lcl_days>0 and A.loan_max_dpd_unpaid_lcl_days<=7 and is_non_recoverable_flag=False then principal_outstanding_lcl_amt else 0 end) as dpd0_7_rec,
    sum(case when A.loan_max_dpd_unpaid_lcl_days>7 and A.loan_max_dpd_unpaid_lcl_days<=30 and is_non_recoverable_flag=False then principal_outstanding_lcl_amt else 0 end) as dpd7_30_rec,
    sum(case when A.loan_max_dpd_unpaid_lcl_days>30 and A.loan_max_dpd_unpaid_lcl_days<=90 and is_non_recoverable_flag=False then principal_outstanding_lcl_amt else 0 end) as dpd30_90_rec,
    sum(case when A.loan_max_dpd_unpaid_lcl_days>90 and is_non_recoverable_flag=False then principal_outstanding_lcl_amt else 0 end) as dpd90_rec,
    sum(case when is_non_recoverable_flag=True then principal_outstanding_lcl_amt else 0 end) as non_recoverable,
    count(distinct(a.cmd_ctr_borrower_id)) as unique_borrowers
    from adm.transaction.loan_daily_outstanding_denorm_t a 
    left join adm.transaction.loan_denorm_t b 
    on a.dwh_loan_id = b.dwh_loan_id
    where a.loan_platform_country_code=%(country)s
    AND a.LOAN_ORIGINATION_LCL_AMT!=0
    and b.loan_stage_id = 5
    and loan_product_type!='FSMK_SOURCE_OF_FUND'
    group by reference_date
