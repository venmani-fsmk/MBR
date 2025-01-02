select DATE_TRUNC('MONTH',PIPEDRIVE_DEAL_CREATED_LCL_TS::date) AS REFERENCE_DATE, 
    BACMAN_L1_CHANNEL_NAME,
    count(*) as METRIC, 
    sum(case when HAVE_MADE_TO_S1_CONTACT_MADE_STAGE_FLAG=True then 1 else 0 end) as contact_made, 
    sum(case when HAVE_MADE_TO_S2_LEAD_QUALIFIED_STAGE_FLAG=True then 1 else 0 end) as lead_qualified, 
    sum(case when HAVE_MADE_TO_S3_APP_SUBMITTED_STAGE_FLAG=True then 1 else 0 end) as app_submitted, 
    sum(case when HAVE_MADE_TO_S4_APP_APPROVED_STAGE_FLAG=True then 1 else 0 end) as app_approved, 
    sum(case when have_made_to_final_won_stage_flag=True then 1 else 0 end) as total_won,
    from CDM.OPERATIONS.MY_PIPEDRIVE_DEAL_CONVERSION_T a
    --where a.pipedrive_deal_pipeline_name='MY - Micro Pipeline'
    --and a.PIPEDRIVE_DEAL_STATUS!='open'
    WHERE (a.pipedrive_deal_type!='New to FS' or a.pipedrive_deal_type is NULL)
    group by REFERENCE_DATE,BACMAN_L1_CHANNEL_NAME
    order by REFERENCE_DATE desc;
