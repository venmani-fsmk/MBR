-- Code for calculating principal outstanding on each date for MY Borrowers
-- The value which is tagged as METRIC will be the one shown in charts
-- We will be showing the top 5 products based on number of unique borrowers (hence why grouped based on categories, can change the categories)
select reference_date,     
    CASE
    WHEN A.LOAN_PRODUCT_NAME = 'Bolt (Islamic Financing)' THEN 'Bolt'
    WHEN A.LOAN_PRODUCT_NAME = 'BOLT-MY' THEN 'Bolt'
    WHEN A.LOAN_PRODUCT_NAME = 'Bolt (Islamic Financing - CGCD)' THEN 'Bolt'
    WHEN A.LOAN_PRODUCT_NAME = 'Business Term Financing' THEN 'BTF'
    WHEN A.LOAN_PRODUCT_NAME = 'Business Term Financing (Islamic Financing)' THEN 'BTF'
    WHEN A.LOAN_PRODUCT_NAME = 'Business Term Financing (CGC - Islamic Financing)' THEN 'BTF'
    WHEN A.LOAN_PRODUCT_NAME = 'Business Term Financing (CGC)' THEN 'BTF'
    WHEN A.LOAN_PRODUCT_NAME = 'Business Term Financing (Secured)' THEN 'BTF'
    WHEN A.LOAN_PRODUCT_NAME = 'Business Term Financing (FSC)' THEN 'BTF'
    WHEN A.LOAN_PRODUCT_NAME = 'Micro Credit Line (CGCD)' THEN 'Micro Credit Line'
    WHEN A.LOAN_PRODUCT_NAME = 'Express AP Financing (Islamic Financing)' THEN 'AP Financing'
    WHEN A.LOAN_PRODUCT_NAME = 'AP Financing (Islamic Financing)' THEN 'AP Financing'
    WHEN A.LOAN_PRODUCT_NAME = 'AP Financing (Islamic Financing - CGCD)' THEN 'AP Financing'
    WHEN A.LOAN_PRODUCT_NAME = 'Micro AP Financing (Islamic Financing)' THEN 'AP Financing'
    WHEN A.LOAN_PRODUCT_NAME = 'Micro AP Financing' THEN 'AP Financing'
    WHEN A.LOAN_PRODUCT_NAME = 'Express AP Financing' THEN 'AP Financing'
    WHEN A.LOAN_PRODUCT_NAME = 'AP Term Line (Islamic Financing)' THEN 'AP Financing'
    ELSE A.LOAN_PRODUCT_NAME
    END as NEW_PRODUCT_NAME,
    sum(principal_outstanding_lcl_amt) as TOTAL_PRINCIPAL_OUTSTANDING,
    -- Recoverable Principal Outstanding is the METRIC and it will be shown in the charts
    sum(case when is_non_recoverable_flag=False then principal_outstanding_lcl_amt else 0 end) as METRIC,
    sum(case when is_non_recoverable_flag=True then principal_outstanding_lcl_amt else 0 end) as non_recoverable_principal_outstanding,
    count(distinct(a.cmd_ctr_borrower_id)) as unique_borrowers
    from adm.transaction.loan_daily_outstanding_denorm_t a 
    left join adm.transaction.loan_denorm_t b 
    on a.dwh_loan_id = b.dwh_loan_id
    where a.loan_platform_country_code=%(country)s
    AND a.LOAN_ORIGINATION_LCL_AMT!=0
    and b.loan_stage_id = 5
    and loan_product_type!='FSMK_SOURCE_OF_FUND'
    group by reference_date, NEW_PRODUCT_NAME
