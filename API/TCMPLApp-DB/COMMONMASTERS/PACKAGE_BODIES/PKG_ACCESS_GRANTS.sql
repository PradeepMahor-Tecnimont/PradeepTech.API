--------------------------------------------------------
--  DDL for Package Body PKG_ACCESS_GRANTS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "COMMONMASTERS"."PKG_ACCESS_GRANTS" As

    Procedure proc_populate_system_grants(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        
        param_msg_type Out Varchar2,
        param_msgtext  Out Varchar2
    ) As
    Begin

        -- ApplNo # 001 : Stationery
         begin
         stationery.pkg_systemgrants.sp_stationery_systemgrants(
            param_msg_type => param_msg_type,
            param_msgtext  => param_msgtext
        );
         Exception
            When Others Then
                Null;
        End;

        -- ApplNo # 002 : Meeting Room Booking
         begin
         TPL_UTILITIES.PKG_SYSTEMGRANTS.sp_meeting_room(
            param_msg_type => param_msg_type,
            param_msgtext  => param_msgtext
        );
         Exception
            When Others Then
                Null;
        End;

        -- ApplNo # 003 : Remote work management
        begin
        rwm2.rw2_systemgrants.sp_rw2_systemgrants(
            param_msg_type => param_msg_type,
            param_msgtext  => param_msgtext
        );
         Exception
            When Others Then
                Null;
        End;

        -- ApplNo # 004 : Insurance Portal
        begin
        insurance.pkg_systemgrants.sp_insurance(
            param_msg_type => param_msg_type,
            param_msgtext  => param_msgtext
        );
         Exception
            When Others Then
                Null;
        End;

        -- ApplNo # 005 :  OSD
        begin
        osd.pkg_systemgrants.sp_osd(
            param_msg_type => param_msg_type,
            param_msgtext  => param_msgtext
        );
         Exception
            When Others Then
                Null;
        End;

        -- ApplNo # 006 : SQSI

        Begin
        SITE_QUERY.PKG_SYSTEMGRANTS.sp_sqsi(
            param_msg_type => param_msg_type,
            param_msgtext  => param_msgtext
        );
         Exception
            When Others Then
                Null;
        End;

        -- ApplNo # 007 : User Requests  Not In Scope

        -- ApplNo # 008 : Desk Management System
        begin
        dms.pkg_systemgrants.sp_deskmanagement_systemgrants(
            param_msg_type => param_msg_type,
            param_msgtext  => param_msgtext
        );
        Exception
            When Others Then
                Null;
        End;

        -- ApplNo # 009 : Travel Management System
        begin
        travel.pkg_systemgrants.sp_travel_systemgrants(
            param_msg_type => param_msg_type,
            param_msgtext  => param_msgtext
        );
        Exception
            When Others Then
                Null;
        End;

        -- ApplNo # 010 : eTraining System
        begin
        trainingnew.pkg_systemgrants.sp_etraining_systemgrants(
            param_msg_type => param_msg_type,
            param_msgtext  => param_msgtext
        );
        Exception
            When Others Then
                Null;
        End;

        -- ApplNo # 011 : eRecruitment System
        /*begin
        recruit.pkg_systemgrants.sp_erecruitment_systemgrants(
            param_msg_type => param_msg_type,
            param_msgtext  => param_msgtext
        );
        Exception
            When Others Then
                Null;
        End;*/

        -- ApplNo # 012 : Timesheet System
        Begin
            timecurr.pkg_sgrants.sp_ts_sg(
                param_msg_type => param_msg_type,
                param_msgtext  => param_msgtext
            );
        Exception
            When Others Then
                Null;
        End;

       -- ApplNo # 013   :Timesheet Historical  Not In Scope

        -- ApplNo # 014 : Jobform
        Begin
            timecurr.pkg_sgrants.sp_jobform_sg(
                param_msg_type => param_msg_type,
                param_msgtext  => param_msgtext
            );
        Exception
            When Others Then
                Null;
        End;

        --ApplNo # 015 : Job Form Historical   Not In Scope

       --ApplNo # 016 :   Job Form Historical - E&I   Not In Scope

        -- ApplNo # 017 : Shift LOP Not In Scope
       /*
        Begin
            hr_appl.pkg_systemgrants.sp_hr_appl_systemgrants(
                param_msg_type => param_msg_type,
                param_msgtext  => param_msgtext
            );
        Exception
            When Others Then
                Null;
        End;
    */
        -- ApplNo # 018 :  RAP Reporting
        Begin
            timecurr.pkg_sgrants.sp_rap_sg(
                param_msg_type => param_msg_type,
                param_msgtext  => param_msgtext
            );
        Exception
            When Others Then
                Null;
        End;




        -- ApplNo # 019 : Health Checkup System - Not In Scope
      /*
        begin
        selfservice.pkg_systemgrants.sp_health_systemgrants(
            param_msg_type => param_msg_type,
            param_msgtext  => param_msgtext
        );
        Exception
            When Others Then
                Null;
        End;
   */
        -- ApplNo # 020 :  Archive - Not In Scope

        -- ApplNo # 021 : Selfservice
         Begin
            SELFSERVICE.PKG_SYSTEMGRANTS.sp_system_grants_selfservice;
        Exception
            When Others Then
                Null;
        End;

        -- ApplNo # 022 : CV
        Begin
            timecurr.pkg_systemgrants.sp_systemgrants_cv;   -- PARAM_MSG_TYPE => PARAM_MSG_TYPE, PARAM_MSGTEXT => PARAM_MSGTEXT );
        Exception
            When Others Then
                Null;
        End;

        -- ApplNo # 023 : Emp Gen Info
        Begin
            pkg_system_grants.system_grants_emp_details;   -- PARAM_MSG_TYPE => PARAM_MSG_TYPE, PARAM_MSGTEXT => PARAM_MSGTEXT );
        Exception
            When Others Then
                Null;
        End;

        -- ApplNo # 024 : AMS
        Begin
            ams.pkg_systemgrants.sp_system_grants_ams;
        Exception
            When Others Then
                Null;
        End;

        -- ApplNo # 025 : Rework Log Book V4
        Begin
            logbook1.pkg_systemgrants.sp_system_grants_rscl;
        Exception
            When Others Then
                Null;
        End;
        -- ApplNo # 026 : Employee OffBoarding
        Begin
            tcmpl_hr.pkg_systemgrants.sp_system_grants_ofb;
        Exception
            When Others Then
                Null;
        End;
    -- update personid from emplmast where personid is null
    End proc_populate_system_grants;

End pkg_access_grants;

/
