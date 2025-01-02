select  DATE_TRUNC('MONTH',LOAN_CREATED_AT_LCL_TS::date) as REFERENCE_DATE,     
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
    sum(loan_disbursal_lcl_amt) as metric,
    count(distinct(a.cmd_ctr_borrower_id)) as unique_borrowers
    from adm.transaction.loan_denorm_t a
    where a.loan_platform_country_code=%(country)s
    AND a.LOAN_ORIGINATION_LCL_AMT!=0
    and a.loan_stage_id = 5
    and loan_product_type!='FSMK_SOURCE_OF_FUND'
    group by reference_date, NEW_PRODUCT_NAME
