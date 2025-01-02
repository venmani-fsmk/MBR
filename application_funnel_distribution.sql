select DATE_TRUNC('MONTH',PIPEDRIVE_DEAL_CREATED_LCL_TS::date) AS REFERENCE_DATE, 
    bacman_l1_channel_name, 
    count(*) as metric, 
    sum(case when HAVE_MADE_TO_S1_CONTACT_MADE_STAGE_FLAG=True then 1 else 0 end) as contact_made, 
    sum(case when HAVE_MADE_TO_S2_LEAD_QUALIFIED_STAGE_FLAG=True then 1 else 0 end) as lead_qualified, 
    sum(case when HAVE_MADE_TO_S3_APP_SUBMITTED_STAGE_FLAG=True then 1 else 0 end) as app_submitted, 
    sum(case when HAVE_MADE_TO_S4_APP_APPROVED_STAGE_FLAG=True then 1 else 0 end) as app_approved, 
    sum(case when have_made_to_final_won_stage_flag=True then 1 else 0 end) as total_won,
    total_won*100/metric as win_rate,
        TOTAL_WON*100/APP_APPROVED AS BRW_ACCEPTANCE,
    APP_APPROVED*100/APP_SUBMITTED AS UND_ACCEPTANCE,
    APP_SUBMITTED*100/LEAD_QUALIFIED AS SUBMISSION_RATE
    from CDM.OPERATIONS.MY_PIPEDRIVE_DEAL_CONVERSION_T a
    --where a.pipedrive_deal_pipeline_name='MY - Micro Pipeline'
    --and a.PIPEDRIVE_DEAL_STATUS!='open'
    WHERE a.pipedrive_deal_type='New to FS'
    group by REFERENCE_DATE, bacman_l1_channel_name
    order by REFERENCE_DATE desc;
