Create Or Replace Package Body timecurr.iot_jobs_legacy_normalize As
    Procedure update_job_mode_status
    As
    Begin

        Update
            jobmaster
        Set
            job_mode_status = 'CC'
        Where
            actual_closing_date Is Not Null;

        Update
            jobmaster
        Set
            job_mode_status = 'O1'
        Where
            job_mode_status Is Null
            And approved_amfi = 1;

        Update
            jobmaster
        Set
            job_mode_status = 'M2'
        Where
            nvl(approved_vpdir, 0)        = 0

            And (nvl(approved_dirop, 0)   = 0

                And nvl(approved_amfi, 0) = 0);

        Update
            jobmaster
        Set
            job_mode_status = 'M2'
        Where
            nvl(approved_vpdir, 0)       = 1

            And (nvl(approved_dirop, 0)  = 0

                Or nvl(approved_amfi, 0) = 0);
    End update_job_mode_status;

    Procedure normalize_mail_list As
    Begin
        iot_jobs_mail_list.sp_normalize_legacy;
    End normalize_mail_list;
End;
