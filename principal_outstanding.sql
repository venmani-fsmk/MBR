-- Code for calculating principal outstanding on each date for MY Borrowers
select reference_date, loan_product_name, sum(principal_outstanding_lcl_amt) as metric,
    count(distinct(cmd_ctr_borrower_id)) as unique_borrowers
    from adm.transaction.loan_daily_outstanding_denorm_t
    where loan_platform_country_code='MY'
    AND LOAN_ORIGINATION_LCL_AMT!=0
    group by reference_date, loan_product_name
