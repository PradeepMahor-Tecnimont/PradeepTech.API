--------------------------------------------------------
--  File created - Tuesday-March-29-2022   
--------------------------------------------------------
---------------------------
--New PACKAGE
--RAP_EXPCTJOBS_QRY
---------------------------
CREATE OR REPLACE PACKAGE "TIMECURR"."RAP_EXPCTJOBS_QRY" as

   function fn_expected_Jobs(
      p_person_id   varchar2,
      p_meta_id     varchar2,

      p_row_number  number,
      p_page_length number

   ) return sys_refcursor;

   procedure sp_expectedjobs_details(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_PROJNO       varchar2,

      P_NAME         out varchar2,
      P_ACTIVE       out varchar2,
      P_BU           out varchar2,
      P_ACTIVEFUTURE out varchar2,
      P_FINAL_PROJNO out varchar2,
      P_NEWCOSTCODE  out varchar2,
      P_TCMNO        out varchar2,
      P_LCK          out varchar2,
      P_PROJ_TYPE    out varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   );

end RAP_EXPCTJOBS_QRY;
/
---------------------------
--Changed PACKAGE
--RAP_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE "TIMECURR"."RAP_SELECT_LIST_QRY" As
    Function fn_year_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_yearmode_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_yearmonth_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_yyyy varchar2,
        p_yearmode varchar2
    ) Return Sys_Refcursor;

    Function fn_costcode_list_proco (
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_costcode_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_projno_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_empno_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_simulation_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_expt_projno_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

  Function fn_job_tmagroup_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;


End rap_select_list_qry;
/
---------------------------
--New PACKAGE
--RAP_EXPCTJOBS
---------------------------
CREATE OR REPLACE PACKAGE "TIMECURR"."RAP_EXPCTJOBS" as

   procedure sp_add_expectedjobs(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_PROJNO           varchar2,
      P_NAME             varchar2,
      P_ACTIVE           number ,
      P_BU               varchar2 default null,
      P_ACTIVEFUTURE     number ,
      P_FINAL_PROJNO     varchar2 default null,
      P_NEWCOSTCODE      varchar2 default null,
      P_TCMNO            varchar2 default null,
      P_LCK              number default null,
      P_PROJ_TYPE        varchar2 default null,

      p_message_type out varchar2,
      p_message_text out varchar2
   );

   procedure sp_update_expectedjobs(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_PROJNO           varchar2,
      P_NAME             varchar2,
      P_ACTIVE           number ,
      P_BU               varchar2 default null,
      P_ACTIVEFUTURE     number ,
      P_FINAL_PROJNO     varchar2 default null,
      P_NEWCOSTCODE      varchar2 default null,
      P_TCMNO            varchar2 default null,
      P_LCK              number default null,
      P_PROJ_TYPE        varchar2 default null,

      p_message_type out varchar2,
      p_message_text out varchar2
   );

   procedure sp_delete_expectedjobs(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_PROJNO           varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   );

   --Move Projection By Months
   procedure sp_mv_by_months(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Projno           varchar2,
      P_Number_Of_Months number,

      p_message_type out varchar2,
      p_message_text out varchar2
   );

   --Move To Final (Real) Project
   procedure sp_mv_to_final_real(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Projno           varchar2,
      P_Real_Projno      varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   );

   --Move To Final (Expected) Project
   procedure sp_mv_to_final_expected(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Projno           varchar2,
      P_expected_Projno  varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   );

   --Move To Final (Real) NewProject and CostCode
   procedure sp_mv_to_final_Real_PC(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Projno           varchar2,
      P_New_Projno       varchar2,
      P_Costcode         varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   );

end RAP_EXPCTJOBS;
/
---------------------------
--Changed PACKAGE BODY
--RAP_REPORTS_GEN
---------------------------
CREATE OR REPLACE PACKAGE BODY "TIMECURR"."RAP_REPORTS_GEN" As

    Function get_empcount(p_costcode In Varchar2) Return Number As
        v_empcount Number;
    Begin
        Select
            Case Sum(nvl(changed_nemps, 0))
                When 0 Then
                    Sum(nvl(noofemps, 0))
                Else
                    Sum(nvl(changed_nemps, 0))
            End
        Into
            v_empcount
        From
            costmast
        Where
            costcode = p_costcode;
        Return v_empcount;
    End get_empcount;

    Function get_lastmonth(p_yymm  In Varchar2,
                           p_mnths In Number) Return Varchar2 As
        v_lastmonth Varchar2(6);
    Begin
        Select
            to_char(add_months(to_date(p_yymm, 'yyyymm'), p_mnths), 'yyyymm')
        Into
            v_lastmonth
        From
            dual;
        Return v_lastmonth;
    End get_lastmonth;

    --Get Begin Year Month : YYMM Jan / YYMM Apr    
    Function get_yymm_begin(
        p_yymm     In Varchar2,
        p_yearmode In Varchar2
    ) Return Varchar2 Is
    Begin
        If p_yearmode = 'J' Then
            Return substr(trim(p_yymm), 1, 4) || '01';
        Elsif p_yearmode = 'A' Then
            If to_number(substr(trim(p_yymm), 5, 2)) > 3 Then
                Return substr(trim(p_yymm), 1, 4) || '04';
            Else
                Return to_char(to_number(substr(trim(p_yymm), 1, 4)) - 1) || '04';
            End If;
        End If;
    End get_yymm_begin;

    --Get end Year Month : YYMM Dec / YYMM Mar    
    Function get_yymm_end(
        p_yymm     In Varchar2,
        p_yearmode In Varchar2
    ) Return Varchar2 Is
    Begin
        If p_yearmode = 'J' Then
            Return substr(trim(p_yymm), 1, 4) || '12';
        Elsif p_yearmode = 'A' Then
            If to_number(substr(trim(p_yymm), 5, 2)) > 3 Then
                Return to_char(to_number(substr(trim(p_yymm), 1, 4)) + 1) || '03';

            Else
                Return substr(trim(p_yymm), 1, 4) || '03';
            End If;
        End If;
    End get_yymm_end; 

    --Get Year Month  YYYYMM  
    Function get_yymm(
        p_yymm       In Varchar2,
        p_noofmonths In Varchar2
    ) Return Varchar2 Is
    Begin
        Return to_char(add_months(to_date(trim(p_yymm), 'yyyymm'), p_noofmonths), 'yyyymm');
    End;    

    --Get description of New Costcode
    Function get_costcode_desc(
        p_costcode In Varchar2
    ) Return Varchar2 Is
        v_name costmast.name%Type;
    Begin
        Select
            name
        Into
            v_name
        From
            costmast
        Where
            costcode = Trim(p_costcode);

        Return v_name;
    Exception
        When Others Then
            Return Null;
    End;    

    --Get Job Type as per TMA Group
    Function get_job_type_tma_grp(
        p_tma_group In Varchar2
    ) Return Varchar2 Is
        vjob_classdesc job_classi.job_classdesc%Type;
    Begin
        Select
            job_classdesc
        Into
            vjob_classdesc
        From
            job_classi
        Where
            job_class = Trim(p_tma_group);

        Return vjob_classdesc;

    Exception
        When Others Then
            Return 'Other than Active, Dead and Closed Jobs';
    End;

    --Get TMA Sub Group
    Function get_tma_sub_grp(
        p_newcostcode In Varchar2
    ) Return Varchar2 Is
        vsubgrpdesc job_tmasubgrp.subgrpdesc%Type;
    Begin
        Select
            subgrpdesc
        Into
            vsubgrpdesc
        From
            job_tmasubgrp
        Where
            tmasubgrp = Trim(p_newcostcode);

        Return vsubgrpdesc;

    Exception
        When Others Then
            Return Null;
    End;

    --Original budget    
    Function get_original_budget(
        p_projno   In Varchar2,
        p_costcode In Varchar2 Default Null,
        p_costgrp  In Varchar2 Default Null
    ) Return Number Is
        n_original_budget budgmast.original%Type;
    Begin
        If length(trim(p_projno)) = 5 Then
            If p_costgrp = 'M' Or p_costgrp = 'N' Then
      --Non Engineering / Non Depute 
                Select
                    Sum(nvl(b.original, 0))
                Into
                    n_original_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode                 = c.costcode
                    And c.tma_grp !=
                    Case
                        When p_costgrp = 'M' Then
                            'E'
                        When p_costgrp = 'N' Then
                            'D'
                    End
                    And substr(b.projno, 1, 5) = Trim(p_projno);

            Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then
     --Engineering / Depute
                Select
                    Sum(nvl(b.original, 0))
                Into
                    n_original_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode                 = c.costcode
                    And c.tma_grp              = Trim(p_costgrp)
                    And substr(b.projno, 1, 5) = Trim(p_projno);

            Elsif p_costgrp = 'O' Then
     --Non Depute Minus E
                Select
                    Sum(nvl(b.original, 0))
                Into
                    n_original_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode                 = c.costcode
                    And c.tma_grp != 'D'
                    And c.tma_grp != 'E'
                    And substr(b.projno, 1, 5) = Trim(p_projno);

            Elsif p_costcode Is Not Null Then
                Select
                    Sum(nvl(original, 0))
                Into
                    n_original_budget
                From
                    rap_gtt_budgmast
                Where
                    costcode                 = Trim(p_costcode)
                    And substr(projno, 1, 5) = Trim(p_projno);

            Else
                Select
                    Sum(nvl(original, 0))
                Into
                    n_original_budget
                From
                    rap_gtt_budgmast
                Where
                    substr(projno, 1, 5) = Trim(p_projno);

            End If;
        Else
            If p_costgrp = 'M' Or p_costgrp = 'N' Then
      --Non Engineering / --Non Depute 
                Select
                    Sum(nvl(b.original, 0))
                Into
                    n_original_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode   = c.costcode
                    And c.tma_grp !=
                    Case
                        When p_costgrp = 'M' Then
                            'E'
                        When p_costgrp = 'N' Then
                            'D'
                    End
                    And b.projno = Trim(p_projno);

            Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then
     --Engineering / Depute
                Select
                    Sum(nvl(b.original, 0))
                Into
                    n_original_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode    = c.costcode
                    And c.tma_grp = Trim(p_costgrp)
                    And b.projno  = Trim(p_projno);

            Elsif p_costgrp = 'O' Then
     --Non Depute Minus E
                Select
                    Sum(nvl(b.original, 0))
                Into
                    n_original_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode   = c.costcode
                    And c.tma_grp != 'D'
                    And c.tma_grp != 'E'
                    And b.projno = Trim(p_projno);

            Elsif p_costcode Is Not Null Then
                Select
                    Sum(nvl(original, 0))
                Into
                    n_original_budget
                From
                    rap_gtt_budgmast
                Where
                    costcode   = Trim(p_costcode)
                    And projno = Trim(p_projno);

            Else
                Select
                    Sum(nvl(original, 0))
                Into
                    n_original_budget
                From
                    rap_gtt_budgmast
                Where
                    projno = Trim(p_projno);

            End If;
        End If;

        Return n_original_budget;
    Exception
        When Others Then
            Return 0;
    End get_original_budget;   

    -- Revised budget
    Function get_revised_budget(
        p_projno   In Varchar2,
        p_costcode In Varchar2 Default Null,
        p_costgrp  In Varchar2 Default Null
    ) Return Number Is
        n_revised_budget budgmast.revised%Type;
    Begin
        If length(trim(p_projno)) = 5 Then
            If p_costgrp = 'M' Or p_costgrp = 'N' Then
      --Non Engineering / Non Depute 
                Select
                    Sum(nvl(b.revised, 0))
                Into
                    n_revised_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode                 = c.costcode
                    And c.tma_grp !=
                    Case
                        When p_costgrp = 'M' Then
                            'E'
                        When p_costgrp = 'N' Then
                            'D'
                    End
                    And substr(b.projno, 1, 5) = Trim(p_projno);

            Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then
     --Engineering / Depute
                Select
                    Sum(nvl(b.revised, 0))
                Into
                    n_revised_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode                 = c.costcode
                    And c.tma_grp              = Trim(p_costgrp)
                    And substr(b.projno, 1, 5) = Trim(p_projno);

            Elsif p_costgrp = 'O' Then
     --Non Depute Minus E
                Select
                    Sum(nvl(b.revised, 0))
                Into
                    n_revised_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode                 = c.costcode
                    And c.tma_grp != 'D'
                    And c.tma_grp != 'E'
                    And substr(b.projno, 1, 5) = Trim(p_projno);

            Elsif p_costgrp Is Not Null Then
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
                Select
                    Sum(nvl(b.revised, 0))
                Into
                    n_revised_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode                 = c.costcode
                    And c.tma_grp              = substr(Trim(p_costgrp), 5, 1)
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
                    And substr(b.projno, 1, 5) = Trim(p_projno);

            Elsif p_costcode Is Not Null Then
                Select
                    Sum(nvl(b.revised, 0))
                Into
                    n_revised_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode                 = c.costcode
                    And substr(b.projno, 1, 5) = Trim(p_projno);

            Else
                Select
                    Sum(nvl(revised, 0))
                Into
                    n_revised_budget
                From
                    rap_gtt_budgmast
                Where
                    substr(projno, 1, 5) = Trim(p_projno);

            End If;
        Else
            If p_costgrp = 'M' Or p_costgrp = 'N' Then
      --Non Engineering / Non Depute 
                Select
                    Sum(nvl(b.revised, 0))
                Into
                    n_revised_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode   = c.costcode
                    And c.tma_grp !=
                    Case
                        When p_costgrp = 'M' Then
                            'E'
                        When p_costgrp = 'N' Then
                            'D'
                    End
                    And b.projno = Trim(p_projno);

            Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then
     --Engineering / Depute
                Select
                    Sum(nvl(b.revised, 0))
                Into
                    n_revised_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode    = c.costcode
                    And c.tma_grp = Trim(p_costgrp)
                    And b.projno  = Trim(p_projno);

            Elsif p_costgrp = 'O' Then
     --Non Depute Minus E
                Select
                    Sum(nvl(b.revised, 0))
                Into
                    n_revised_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode   = c.costcode
                    And c.tma_grp != 'D'
                    And c.tma_grp != 'E'
                    And b.projno = Trim(p_projno);

            Elsif p_costgrp Is Not Null Then
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
                Select
                    Sum(nvl(b.revised, 0))
                Into
                    n_revised_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode    = c.costcode
                    And c.tma_grp = substr(Trim(p_costgrp), 5, 1)
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
                    And b.projno  = Trim(p_projno);

            Elsif p_costcode Is Not Null Then
                Select
                    Sum(nvl(b.revised, 0))
                Into
                    n_revised_budget
                From
                    rap_gtt_budgmast b,
                    costmast         c
                Where
                    b.costcode   = c.costcode
                    And b.projno = Trim(p_projno);

            Else
                Select
                    Sum(nvl(revised, 0))
                Into
                    n_revised_budget
                From
                    rap_gtt_budgmast
                Where
                    projno = Trim(p_projno);

            End If;
        End If;

        Return n_revised_budget;
    Exception
        When Others Then
            Return 0;
    End get_revised_budget;        

    --Current Month Actual hours    
    Function get_actual_month_hours(
        p_yymm     In Varchar2,
        p_projno   In Varchar2,
        p_costcode In Varchar2 Default Null,
        p_costgrp  In Varchar2 Default Null
    ) Return Number Is
        n_month_hours timetran.hours%Type;
    Begin
        If length(trim(p_projno)) = 5 Then
            If p_costgrp = 'M' Or p_costgrp = 'N' Then
     --Non Engineering / Non Depute
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_month_hours
                From
                    rap_gtt_timetran
                Where
                    grp !=
                    Case
                        When p_costgrp = 'M' Then
                            'E'
                        When p_costgrp = 'N' Then
                            'D'
                    End
                    And yymm                 = Trim(p_yymm)
                    And substr(projno, 1, 5) = Trim(p_projno);

            Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then
     --Engineering / Depute
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_month_hours
                From
                    rap_gtt_timetran
                Where
                    grp                      = Trim(p_costgrp)
                    And yymm                 = Trim(p_yymm)
                    And substr(projno, 1, 5) = Trim(p_projno);

            Elsif p_costgrp = 'O' Then
     --Non Depute Minus E
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_month_hours
                From
                    rap_gtt_timetran
                Where
                    grp != 'D'
                    And grp != 'E'
                    And yymm                 = Trim(p_yymm)
                    And substr(projno, 1, 5) = Trim(p_projno);

            Elsif p_costgrp Is Not Null Then
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
                Select
                    Sum(nvl(t.hours, 0) + nvl(t.othours, 0))
                Into
                    n_month_hours
                From
                    rap_gtt_timetran             t, costmast c
                Where
                    t.costcode                 = c.costcode
                    And c.tma_grp              = substr(Trim(p_costgrp), 5, 1)
       --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z                      
                    And t.yymm                 = Trim(p_yymm)
                    And substr(t.projno, 1, 5) = Trim(p_projno);

            Elsif p_costcode Is Not Null Then
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_month_hours
                From
                    rap_gtt_timetran
                Where
                    costcode                 = Trim(p_costcode)
                    And yymm                 = Trim(p_yymm)
                    And substr(projno, 1, 5) = Trim(p_projno);

            Else
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_month_hours
                From
                    rap_gtt_timetran
                Where
                    yymm                     = Trim(p_yymm)
                    And substr(projno, 1, 5) = Trim(p_projno);

            End If;
        Else
            If p_costgrp = 'M' Or p_costgrp = 'N' Then
     --Non Engineering / --Non Depute
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_month_hours
                From
                    rap_gtt_timetran
                Where
                    grp !=
                    Case
                        When p_costgrp = 'M' Then
                            'E'
                        When p_costgrp = 'N' Then
                            'D'
                    End
                    And yymm   = Trim(p_yymm)
                    And projno = Trim(p_projno);

            Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then
     --Engineering / Depute
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_month_hours
                From
                    rap_gtt_timetran
                Where
                    grp        = Trim(p_costgrp)
                    And yymm   = Trim(p_yymm)
                    And projno = Trim(p_projno);

            Elsif p_costgrp = 'O' Then
     --Non Depute Minus E
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_month_hours
                From
                    rap_gtt_timetran
                Where
                    grp != 'D'
                    And grp != 'E'
                    And yymm   = Trim(p_yymm)
                    And projno = Trim(p_projno);

            Elsif p_costgrp Is Not Null Then
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
                Select
                    Sum(nvl(t.hours, 0) + nvl(t.othours, 0))
                Into
                    n_month_hours
                From
                    rap_gtt_timetran             t, costmast c
                Where
                    t.costcode    = c.costcode
                    And c.tma_grp = substr(Trim(p_costgrp), 5, 1)
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z                       
                    And t.yymm    = Trim(p_yymm)
                    And t.projno  = Trim(p_projno);

            Elsif p_costcode Is Not Null Then
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_month_hours
                From
                    rap_gtt_timetran
                Where
                    costcode   = Trim(p_costcode)
                    And yymm   = Trim(p_yymm)
                    And projno = Trim(p_projno);

            Else
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_month_hours
                From
                    rap_gtt_timetran
                Where
                    yymm       = Trim(p_yymm)
                    And projno = Trim(p_projno);

            End If;
        End If;

        Return n_month_hours;
    Exception
        When Others Then
            Return 0;
    End get_actual_month_hours;

    --Current Month Actual hours before posting
    Function get_actual_month_hours_b_post(
        p_yymm     In Varchar2,
        p_projno   In Varchar2,
        p_costcode In Varchar2
    ) Return Number Is
        n_month_hours jobwise.nhrs%Type;
    Begin
        Select
            Sum(nvl(nhrs, 0) + nvl(ohrs, 0))
        Into
            n_month_hours
        From
            jobwise
        Where
            assign     = Trim(p_costcode)
            And yymm   = Trim(p_yymm)
            And projno = Trim(p_projno);

        Return n_month_hours;
    Exception
        When Others Then
            Return 0;
    End;

    --Current Year Actual hours    
    Function get_actual_year_hours(
        p_yymm     In Varchar2,
        p_yearmode In Varchar2,
        p_projno   In Varchar2,
        p_costcode In Varchar2 Default Null,
        p_costgrp  In Varchar2 Default Null
    ) Return Number Is
        n_year_hours timetran.hours%Type;
    Begin
        If length(trim(p_projno)) = 5 Then
            If p_costgrp = 'M' Or p_costgrp = 'N' Then
     --Non Engineering / Non Depute
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_year_hours
                From
                    rap_gtt_timetran
                Where
                    grp !=
                    Case
                        When p_costgrp = 'M' Then
                            'E'
                        When p_costgrp = 'N' Then
                            'D'
                    End
                    And to_number(yymm) >= to_number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode))
                    And to_number(yymm) <= to_number(Trim(p_yymm))
                    And substr(projno, 1, 5) = Trim(p_projno);

            Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then
     --Engineering / Depute
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_year_hours
                From
                    rap_gtt_timetran
                Where
                    grp                      = Trim(p_costgrp)
                    And to_number(yymm) >= to_number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode))
                    And to_number(yymm) <= to_number(Trim(p_yymm))
                    And substr(projno, 1, 5) = Trim(p_projno);

            Elsif p_costgrp = 'O' Then
     --Non Depute Minus E
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_year_hours
                From
                    rap_gtt_timetran
                Where
                    grp != 'D'
                    And grp != 'E'
                    And to_number(yymm) >= to_number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode))
                    And to_number(yymm) <= to_number(Trim(p_yymm))
                    And substr(projno, 1, 5) = Trim(p_projno);

            Elsif p_costgrp Is Not Null Then
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
                Select
                    Sum(nvl(t.hours, 0) + nvl(t.othours, 0))
                Into
                    n_year_hours
                From
                    rap_gtt_timetran             t, costmast c
                Where
                    t.costcode                 = c.costcode
                    And c.tma_grp              = substr(Trim(p_costgrp), 5, 1)
       --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z                  
                    And to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode))
                    And to_number(t.yymm) <= to_number(Trim(p_yymm))
                    And substr(t.projno, 1, 5) = Trim(p_projno);

            Elsif p_costcode Is Not Null Then
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_year_hours
                From
                    rap_gtt_timetran
                Where
                    costcode                 = Trim(p_costcode)
                    And to_number(yymm) >= to_number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode))
                    And to_number(yymm) <= to_number(Trim(p_yymm))
                    And substr(projno, 1, 5) = Trim(p_projno);

            Else
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_year_hours
                From
                    rap_gtt_timetran
                Where
                    to_number(yymm) >= to_number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode))
                    And to_number(yymm) <= to_number(Trim(p_yymm))
                    And substr(projno, 1, 5) = Trim(p_projno);

            End If;
        Else
            If p_costgrp = 'M' Or p_costgrp = 'N' Then
     --Non Engineering / Non Depute
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_year_hours
                From
                    rap_gtt_timetran
                Where
                    grp !=
                    Case
                        When p_costgrp = 'M' Then
                            'E'
                        When p_costgrp = 'N' Then
                            'D'
                    End
                    And to_number(yymm) >= to_number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode))
                    And to_number(yymm) <= to_number(Trim(p_yymm))
                    And projno = Trim(p_projno);

            Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then
     --Engineering / Depute
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_year_hours
                From
                    rap_gtt_timetran
                Where
                    grp        = Trim(p_costgrp)
                    And to_number(yymm) >= to_number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode))
                    And to_number(yymm) <= to_number(Trim(p_yymm))
                    And projno = Trim(p_projno);

            Elsif p_costgrp = 'O' Then
     --Non Depute Minus E
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_year_hours
                From
                    rap_gtt_timetran
                Where
                    grp != 'D'
                    And grp != 'E'
                    And to_number(yymm) >= to_number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode))
                    And to_number(yymm) <= to_number(Trim(p_yymm))
                    And projno = Trim(p_projno);

            Elsif p_costgrp Is Not Null Then
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
                Select
                    Sum(nvl(t.hours, 0) + nvl(t.othours, 0))
                Into
                    n_year_hours
                From
                    rap_gtt_timetran             t, costmast c
                Where
                    t.costcode    = c.costcode
                    And c.tma_grp = substr(Trim(p_costgrp), 5, 1)
       --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z                
                    And to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode))
                    And to_number(t.yymm) <= to_number(Trim(p_yymm))
                    And t.projno  = Trim(p_projno);

            Elsif p_costcode Is Not Null Then
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_year_hours
                From
                    rap_gtt_timetran
                Where
                    costcode   = Trim(p_costcode)
                    And to_number(yymm) >= to_number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode))
                    And to_number(yymm) <= to_number(Trim(p_yymm))
                    And projno = Trim(p_projno);

            Else
                Select
                    Sum(nvl(hours, 0) + nvl(othours, 0))
                Into
                    n_year_hours
                From
                    rap_gtt_timetran
                Where
                    to_number(yymm) >= to_number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode))
                    And to_number(yymm) <= to_number(Trim(p_yymm))
                    And projno = Trim(p_projno);

            End If;
        End If;

        Return n_year_hours;
    Exception
        When Others Then
            Return 0;
    End get_actual_year_hours;     

    --Current Year Actual hours before posting
    Function get_actual_year_hours_b_post(
        p_yymm     In Varchar2,
        p_yearmode In Varchar2,
        p_projno   In Varchar2,
        p_costcode In Varchar2
    ) Return Number Is
        n_year_hours jobwise.nhrs%Type;
    Begin
        Select
            Sum(nvl(hours, 0) + nvl(othours, 0))
        Into
            n_year_hours
        From
            timetran
        Where
            costcode                 = Trim(p_costcode)
            And to_number(yymm) >= to_number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode))
            And to_number(yymm) <= to_number(Trim(p_yymm))
            And substr(projno, 1, 5) = Trim(p_projno);

        Return n_year_hours;
    Exception
        When Others Then
            Return 0;
    End;

    --Opening hours
    Function get_opening_hours(
        p_yearmode In Varchar2,
        p_projno   In Varchar2,
        p_costcode In Varchar2 Default Null,
        p_costgrp  In Varchar2 Default Null
    ) Return Number Is
        n_open01 openmast.open01%Type;
        n_open04 openmast.open04%Type;
    Begin
        If length(trim(p_projno)) = 5 Then
            If p_costgrp = 'M' Or p_costgrp = 'N' Then
      --Non Engineering / Non Depute 
                Select
                    Sum(nvl(open01, 0)),
                    Sum(nvl(open04, 0))
                Into
                    n_open01,
                    n_open04
                From
                    rap_gtt_openmast o,
                    costmast         c
                Where
                    o.costcode                 = c.costcode
                    And c.tma_grp !=
                    Case
                        When p_costgrp = 'M' Then
                            'E'
                        When p_costgrp = 'N' Then
                            'D'
                    End
                    And substr(o.projno, 1, 5) = Trim(p_projno);

            Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then
     --Engineering / Depute
                Select
                    Sum(nvl(open01, 0)),
                    Sum(nvl(open04, 0))
                Into
                    n_open01,
                    n_open04
                From
                    rap_gtt_openmast o,
                    costmast         c
                Where
                    o.costcode                 = c.costcode
                    And c.tma_grp              = Trim(p_costgrp)
                    And substr(o.projno, 1, 5) = Trim(p_projno);

            Elsif p_costgrp = 'O' Then
     --Non Depute Minus E
                Select
                    Sum(nvl(open01, 0)),
                    Sum(nvl(open04, 0))
                Into
                    n_open01,
                    n_open04
                From
                    rap_gtt_openmast o,
                    costmast         c
                Where
                    o.costcode                 = c.costcode
                    And c.tma_grp != 'D'
                    And c.tma_grp != 'E'
                    And substr(o.projno, 1, 5) = Trim(p_projno);

            Elsif p_costgrp Is Not Null Then
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
                Select
                    Sum(nvl(open01, 0)),
                    Sum(nvl(open04, 0))
                Into
                    n_open01,
                    n_open04
                From
                    rap_gtt_openmast o,
                    costmast         c
                Where
                    o.costcode                 = c.costcode
                    And c.tma_grp              = substr(Trim(p_costgrp), 5, 1)
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
                    And substr(o.projno, 1, 5) = Trim(p_projno);

            Elsif p_costcode Is Not Null Then
                Select
                    open01,
                    open04
                Into
                    n_open01,
                    n_open04
                From
                    rap_gtt_openmast
                Where
                    costcode                 = Trim(p_costcode)
                    And substr(projno, 1, 5) = Trim(p_projno);

            Else
                Select
                    Sum(nvl(open01, 0)),
                    Sum(nvl(open04, 0))
                Into
                    n_open01,
                    n_open04
                From
                    rap_gtt_openmast
                Where
                    substr(projno, 1, 5) = Trim(p_projno);

            End If;
        Else
            If p_costgrp = 'M' Or p_costgrp = 'N' Then
      --Non Engineering / Non Depute 
                Select
                    Sum(nvl(open01, 0)),
                    Sum(nvl(open04, 0))
                Into
                    n_open01,
                    n_open04
                From
                    rap_gtt_openmast o,
                    costmast         c
                Where
                    o.costcode   = c.costcode
                    And c.tma_grp !=
                    Case
                        When p_costgrp = 'M' Then
                            'E'
                        When p_costgrp = 'N' Then
                            'D'
                    End
                    And o.projno = Trim(p_projno);

            Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then
     --Engineering / Depute
                Select
                    Sum(nvl(open01, 0)),
                    Sum(nvl(open04, 0))
                Into
                    n_open01,
                    n_open04
                From
                    rap_gtt_openmast o,
                    costmast         c
                Where
                    o.costcode    = c.costcode
                    And c.tma_grp = Trim(p_costgrp)
                    And o.projno  = Trim(p_projno);

            Elsif p_costgrp = 'O' Then
     --Non Depute Minus E
                Select
                    Sum(nvl(open01, 0)),
                    Sum(nvl(open04, 0))
                Into
                    n_open01,
                    n_open04
                From
                    rap_gtt_openmast o,
                    costmast         c
                Where
                    o.costcode   = c.costcode
                    And c.tma_grp != 'D'
                    And c.tma_grp != 'E'
                    And o.projno = Trim(p_projno);

            Elsif p_costgrp Is Not Null Then
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
                Select
                    Sum(nvl(open01, 0)),
                    Sum(nvl(open04, 0))
                Into
                    n_open01,
                    n_open04
                From
                    rap_gtt_openmast o,
                    costmast         c
                Where
                    o.costcode    = c.costcode
                    And c.tma_grp = substr(Trim(p_costgrp), 5, 1)
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
                    And o.projno  = Trim(p_projno);

            Elsif p_costcode Is Not Null Then
                Select
                    open01,
                    open04
                Into
                    n_open01,
                    n_open04
                From
                    rap_gtt_openmast
                Where
                    costcode   = Trim(p_costcode)
                    And projno = Trim(p_projno);

            Else
                Select
                    Sum(nvl(open01, 0)),
                    Sum(nvl(open04, 0))
                Into
                    n_open01,
                    n_open04
                From
                    rap_gtt_openmast
                Where
                    projno = Trim(p_projno);

            End If;

        End If;

        If p_yearmode = 'J' Then
            Return n_open01;
        Elsif p_yearmode = 'A' Then
            Return n_open04;
        End If;

    Exception
        When Others Then
            Return 0;
    End get_opening_hours;

    --Future Projected hours   
    Function get_projected_hours_future(
        p_yymm       In Varchar2,
        p_projno     In Varchar2,
        p_costcode   In Varchar2 Default Null,
        p_costgrp    In Varchar2 Default Null,
        p_noofmonths In Varchar2
    ) Return Number Is
        n_proj_hours prjcmast.hours%Type;
    Begin
        If length(trim(p_projno)) = 5 Then
            If p_costgrp Is Not Null Then
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
                Select
                    Sum(nvl(hours, 0))
                Into
                    n_proj_hours
                From
                    rap_gtt_prjcmast p,
                    costmast         c
                Where
                    p.costcode                 = c.costcode
                    And c.tma_grp              = substr(Trim(p_costgrp), 5, 1)
                    And to_number(p.yymm) > to_number(rap_reports_gen.get_yymm(p_yymm, p_noofmonths))
                    And substr(p.projno, 1, 5) = Trim(p_projno);

            Elsif p_costcode Is Not Null Then
                Select
                    Sum(nvl(hours, 0))
                Into
                    n_proj_hours
                From
                    rap_gtt_prjcmast
                Where
                    costcode                 = Trim(p_costcode)
                    And to_number(yymm) > to_number(rap_reports_gen.get_yymm(p_yymm, p_noofmonths))
                    And substr(projno, 1, 5) = Trim(p_projno);

            Else
                Select
                    Sum(nvl(hours, 0))
                Into
                    n_proj_hours
                From
                    rap_gtt_prjcmast
                Where
                    to_number(yymm) > to_number(rap_reports_gen.get_yymm(p_yymm, p_noofmonths))
                    And substr(projno, 1, 5) = Trim(p_projno);

            End If;
        Else
            If p_costgrp Is Not Null Then
     --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
                Select
                    Sum(nvl(hours, 0))
                Into
                    n_proj_hours
                From
                    rap_gtt_prjcmast p,
                    costmast         c
                Where
                    p.costcode    = c.costcode
                    And c.tma_grp = substr(Trim(p_costgrp), 5, 1)
                    And to_number(p.yymm) > to_number(rap_reports_gen.get_yymm(p_yymm, p_noofmonths))
                    And p.projno  = Trim(p_projno);

            Elsif p_costcode Is Not Null Then
                Select
                    Sum(nvl(hours, 0))
                Into
                    n_proj_hours
                From
                    rap_gtt_prjcmast
                Where
                    costcode   = Trim(p_costcode)
                    And to_number(yymm) > to_number(rap_reports_gen.get_yymm(p_yymm, p_noofmonths))
                    And projno = Trim(p_projno);

            Else
                Select
                    Sum(nvl(hours, 0))
                Into
                    n_proj_hours
                From
                    rap_gtt_prjcmast
                Where
                    to_number(yymm) > to_number(rap_reports_gen.get_yymm(p_yymm, p_noofmonths))
                    And projno = Trim(p_projno);

            End If;
        End If;

        Return n_proj_hours;
    Exception
        When Others Then
            Return 0;
    End get_projected_hours_future;

    --Check Project status
    Function get_projno_active_status(
        p_yymm     In Varchar2,
        p_yearmode In Varchar2,
        p_active   In Number,
        p_cdate    In Date
    ) Return Number Is
    Begin
        If nvl(p_active, 0) = 1 Or p_cdate Is Null Then
            Return 1;
        Elsif to_number(to_char(p_cdate, 'YYYYMM')) >= to_number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) Then
            Return 1;
        Else
            Return 0;
        End If;

    End get_projno_active_status;

    --Insert / Update Bulk Report Start / End Process
    Procedure update_rpt_process(
        p_keyid      In  Varchar2,
        p_report     In  Varchar2,
        p_user       In  Varchar2,
        p_yyyy       In  Varchar2,
        p_yymm       In  Varchar2,
        p_yearmode   In  Varchar2,
        p_category   In  Varchar2,
        p_reporttype In  Varchar2,
        p_msg        Out Varchar2
    ) As
        vcount Number := 0;
    Begin
        Select
            Count(*)
        Into
            vcount
        From
            rap_rpt_process
        Where
            keyid      = Trim(p_keyid)
            And userid = Trim(p_user);

        If vcount = 0 Then
            Insert Into rap_rpt_process (
                keyid,
                reportid,
                userid,
                email,
                yyyy,
                yymm,
                yearmode,
                iscomplete,
                sdate,
                category,
                reporttype
            )
            Values (
                p_keyid,
                p_report,
                p_user,
                ngts_users.ngts_getemail(p_user),
                p_yyyy,
                p_yymm,
                p_yearmode,
                0,
                sysdate,
                p_category,
                p_reporttype
            );

        Else
            Update
                rap_rpt_process
            Set
                iscomplete = 1,
                edate = sysdate
            Where
                keyid = Trim(p_keyid);

        End If;

        p_msg := 'Done';
    Exception
        When Others Then
            p_msg := 'Error ';
    End update_rpt_process;

    --GENERATE MAIL DETAILS FOR BULK REPORTS
    Procedure get_mail_details(
        p_keyid  In  Varchar2,
        p_status In  Varchar2,
        p_result Out Sys_Refcursor
    ) As
    Begin
        Open p_result For 'SELECT 
                                email mailTo,
                                NULL mailCC,
                                NULL mailBCC,
                                ''Report : '' || reportid || 
                                            '' - Processing Month : '' || yymm || 
                                            '' - Processing Period : '' || CASE yearmode 
                                                                                WHEN ''J'' THEN ''Jan - Dec''
                                                                                WHEN ''A'' THEN ''Apr - Mar''
                                                                                END mailSubject,
                                rap_reports_gen.create_mail_body(:p_keyid, :p_status) mailBody,
                                ''Text'' mailType,
                                ''TIMESHEET'' mailFrom                          
                            FROM 
                                rap_rpt_process 
                            WHERE 
                                keyid = TRIM(:p_keyid)'
            Using p_keyid, p_status, p_keyid;

    End get_mail_details;  

    --CREATE MAIL BODY     
    Function create_mail_body(
        p_reporturl Varchar2,
        p_status    Varchar2
    ) Return Varchar2 Is
        v_msg_body Varchar2(4000);
    Begin
        v_msg_body := 'Dear Sir/Madam,' || chr(13) || chr(10) || chr(13) || chr(10);
        If p_status = 'SUCCESS' Then
            v_msg_body := v_msg_body || 'Please login into RAP Reporting Application - ' || c_path || ' to download the report.' ||
            chr(13) || chr(10);
            v_msg_body := v_msg_body || 'Kindly download the report as it would be available only for 24 hours.' || chr(13) ||
            chr(10) || chr(13) || chr(10);
        Else
            v_msg_body := v_msg_body || 'Error - ' || p_status || '...Please contact RAP Reporting Application IT Team.' ||
            chr(13) || chr(10) || chr(13) || chr(10);
        End If;
        v_msg_body := v_msg_body || 'Thanks,' || chr(13) || chr(10);
        v_msg_body := v_msg_body || 'RAP Reporting Application' || chr(13) || chr(10) || chr(13) || chr(10) || chr(13) ||
        chr(10);
        v_msg_body := v_msg_body || 'This is an automated TCMPL Mail.';

        Return v_msg_body;
    End create_mail_body;

    --SHOW THE LAST GENERATED REPORT LINK
    Procedure get_rpt_process_list(
        p_report   In  Varchar2,
        p_yyyy     In  Varchar2,
        p_yearmode In  Varchar2,
        p_yymm     In  Varchar2,
        p_user     In  Varchar2,
        p_result   Out Sys_Refcursor
    ) As
    Begin
        Open p_result For 'SELECT 
                                keyid || ''.zip'' filename FROM 
                           (SELECT 
                                keyid
                            FROM 
                                rap_rpt_process 
                            WHERE 
                                    reportid = TRIM(:p_report) 
                                AND yyyy = TRIM(:p_yyyy) 
                                AND yymm = TRIM(:p_yymm)
                                AND yearmode = TRIM(:p_yearmode)
                                AND userid = TRIM(:p_user) 
                                AND iscomplete = 1
                                AND sysdate - edate < 1
                            ORDER BY 
                                sdate DESC) 
                            WHERE ROWNUM = 1'
            Using p_report, p_yyyy, p_yymm, p_yearmode, p_user;

    End get_rpt_process_list; 

    --PROJECT NAME
    Function get_proj_name(
        p_projno In Varchar2
    ) Return Varchar2 Is
        v_name projmast.name%Type;
    Begin
        Select
            name
        Into
            v_name
        From
            (
                Select
                    projno,
                    name
                From
                    projmast
                Where
                    substr(projno, 1, 5) = substr(Trim(p_projno), 1, 5)
                Order By projno
            )
        Where
            Rownum = 1;

        Return v_name;
    Exception
        When Others Then
            Return Null;
    End;

    Procedure get_proj_name_proc(
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_projno          Varchar2,
        p_name    Out     Varchar2
    )  As
        v_name projmast.name%Type;
    Begin
        Select
            name
        Into
            v_name
        From
            (
                Select
                    projno,
                    name
                From
                    projmast
                Where
                    substr(projno, 1, 5) = substr(Trim(p_projno), 1, 5)
                Order By projno
            )
        Where
            Rownum = 1;

        p_name := v_name;
    Exception
        When Others Then
            p_name := Null;
    End;
    
    Procedure get_expt_proj_name_proc(
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_projno          Varchar2,
        p_name    Out     Varchar2
    )  As
        v_name exptjobs.name%Type;
    Begin
        Select
            name
        Into
            v_name
        From
            (
                Select
                    projno,
                    name
                From
                    exptjobs
                Where
                    substr(projno, 1, 5) = substr(Trim(p_projno), 1, 5)
                Order By projno
            )
        Where
            Rownum = 1;

        p_name := v_name;
    Exception
        When Others Then
            p_name := Null;
    End;
    
    function get_proj_active (
        p_projno   in varchar2
    ) return number is
        v_active projmast.active%TYPE;
    begin
        select
            active
        into v_active
        from
            (
                select
                    projno,
                    active
                from
                    projmast
                where
                    substr(projno, 1, 5) = substr(trim(p_projno), 1, 5)
                order by
                    projno
            )
        where
            rownum = 1;
      return v_active;
    exception
        when others then
            return 0;
    end;
    
    function get_proj_cdate  (
        p_projno   in varchar2
    ) return date is
        v_cdate projmast.cdate%TYPE;
    begin
        select
            cdate
        into v_cdate
        from
            (
                select
                    projno,
                    cdate
                from
                    projmast
                where
                    substr(projno, 1, 5) = substr(trim(p_projno), 1, 5)
                order by
                    projno
            )
        where
            rownum = 1;
        return v_cdate;
      exception
        when others then
            return null;
    end; 
    
    function get_proj_tcmno  (
        p_projno   in varchar2
    ) return varchar2 is
        v_tcmno projmast.tcmno%TYPE;
    begin
        select
            tcmno
        into v_tcmno
        from
            (
                select
                    projno,
                    tcmno
                from
                    projmast
                where
                    substr(projno, 1, 5) = substr(trim(p_projno), 1, 5)
                order by
                    projno
            )
        where
            rownum = 1;
        return v_tcmno;
      exception
        when others then
            return '';
    end;
    
    function get_tma_group_desc (
        p_costcode   in varchar2
    ) return varchar2 is
        v_name costmast.name%TYPE;
    begin
      select
            name
        into v_name
        from
            costmast
        where
            costcode = p_costcode;
        return v_name;
    end;
    
    function get_exp_proj_name (
        p_projno in varchar2
    ) return varchar2 IS
        v_name exptjobs.name%TYPE;
    begin
        select
            name
        into v_name
        from
            (
                select
                    projno,
                    name
                from
                    exptjobs
                where
                    substr(projno, 1, 5) = substr(TRIM(p_projno), 1, 5)
                    and (active > 0 or activefuture > 0)
                order by
                    projno
            )
        where
            rownum = 1;

        return v_name;
    exception
        when others then
            return null;
    end;

  function get_exp_proj_active (
        p_projno   in varchar2
    ) return number is
        v_active exptjobs.active%TYPE;
    begin
        select
            active
        into v_active
        from
            (
                select
                    projno,
                    active
                from
                    exptjobs
                where
                    substr(projno, 1, 5) = substr(trim(p_projno), 1, 5)
                    and (active > 0 or activefuture > 0)
                order by
                    projno
            )
        where
            rownum = 1;
      return v_active;
    exception
        when others then
            return 0;
    end;
    
    function get_exp_proj_activefuture (
        p_projno   in varchar2
    ) return number is
        v_activefuture exptjobs.activefuture%TYPE;
    begin
        select
            activefuture 
        into v_activefuture 
        from
            (
                select
                    projno,
                    activefuture
                from
                    exptjobs
                where
                    substr(projno, 1, 5) = substr(trim(p_projno), 1, 5)
                    and (active > 0 or activefuture > 0)
                order by
                    projno
            )
        where
            rownum = 1;
        return v_activefuture;
      exception
        when others then
            return null;
    end; 
    
    function get_exp_proj_tcmno  (
        p_projno   in varchar2
    ) return varchar2 is
        v_tcmno exptjobs.tcmno%TYPE;
    begin
        select
            tcmno
        into v_tcmno
        from
            (
                select
                    projno,
                    tcmno
                from
                    exptjobs
                where
                    substr(projno, 1, 5) = substr(trim(p_projno), 1, 5)
                    and (active > 0 or activefuture > 0)
                order by
                    projno
            )
        where
            rownum = 1;
        return v_tcmno;
      exception
        when others then
            return '';
    end;
End rap_reports_gen;
/
---------------------------
--Changed PACKAGE BODY
--RAP_REPORTS
---------------------------
CREATE OR REPLACE PACKAGE BODY "TIMECURR"."RAP_REPORTS" as
  
  /* Month Columns */
  function rpt_month_cols(p_yymm in varchar2, p_month in number) return t_tab_yymm as
      v_results t_tab_yymm;
    begin      
     /*select t_rec_yymm(to_char(add_months(to_date(p_yymm,'yyyymm') ,n-1),'yyyymm'), chr(64 + n)) bulk collect into v_results from 
        (select rownum n from (select 1 just_a_column from dual connect by level <= p_month)); */
      select t_rec_yymm(to_char(add_months(to_date(p_yymm,'yyyymm'), n-1),'yyyymm'), alpha) bulk collect into v_results from
      (with alpha as (select chr(level+65-1) letter from dual connect by level <= 26 ),
        xls1 as (select a.letter||b.letter alpha from alpha a,alpha b),
        letters as (select xls1.alpha from xls1 union select letter from alpha),
        output as ( select row_number() over (order by length(alpha),alpha) n, alpha from letters l )
        select * from output where rownum <= p_month);      
      return v_results;
  end rpt_month_cols;

  function getWorkingHrs(p_yymm in varchar2) return number as
      v_workinghrs number(7,2);
    begin
      select nvl(working_hr,0) into v_workinghrs from raphours 
        where yymm = p_yymm;
    return v_workinghrs;
  end getWorkingHrs;

  function getCummFutRecruit(p_costcode in varchar2, p_yymm_start in varchar2, p_yymm_end in varchar2) return number as
     v_futrecruit number(7,2);
    begin
      select sum(nvl(fut_recruit,0)) into v_futrecruit from movemast 
        where yymm >= p_yymm_start and yymm <= p_yymm_end and costcode = p_costcode;
    return v_futrecruit;
  end getCummFutRecruit;

  procedure cha1_costcodes(p_results out sys_refcursor) as
    begin
      open p_results for
      'select costcode from costmast where (tma_grp = ''E'' 
        or tma_grp = ''P'' or tma_grp = ''C'' or tma_grp = ''M'')
        and activity = 1 and group_chart = 1 and costcode like ''02%'' ';
  end cha1_costcodes;

  procedure get_cha1_process_list(p_yyyy in varchar2, p_user in varchar2, p_results out sys_refcursor) as
    begin
      open p_results for 
        'select * from ngts_cha1_process where yyyy = :p_yyyy and user = :p_user order by sdate'
      using p_yyyy, p_user;
  end get_cha1_process_list;

  procedure update_cha1_process(p_keyid in varchar2, p_user in varchar2, p_yyyy in varchar2, p_yymm in varchar2, p_msg out varchar2) as
      vCount number := 0;
    begin
      select count(*) into vCount from rap_cha1_process where keyid = p_keyid and userid = p_user;
      if vCount = 0 then
        insert into rap_cha1_process(keyid, userid, email, yyyy, yymm, iscomplete, sdate)
         values (p_keyid, p_user, ngts_users.ngts_getemail(p_user), p_yyyy, p_yymm, 0, sysdate);
      else
        update rap_cha1_process
          set iscomplete = 1, edate = sysdate
          where keyid = p_keyid and userid = p_user and yymm = p_yymm;
      end if;
      p_msg := 'Done';
     exception
        when others then
          p_msg := 'error ';
  end update_cha1_process;



  /* CHA1 Expected */
  procedure rpt_cha1_expt(p_timesheet_yyyy in varchar2, p_yymm in varchar2, p_costcode in varchar2, p_cols out sys_refcursor, 
                          p_gen out sys_refcursor, p_alldata out sys_refcursor, p_ot out sys_refcursor, 
                          p_project out sys_refcursor, p_future out sys_refcursor) as
      pivot_clause varchar2(4000);
      aggregate_clause varchar2(4000);
      noofmonths number;
      p_batch_key_id varchar2(8);
      p_insert_query Varchar2(10000);
      p_success Varchar2(2);
      p_message Varchar2(4000);
      v_new_yymm Varchar2(6);
    begin
      noofmonths := 18;      
      select to_char(add_months(to_date(p_yymm,'yyyymm'),1),'yyyymm') into v_new_yymm from dual;

      select substr(SYS_GUID(),0,8) into p_batch_key_id from dual;
      -- Populate GTT tbales ---------------------------------------------------
      rap_gtt.get_insert_query_4_gtt(p_timesheet_yyyy, 'MOVEMAST', p_insert_query, p_success, p_message);      
      if p_success = 'OK' then
          execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_batch_key_id, p_costcode, p_yymm;     
          rap_gtt.get_insert_query_4_gtt(p_timesheet_yyyy, 'EXPTPRJC', p_insert_query, p_success, p_message);
          if p_success = 'OK' then
              execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_costcode, p_yymm;
              rap_gtt.get_insert_query_4_gtt(p_timesheet_yyyy, 'PRJCMAST', p_insert_query, p_success, p_message);
              if p_success = 'OK' then
                  execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_costcode, p_yymm;
                  commit;

                  select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
                  from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));

                  select listagg( ' sum(' ||  heading || ') as "' || heading || '"', ', ') within group (order by yymm) into aggregate_clause
                  from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));

                  -- General Data --------------------------------------------------------
                  open p_gen for
                  'select a.costcode, a.abbr, a.noofemps, a.changed_nemps, initcap(b.name) name, 
                    to_char(sysdate, ''dd-Mon-yyyy'') pdate, a.noofcons from costmast a, emplmast b
                    where a.hod = b.empno and costcode = :p_costcode'
                  using p_costcode;
                  -- Column names --------------------------------------------------------
                  open p_cols for
                    'select * from ( 
                      select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
                    ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
                  using v_new_yymm, noofmonths;
                  -- All Data  --------------------------------------------------
                  open p_alldata for
                  'select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(working_hr,0) working_hr from raphours where yymm > :p_yymm order by yymm )
                      select a.yymm, ''a'' as Name, b.working_hr from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(working_hr) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(fut_recruit,0) fut_recruit from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''b'' as Name, b.fut_recruit from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(fut_recruit) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(int_dept,0) int_dept from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''c'' as Name, b.int_dept from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(int_dept) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(movetotcm,0) movetotcm from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''d'' as Name, b.movetotcm from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(movetotcm) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(movetosite,0) movetosite from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''e'' as Name, b.movetosite from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(movetosite) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(movetoothers,0) movetoothers from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''f'' as Name, b.movetoothers from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(movetoothers) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(ext_subcontract,0) ext_subcontract from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''g'' as Name, b.ext_subcontract from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(ext_subcontract) for yymm in ('|| pivot_clause ||')) '
                  using p_yymm, noofmonths, p_yymm, p_yymm, noofmonths, p_costcode, p_yymm, p_yymm, noofmonths, p_costcode, p_yymm, p_yymm, 
                        noofmonths, p_costcode, p_yymm, p_yymm, noofmonths, p_costcode, p_yymm, p_yymm, noofmonths, p_costcode, p_yymm, 
                        p_yymm, noofmonths, p_costcode, p_yymm;      
                  -- Overtime ------------------------------------------------------------
                  open p_ot for
                  'select * from (
                    with t_yymm as (
                      select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
                    ),
                    t_data as (   
                      select yymm, ot from otmast where costcode = :p_costcode and yymm > :p_yymm order by yymm
                    )
                    select a.yymm, b.ot from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                  ) pivot (sum(ot) for yymm in ('|| pivot_clause ||'))'
                  using v_new_yymm, noofmonths, p_costcode, p_yymm;
                  -- Projects ------------------------------------------------------------
                  /*open p_project for
                  'select row_number() over (order by q.newcostcode, p.projno) srno, q.*, p.* from (
                    with t_yymm as (
                      select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :p_costcode))
                    ),
                    t_data as (   
                      select projno, yymm, nvl(hours,0) as hrs from rap_gtt_prjcmast where costcode = :p_costcode and yymm >= :p_yymm order by yymm
                    )
                    select b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||'))
                    p join (select projno, name, active, cdate, newcostcode, tcmno from projmast 
                    where active > 0 and projno in (select distinct projno from rap_gtt_prjcmast 
                    where yymm > :p_yymm and costcode = :p_costcode)) q on p.projno = q.projno
                    order by q.newcostcode, p.projno ' 
                  using p_yymm, p_costcode, p_costcode, p_yymm, p_yymm, p_costcode;*/

                  open p_project for
                    'select * from 
                    (select newcostcode, coalesce(projno, rap_reports_gen.get_tma_group_desc(newcostcode)) as projno, 
                    rap_reports_gen.get_proj_name(projno) name, rap_reports_gen.get_proj_name(projno) cdate, 
                    rap_reports_gen.get_proj_name(projno) tcmno, '|| aggregate_clause ||' from ( 
                    with t_yymm as (
                      select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :p_costcode))
                    ),
                    t_data as (   
                      select projno, yymm, nvl(hours,0) as hrs from rap_gtt_prjcmast where costcode = :p_costcode and yymm > :p_yymm order by yymm 
                    )
                    select (select x.newcostcode from projmast x where x.projno = b.projno) newcostcode, 
                    b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||'))
                    group by rollup(newcostcode, projno) order by newcostcode, projno) 
                    where newcostcode is not null'
                  using v_new_yymm, p_costcode, p_costcode, p_yymm;  

                  -- Future ------------------------------------------------------------
                  /*open p_future for
                  'select row_number() over (order by q.active,q.newcostcode, p.projno) srno, q.*, p.* from (
                    with t_yymm as (
                      select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :p_costcode))
                    ),
                    t_data as (   
                      select projno, yymm, nvl(hours,0) as hrs from rap_gtt_exptprjc where costcode = :p_costcode and yymm >= :p_yymm order by yymm
                    )
                    select b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||'))
                    p join (select projno, name, active, activefuture, newcostcode, tcmno from exptjobs 
                    where (active > 0 or activefuture > 0 ) and projno in (select distinct projno from rap_gtt_exptprjc  
                    where yymm > :p_yymm and costcode = :p_costcode)) q on p.projno = q.projno
                    order by q.active,q.newcostcode, p.projno'
                  using p_yymm, p_costcode, p_costcode, p_yymm, p_yymm, p_costcode;*/

                  open p_future for
                    'select * from 
                    (select newcostcode, coalesce(projno, rap_reports_gen.get_tma_group_desc(newcostcode)) as projno, 
                    rap_reports_gen.get_exp_proj_name(projno) name, rap_reports_gen.get_exp_proj_activefuture(projno) activefuture, 
                    rap_reports_gen.get_exp_proj_tcmno(projno) tcmno, '|| aggregate_clause ||' from ( 
                    with t_yymm as (
                      select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :p_costcode))
                    ),
                    t_data as (   
                      select projno, yymm, nvl(hours,0) as hrs from rap_gtt_exptprjc where costcode = :p_costcode and yymm > :p_yymm order by yymm 
                    )
                    select (select x.newcostcode from exptjobs x where x.projno = b.projno) newcostcode, 
                    b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||'))
                    group by rollup(newcostcode, projno) order by newcostcode, projno) 
                    where newcostcode is not null'
                  using v_new_yymm, p_costcode, p_costcode, p_yymm;  
              end if;
          end if;
      end if;
  end rpt_cha1_expt;

  /* CHA1 Expected Simulation */
  procedure rpt_cha1_expt_simul(p_yymm in varchar2, p_costcode in varchar2, p_simul in varchar2, p_cols out sys_refcursor, 
                                p_gen out sys_refcursor, p_alldata out sys_refcursor, p_ot out sys_refcursor, 
                                p_project out sys_refcursor, p_future out sys_refcursor) as
      pivot_clause varchar2(4000);
      aggregate_clause varchar2(4000);
      noofmonths number;
	  mfilter varchar2(1000);      
      v_new_yymm Varchar2(6); -- added 25-03-22
    begin
      noofmonths := 18;
      select to_char(add_months(to_date(p_yymm,'yyyymm'),1),'yyyymm') into v_new_yymm from dual; 
      case p_simul
        when 'A' then 
          mfilter := ' and proj_type in (''A'',''B'',''C'') ';         
        when 'B' then 
          mfilter := ' and proj_type in (''B'',''C'') ';           
        when 'C' then 
          mfilter := ' and proj_type in (''C'') ';          
        else 
          mfilter := '';          
      end case;      
      select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
      from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));

      select listagg( ' sum(' ||  heading || ') as "' || heading || '"', ', ') within group (order by yymm) into aggregate_clause
      from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));
      -- General Data --------------------------------------------------------
      open p_gen for
      'select a.costcode, a.abbr, a.noofemps, a.changed_nemps, initcap(b.name) name, 
        to_char(sysdate, ''dd-Mon-yyyy'') pdate, a.noofcons from costmast a, emplmast b
        where a.hod = b.empno and costcode = :p_costcode'
      using p_costcode;
      -- Column names --------------------------------------------------------
      open p_cols for
        'select * from ( 
          select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
        ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
      using v_new_yymm, noofmonths;
      -- All Data  --------------------------------------------------
      open p_alldata for
      'select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, nvl(working_hr,0) working_hr from raphours where yymm > :p_yymm order by yymm )
          select a.yymm, ''a'' as Name, b.working_hr from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(working_hr) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, nvl(fut_recruit,0) fut_recruit from movemast where costcode = :p_costcode and yymm = :p_yymm order by yymm )
          select a.yymm, ''b'' as Name, b.fut_recruit from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(fut_recruit) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, nvl(int_dept,0) int_dept from movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
          select a.yymm, ''c'' as Name, b.int_dept from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(int_dept) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, nvl(movetotcm,0) movetotcm from movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
          select a.yymm, ''d'' as Name, b.movetotcm from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(movetotcm) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, nvl(movetosite,0) movetosite from movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
          select a.yymm, ''e'' as Name, b.movetosite from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(movetosite) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, nvl(movetoothers,0) movetoothers from movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
          select a.yymm, ''f'' as Name, b.movetoothers from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(movetoothers) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, nvl(ext_subcontract,0) ext_subcontract from movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
          select a.yymm, ''g'' as Name, b.ext_subcontract from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(ext_subcontract) for yymm in ('|| pivot_clause ||')) '
      using p_yymm, noofmonths, p_yymm, p_yymm, noofmonths, p_costcode, p_yymm, p_yymm, noofmonths, p_costcode, p_yymm, p_yymm, 
            noofmonths, p_costcode, p_yymm, p_yymm, noofmonths, p_costcode, p_yymm, p_yymm, noofmonths, p_costcode, p_yymm, 
            p_yymm, noofmonths, p_costcode, p_yymm;      
      -- Overtime ------------------------------------------------------------
      open p_ot for
      'select * from (
        with t_yymm as (
          select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
        ),
        t_data as (   
          select yymm, ot from otmast where costcode = :p_costcode and yymm >= :p_yymm order by yymm
        )
        select a.yymm, b.ot from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
      ) pivot (sum(ot) for yymm in ('|| pivot_clause ||'))'
      using v_new_yymm, noofmonths, p_costcode, p_yymm;
      -- Projects ------------------------------------------------------------
      /*open p_project for
      'select row_number() over (order by q.newcostcode, p.projno) srno, q.*, p.* from (
        with t_yymm as (
          select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :p_costcode))
        ),
        t_data as (   
          select projno, yymm, nvl(hours,0) as hrs from prjcmast where costcode = :p_costcode and yymm >= :p_yymm order by yymm
        )
        select b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||'))
        p join (select projno, name, active, cdate, newcostcode, tcmno from projmast 
        where active > 0 and projno in (select distinct projno from prjcmast 
        where yymm > :p_yymm and costcode = :p_costcode)) q on p.projno = q.projno
        order by q.newcostcode, p.projno ' 
      using p_yymm, p_costcode, p_costcode, p_yymm, p_yymm, p_costcode;*/

      open p_project for
        'select * from 
        (select newcostcode, coalesce(projno, rap_reports_gen.get_tma_group_desc(newcostcode)) as projno, 
        rap_reports_gen.get_proj_name(projno) name, rap_reports_gen.get_proj_name(projno) cdate, 
        rap_reports_gen.get_proj_name(projno) tcmno, '|| aggregate_clause ||' from ( 
        with t_yymm as (
          select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :p_costcode))
        ),
        t_data as (   
          select projno, yymm, nvl(hours,0) as hrs from rap_gtt_prjcmast where costcode = :p_costcode and yymm > :p_yymm order by yymm 
        )
        select (select x.newcostcode from projmast x where x.projno = b.projno) newcostcode, 
        b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||'))
        group by rollup(newcostcode, projno) order by newcostcode, projno) 
        where newcostcode is not null'
      using v_new_yymm, p_costcode, p_costcode, p_yymm;  

      -- Future ------------------------------------------------------------
      /*open p_future for
      'select row_number() over (order by q.active,q.newcostcode, p.projno) srno, q.*, p.* from (
        with t_yymm as (
          select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :p_costcode))
        ),
        t_data as (   
          select projno, yymm, nvl(hours,0) as hrs from exptprjc where costcode = :p_costcode and yymm >= :p_yymm order by yymm
        )
        select b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||'))
        p join (select projno, name, active, activefuture, newcostcode, tcmno from exptjobs 
        where (active > 0 or activefuture > 0 ) '|| mfilter || ' and projno in (select distinct projno from exptprjc 
        where yymm > :p_yymm and costcode = :p_costcode)) q on p.projno = q.projno
        order by q.active,q.newcostcode, p.projno'
      using p_yymm, p_costcode, p_costcode, p_yymm, p_yymm, p_costcode;*/

      open p_future for
        'select * from 
        (select newcostcode, coalesce(projno, rap_reports_gen.get_tma_group_desc(newcostcode)) as projno, 
        rap_reports_gen.get_exp_proj_name(projno) name, rap_reports_gen.get_exp_proj_activefuture(projno) activefuture, 
        rap_reports_gen.get_exp_proj_tcmno(projno) tcmno, '|| aggregate_clause ||' from ( 
        with t_yymm as (
          select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :p_costcode))
        ),
        t_data as (   
          select projno, yymm, nvl(hours,0) as hrs from rap_gtt_exptprjc where costcode = :p_costcode and yymm > :p_yymm order by yymm 
        )
        select (select x.newcostcode from exptjobs x where x.projno = b.projno) newcostcode, 
        b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||'))
        group by rollup(newcostcode, projno) order by newcostcode, projno) 
        where newcostcode is not null'
      using v_new_yymm, p_costcode, p_costcode, p_yymm; 
  end rpt_cha1_expt_simul;                              


  /* TM11 TM01 */
  procedure rpt_tm11_tm01(p_projno in varchar2, p_yymm in varchar2, p_yearmode in varchar2, 
                          p_cols out sys_refcursor, p_part1 out sys_refcursor, p_part2 out sys_refcursor, 
                          p_part3 out sys_refcursor, p_part4 out sys_refcursor) as
      pivot_clause varchar2(4000);
      noofmonths number;
      strPrcMnth varchar2(6);
      strYrStart varchar2(6);
      strEndMnth varchar2(6);
    begin
      strPrcMnth := p_yymm;
      strYrStart := p_yymm;
      select to_char(add_months(to_date(p_yymm,'yyyymm'), 12),'yyyymm') into strEndMnth from dual;
      noofmonths := 12;      
      select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
      from (select yymm, heading from table(rap_reports.rpt_month_cols(p_yymm, noofmonths)));
      -- General Data --------------------------------------------------------
      open p_cols for
      'select * from ( 
          select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
        ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
      using p_yymm, noofmonths;       
      -- Part1 Data --------------------------------------------------------  
      open p_part1 for
      'select t_1.costcode, t_1.name, t_1.phase, t_2.original, t_2.revised, t_4.currmnth, t_5.curryear, 
        (nvl(t_5.curryear,0) + nvl(t_3.opening,0)) opening, t_6.*, t_7.next_total, t_8.next_total_1 from
        (select distinct costcode, name, phase from costmast where cost_type = ''D'' and (
            costcode in (select distinct costcode from budgmast 
            where projno in (select projno from ProjMast where proj_no = :p_projno)) or
            costcode in (select distinct costcode from openmast 
            where projno in (select projno from ProjMast where proj_no = :p_projno)) or 
            costcode in (select distinct costcode from prjcmast 
            where projno in (select projno from ProjMast where proj_no = :p_projno) and yymm > :strPrcMnth) or 
            costcode in (select distinct costcode from timetran 
            where projno in (select projno from ProjMast where proj_no = :p_projno) and 
            yymm >= :strYrStart and yymm <= :strPrcMnth)) order by phase,costcode) t_1,
       (select costcode, sum(nvl(original,0))as original, sum(nvl(revised,0))as revised 
            from budgmast where projno in (select projno from projmast where proj_no = :p_projno)
            group by costcode order by costcode) t_2,
       (select costcode, case ''' || p_yearmode || ''' when ''J'' then sum(nvl(open01,0)) else sum(nvl(open04,0)) end as opening 
            from openmast where projno in (select projno from projmast where proj_no = :p_projno)
            group by costcode order by costcode) t_3,
       (select costcode,sum(nvl(hours,0)) + sum(nvl(othours,0)) as currmnth from timetran where
            projno in (select projno from projmast where proj_no = :p_projno) and yymm = :strPrcMnth
            group by costcode order by costcode) t_4,
       (select costcode,sum(nvl(hours,0)) + sum(nvl(othours,0)) as curryear from timetran 
        where projno in (select projno from projmast where proj_no = :p_projno) 
        and yymm >= :strYrStart and yymm <= :strPrcMnth
        group by costcode order by costcode) t_5,
       (select * from (
            with t_yymm as (
              select yymm from table(rap_reports.rpt_month_cols(:strPrcMnth, 12))
            ),
            t_data as (   
              select yymm,costcode,sum(nvl(hours,0)) as hours from prjcmast 
                where projno in (select projno from projmast where proj_no = :p_projno) 
                and yymm > :strYrStart and yymm <= :strEndMnth
                group by costcode,yymm order by costcode,yymm
            )
            select a.yymm,b.costcode, b.hours from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
          ) pivot (sum(hours) for yymm in ('|| pivot_clause ||'))
          order by costcode) t_6,
          (select costcode, sum(nvl(hours,0)) as next_total from prjcmast 
            where projno in (select projno from projmast where proj_no = :p_projno) and yymm > :strEndMnth
            and yymm <= to_char(add_months(to_date(:strEndMnth, ''yyyymm''), 12), ''yyyymm'')
            group by costcode order by costcode) t_7,
          (select costcode, sum(nvl(hours,0)) as next_total_1 from prjcmast 
            where projno in (select projno from projmast where proj_no = :p_projno) 
            and yymm > to_char(add_months(to_date(:strEndMnth, ''yyyymm''), 12), ''yyyymm'') 
            and yymm <= to_char(add_months(to_date(:strEndMnth, ''yyyymm''), 24), ''yyyymm'')
            group by costcode order by costcode) t_8  
        where t_1.costcode = t_2.costcode(+) and t_1.costcode = t_3.costcode(+) and t_1.costcode = t_4.costcode(+)
            and t_1.costcode = t_5.costcode(+) and t_1.costcode = t_6.costcode(+) and t_1.costcode = t_7.costcode(+)
            and t_1.costcode = t_8.costcode(+)'
      using p_projno, p_projno, p_projno, strPrcMnth, p_projno, strYrStart, strPrcMnth, 
        p_projno, p_projno, 
        p_projno, strPrcMnth, 
        p_projno, strYrStart, strPrcMnth,
        strPrcMnth, p_projno, strYrStart, strEndMnth,
        p_projno, strEndMnth, strEndMnth, p_projno, strEndMnth, strEndMnth;
      -- Part2 Data --------------------------------------------------------  
      open p_part2 for
        'select case p.emptype when ''R'' then ''TCMPL Personnel'' when ''C'' then ''Consultants''
            when ''S'' then ''SubContract'' when ''F'' then ''FTC''
            else '''' end emptype, q.totmnhrs, p.totyrhrs  from (
        select b.emptype, sum(nvl(a.hours,0)) + sum(nvl(a.othours,0)) as totyrhrs
        from timetran a, emplmast b where b.empno = a.empno
        and a.yymm >= :strYrStart and yymm <= :strPrcMnth and substr(a.projno,1,5) = :p_projno
        group by b.emptype) p left outer join (
        select b.emptype, sum(nvl(a.hours,0)) + sum(nvl(a.othours,0)) as totmnhrs
        from timetran a, emplmast b where b.empno = a.empno and a.yymm = :strPrcMnth 
        and substr(a.projno,1,5) = :p_projno 
        group by b.emptype) q on p.emptype = q.emptype'
      using strYrStart, strPrcMnth, p_projno, strPrcMnth, p_projno ;
      -- Part3 Data --------------------------------------------------------  
      open p_part3 for
      'select case a.emptype when ''R'' then ''TCMPL Personnel'' when ''C'' then ''Consultants''
            when ''S'' then ''SubContract'' when ''F'' then ''FTC'' else ''Not Defined'' end emptype, 
            case a.location when ''E'' then ''Employees'' when ''H'' then ''Head Office''
            when ''I'' then ''Sites - India'' when ''A'' then ''Sites - Foreign'' else ''Not Defined'' end location, 
            sum(a.monhrs) monhrs, sum(a.YrHrs) yrhrs from 
        ((select e.emptype, e.location, sum(nvl(t.hours,0)) + sum(nvl(t.othours,0)) as Monhrs,
        0 as YrHrs from timetran t, emplmast e where e.empno = t.empno and t.yymm = :strPrcMnth 
        and substr(t.projno,1,5) = :p_projno group by e.emptype, e.location)
        Union
        (select e.emptype, e.location,0 as MonHrs, sum(nvl(t.hours,0)) + sum(nvl(t.othours,0)) as Yrhrs 
        from timetran t, emplmast e where e.empno = t.empno and t.yymm >= :strYrStart and yymm <= :strPrcMnth
        and substr(t.projno,1,5) = :p_projno group by e.emptype, e.location)) a 
        group by a.emptype,a.location order  by a.emptype,a.location'
      using strPrcMnth, p_projno, strYrStart, strPrcMnth, p_projno;
      -- Part4 Data --------------------------------------------------------  
      open p_part4 for
      'select nvl(a.description,'' '') description, case a.emptype
        when ''R'' then ''TCMPL Personnel'' when ''C'' then ''Consultants'' when ''S'' then ''SubContract''
        when ''F'' then ''FTC'' else '''' end emptype,a.projno,sum(a.monhrs) monhrs,sum(a.yrhrs) yrhrs 
        from ((select e1.emptype, e1.subcontract, t1.projno, s1.description, 
        sum(nvl(t1.hours, 0)) + sum(nvl(t1.othours, 0))
        as monhrs, 0 as yrhrs from timetran t1, emplmast e1, subcontractmast s1
        where e1.empno(+) = t1.empno and s1.subcontract(+) = e1.subcontract 
        and t1.yymm = :strPrcMnth and substr(t1.projno,1,5) = :p_projno
        group by e1.emptype,e1.subcontract,t1.projno,s1.description) 
        union 
        (select e2.emptype, e2.subcontract, t2.projno, s2.description,
        0 as monhrs, sum(nvl(t2.hours,0)) + sum(nvl(t2.othours,0)) as yrhrs 
        from timetran t2, emplmast e2, subcontractmast s2 where e2.empno(+) = t2.empno 
        and t2.yymm >= :strYrStart and yymm <= :strPrcMnth and substr(t2.projno,1,5) = :p_projno
        and s2.subcontract(+) = e2.subcontract 
        group by e2.emptype, e2.subcontract, t2.projno, s2.description) ) a 
        group by a.projno, a.emptype, a.subcontract, a.description 
        order by a.projno, a.emptype, a.subcontract, a.description'
      using strPrcMnth, p_projno, strYrStart, strPrcMnth, p_projno;
  end rpt_tm11_tm01;

  /* PRJ CC TCM  */
  procedure rpt_prj_cc_tcm(p_yymm in varchar2, p_yearmode in varchar2,  
                           p_cols out sys_refcursor, p_results out sys_refcursor) as
      pivot_clause varchar2(4000);
      noofmonths number;
      strPrcMnth varchar2(6);
      strYrStart varchar2(6);      
    begin
      strPrcMnth := p_yymm;
      strYrStart := p_yymm;      
      noofmonths := 12;      
      select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
      from (select yymm, heading from table(rap_reports.rpt_month_cols(p_yymm, noofmonths)));
      -- General Data --------------------------------------------------------
      open p_cols for
      'select * from ( 
          select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
        ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
      using p_yymm, noofmonths;       
      -- Results Data -------------------------------------------------------- 
      open p_results for
      'select * from (
        with t_yymm as (
          select yymm from table(rap_reports.rpt_month_cols(:strYrStart, 12))
        ),
        t_data as (   
          select costcode,projno,tcmno,name,sapcc,yymm,tothours from prj_cc_tcm 
            where yymm >= :strYrStart and yymm <= :strPrcMnth 
            order by projno,costcode,yymm
        )
        select a.yymm,b.costcode,b.projno,b.tcmno,b.name,b.sapcc,nvl(b.tothours,0) tothours from t_yymm a, t_data b 
        where a.yymm = b.yymm(+) order by yymm
      ) pivot (sum(tothours) for yymm in ('|| pivot_clause ||'))
      order by projno, sapcc'
      using strYrStart,  strYrStart, strPrcMnth ;
  end rpt_prj_cc_tcm;

  /* Workload */
  procedure rpt_workload(p_costcode in varchar2, p_yymm in varchar2, p_simul in varchar2, p_empcnt in number,
                         p_cols out sys_refcursor, p_results out sys_refcursor) as
      pivot_clause varchar2(4000);
      noofmonths number;
      mfilter varchar2(1000);
      rfilter varchar2(1000);
    begin
      noofmonths := 18;      
      case p_simul
        when 'A' then 
          mfilter := ' and b.proj_type in (''A'',''B'',''C'') ';
          rfilter := ' and b.proj_type not in (''A'',''B'',''C'') ';          
        when 'B' then 
          mfilter := ' and b.proj_type in (''B'',''C'') ';
          rfilter := ' and b.proj_type not in (''B'',''C'') ';
        when 'C' then 
          mfilter := ' and b.proj_type in (''C'') ';
          rfilter := ' and b.proj_type not in (''C'') ';        
        else 
          mfilter := '';
          rfilter := '';
      end case;
 	 -- Cols --------------------------------------------------------			
      select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
      from (select yymm, heading from table(rap_reports.rpt_month_cols(p_yymm, noofmonths)));
      -- General Data --------------------------------------------------------
      open p_cols for
      'select * from ( 
          select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
        ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
      using p_yymm, noofmonths;       
      -- Results Data -------------------------------------------------------- 
      open p_results for
      'select * from (
          select yymm, ''A'' as Name, (rap_reports.getWorkingHrs(yymm) * :p_empcnt ) hrs 
             from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) order by yymm 
        ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, (nvl(movetosite,0) * rap_reports.getWorkingHrs(yymm)) + 
                           (nvl(movetoothers,0) * rap_reports.getWorkingHrs(yymm))  hrs from movemast where costcode = :p_costcode 
                            and yymm >= :p_yymm order by yymm )
          select a.yymm, ''B'' as Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, (nvl(movetotcm,0) * rap_reports.getWorkingHrs(yymm)) + 
                           (nvl(int_dept,0) * rap_reports.getWorkingHrs(yymm)) hrs from movemast where costcode = :p_costcode 
                            and yymm >= :p_yymm order by yymm )
          select a.yymm, ''C'' as Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, (nvl(ext_subcontract,0) * rap_reports.getWorkingHrs(yymm)) + 
                           (nvl(rap_reports.getCummFutRecruit(:p_costcode,:p_yymm, yymm),0) * rap_reports.getWorkingHrs(yymm)) hrs 
                          from movemast where costcode = :p_costcode and yymm >= :p_yymm order by yymm )
          select a.yymm, ''D'' as Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, sum(hrs) hrs from
                          (select a.yymm, sum(nvl(a.hours,0)) as hrs from prjcmast a, projmast b
                             where a.costcode = :p_costcode and a.projno = b.projno and b.active > 0 					
                             and a.yymm >= :p_yymm group by a.yymm
                           union
                           select a.yymm, sum(nvl(a.hours,0)) as hrs from exptprjc a, exptjobs b
                             where a.costcode = :p_costcode and a.projno = b.projno and b.activefuture > 0 and b.active <= 0 	
                             '|| mfilter ||' and a.yymm >= :p_yymm  group by a.yymm) group by yymm order by yymm )
          select a.yymm, ''F'' as Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select a.yymm, sum(nvl(a.hours,0)) as hrs from exptprjc a, exptjobs b
                           where a.costcode = :p_costcode and a.projno = b.projno and b.active > 0 and b.activefuture <= 0 
                           '|| mfilter ||' and a.yymm >= :p_yymm  group by a.yymm order by a.yymm )
          select a.yymm, ''G'' as Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))'
       using p_empcnt, p_yymm, noofmonths,
        p_yymm, noofmonths, p_costcode, p_yymm,
        p_yymm, noofmonths, p_costcode, p_yymm,
        p_yymm, noofmonths, p_costcode,p_yymm, p_costcode, p_yymm,
        p_yymm, noofmonths, p_costcode, p_yymm, p_costcode, p_yymm,
        p_yymm, noofmonths, p_costcode, p_yymm;
  end rpt_workload;

  procedure rpt_workload_new(p_costcode in varchar2, p_yymm in varchar2, p_simul in varchar2, p_yearmode in varchar2,
                             p_cols out sys_refcursor, p_results out sys_refcursor) as
      pivot_clause varchar2(4000);
      noofmonths number;
      mfilter varchar2(1000);
      v_lastmonth varchar2(6);
      viewname varchar2(30);
    begin
      noofmonths := 18;
      select rap_reports_gen.get_lastmonth(p_yymm, noofmonths) into v_lastmonth from dual;
      case p_yearmode
        when 'J' then 
          viewname := ' rap_vu_rpt_workload_01 ';
        else 
          viewname := ' rap_vu_rpt_workload_04 ';
      end case;

      case p_simul
        when 'A' then 
          mfilter := ' and proj_type in (''A'',''B'',''C'') ';
        when 'B' then 
          mfilter := ' and proj_type in (''B'',''C'') ';
        when 'C' then 
          mfilter := ' and proj_type in (''C'') '; 
        else 
          mfilter := '';
      end case;
 	 -- Cols --------------------------------------------------------			
      select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
      from (select yymm, heading from table(rap_reports.rpt_month_cols(p_yymm, noofmonths)));
      -- General Data --------------------------------------------------------
      open p_cols for
      'select * from ( 
          select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
        ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
      using p_yymm, noofmonths;       
      -- Results Data -------------------------------------------------------- 
      open p_results for
      'select * from 
        (with t_yymm as (select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))),
        t_data as (select yymm, name, sum(hrs) hrs from '|| viewname ||'
        where yymm >= :p_yymm and yymm <= :v_lastmonth and costcode = :p_costcode
        and name not in (''f'') and proj_type is null group by yymm, name
        union
        select yymm, name, sum(hrs) hrs from '|| viewname ||'
        where yymm >= :p_yymm and yymm <= :v_lastmonth and costcode = :p_costcode
        and name = ''f'' '|| mfilter ||'
        group by yymm, name order by yymm, name)
        select a.yymm, b.Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) 
        and b.name is not null order by yymm
        ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))
        order by name'
       using p_yymm, noofmonths, p_yymm, v_lastmonth, p_costcode, p_yymm, v_lastmonth, p_costcode;
  end rpt_workload_new;

  procedure rpt_tm01All_ProjectList(p_yymm in varchar2, p_simul in varchar2, p_results out sys_refcursor) as
      v_stat varchar2(2000);
    begin
      v_stat := 'select projno,tcmno,name,active,to_char(sdate,''dd-Mon-yy'') sdate,to_char(cdate,''dd-Mon-yy'') cdate ';
      v_stat := v_stat || ' from projmast where active > 0 and projno in  ';
      v_stat := v_stat || '(select distinct projno from prjcmast where yymm >= :p_yymm and active > 0)   ';
      v_stat := v_stat || 'union all ';
      v_stat := v_stat || 'select projno,tcmno,name,active, '''' sdate, '''' cdate from exptjobs ';
      v_stat := v_stat || 'where(active > 0 or activefuture > 0)  ';

      case p_simul
        when 'A' then 
          v_stat := v_stat || ' and proj_type in (''A'',''B'',''C'') ';                   
        when 'B' then 
          v_stat := v_stat || ' and proj_type in (''B'',''C'') ';          
        when 'C' then 
          v_stat := v_stat || ' and proj_type in (''C'') ';               
        else 
          v_stat := v_stat || '';          
      end case;

      v_stat := v_stat || ' and projno in (select distinct projno from exptprjc where yymm >= :p_yymm )';
      v_stat := v_stat || ' order by projno';
      open p_results for v_stat
      using p_yymm, p_yymm;            
  end rpt_tm01All_ProjectList;

  procedure rpt_tm01all(p_projno in varchar2, p_yymm in varchar2, p_simul in varchar2, p_yearmode in varchar2,
                        p_cols out sys_refcursor, p_results out sys_refcursor) as
      pivot_clause varchar2(4000);
      noofmonths number;
      strStart varchar2(6);
      mfilter varchar2(1000);
      --rfilter varchar2(1000);
    begin
      noofmonths := 48;
      strStart := p_yymm;          
 	  -- Cols --------------------------------------------------------			
      select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
      from (select yymm, heading from table(rap_reports.rpt_month_cols(p_yymm, noofmonths)));

      open p_cols for
      'select * from ( 
          select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
        ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
      using p_yymm, noofmonths;
      -- Results Data -------------------------------------------------------- 
      open p_results for
      'select p.costcode, p.name, nvl(q.revised,0) revised, nvl(r.curryear,0) curryear, nvl(s.opening,0) opening, t.* from
        (select distinct costcode, name, tm01_grp from costmast where cost_type = ''D'' and ( 
        costcode in (select distinct costcode from budgmast where projno = :p_projno) or  
        costcode in (select distinct costcode from openmast where projno = :p_projno) or  
        costcode in (select distinct costcode from prjcmast where projno = :p_projno and yymm > :p_yymm) or 
        costcode in (select distinct costcode from exptprjc where projno = :p_projno and yymm > :p_yymm) or
        costcode in (select distinct costcode from timetran where projno = :p_projno and yymm >= :strStart and yymm <= :p_yymm))) p,
        (select costcode, nvl(original,0) original, nvl(revised,0) revised from budgmast where projno = :p_projno) q,
        (select costcode, sum(nvl(hours,0)) + sum(nvl(othours,0)) as curryear from timetran 
        where projno = :p_projno and yymm >= :strStart and yymm <= :p_yymm 
        group by costcode order by costcode) r, 
        (select costcode, case ''' || p_yearmode || ''' when ''J'' then nvl(open01,0) else nvl(open04,0) end as opening 
          from openmast where projno = :p_projno order by costcode) s, 
        (select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, 48)) ),
             t_data as ( select * from (select costcode, yymm, hours from prjcmast where projno = :p_projno and yymm >= :p_yymm 
                         union  select costcode, yymm, hours from exptprjc where projno = :p_projno and yymm >= :p_yymm)  
                          order by costcode, yymm )
          select b.costcode, a.yymm, nvl(b.hours,0) hours from t_yymm a, t_data b where a.yymm = b.yymm(+) and costcode is not null 
              order by b.costcode, a.yymm
        )  pivot ( sum(hours) for yymm in ('|| pivot_clause ||')) order by costcode) t
        where p.costcode = q.costcode(+) and p.costcode = r.costcode(+) and p.costcode = s.costcode(+) and p.costcode = t.costcode(+)
        order by p.costcode'
        using p_projno, p_projno, p_projno, p_yymm, p_projno, p_yymm, p_projno, strStart, p_yymm, p_projno, 
        p_projno, strStart, p_yymm, p_projno, p_yymm, p_projno, p_yymm, p_projno, p_yymm;
  end rpt_tm01all;

  procedure rpt_tm01All_Project(p_projno in varchar2, p_results out sys_refcursor) as

    begin
      open p_results for
      'select projno, nvl(tcmno, '' '') tcmno, name, nvl(to_char(sdate, ''dd-Mon-yy''),'' '') sdate, 
       nvl(to_char(edate, ''dd-Mon-yy''), '' '') edate, 
       floor(months_between(edate, sdate)) mnths from  
       (select a.projno, a.tcmno, a.name, a.active, a.sdate,  
       case when length(b.myymm) > 0 then to_date(''28-'' || substr(b.myymm, 5, 2) || ''-'' || 
       substr(b.myymm, 1, 4),''dd-mm-yy'') else to_date(''28-'' || to_char(a.sdate, ''mm'') || ''-'' || 
       to_char(a.sdate, ''yy''),''dd-mm-yy'') end edate from projmast a,  
       (select projno, max(yymm) myymm from prjcmast where projno = :p_projno group by projno) b  
       where a.projno = b.projno and a.active > 0
       union all
       select projno, tcmno, name, active, null sdate, null edate from exptjobs 
       where projno = :p_projno and active > 0) order by projno'
    using p_projno, p_projno;
  end rpt_tm01All_Project;

  procedure rpt_resourceavlsch(p_timesheet_yyyy in varchar2, p_costcode in varchar2, p_yymm in varchar2, p_yearmode in varchar2,
                               p_cols out sys_refcursor, p_results out sys_refcursor) as
      pivot_clause varchar2(4000);
      noofmonths number;      
      --v_lastmonth varchar2(6);
      viewname varchar2(30);
      p_batch_key_id varchar2(8);
      p_insert_query Varchar2(10000);
      p_success Varchar2(2);
      p_message Varchar2(4000);
      --p_timesheet_yyyy Varchar2(7) := '2019-20';
    begin
      noofmonths := 18;
      select substr(SYS_GUID(),0,8) into p_batch_key_id from dual;
      -- Populate GTT tbales ---------------------------------------------------
      rap_gtt.get_insert_query_4_gtt(p_timesheet_yyyy, 'MOVEMAST', p_insert_query, p_success, p_message);

      if p_success = 'OK' then
          execute immediate p_insert_query using p_batch_key_id;        
          -- Cols ---------------------------------------------------------------- 			
          select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
            from (select yymm, heading from table(rap_reports.rpt_month_cols(p_yymm, noofmonths)));
          -- General Data --------------------------------------------------------
          open p_cols for
          'select * from ( 
              select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
            ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
          using p_yymm, noofmonths;       
          -- Results Data -------------------------------------------------------- 
          open p_results for
          'select * from 
            (with t_yymm as (select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))),
            t_data as (select yymm, costcode, ''a'' name, rap_reports_gen.get_empcount(costcode) + 
            nvl(rap_reports.getCummFutRecruit(costcode, rap_reports_gen.get_yymm_begin(yymm, :p_yearmode ), yymm),0) +
            nvl(int_dept,0) hrs from rap_gtt_movemast where costcode = :p_costcode and yymm >= :p_yymm
            union
            select yymm, costcode, ''b'' name, nvl(movetotcm,0) hrs from rap_gtt_movemast
              where costcode = :p_costcode and yymm >= :p_yymm
            union
            select yymm, costcode, ''d'' name, nvl(ext_subcontract,0) hrs from rap_gtt_movemast
              where costcode = :p_costcode and yymm >= :p_yymm)
            select a.yymm, b.name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) 
              and b.name is not null order by yymm
            ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))
            order by name'
           using p_yymm, noofmonths, p_yearmode, p_costcode, p_yymm, p_costcode, p_yymm, p_costcode, p_yymm;
      end if;             
  end rpt_resourceavlsch;

    Procedure get_report_status(p_reportid   In  Varchar2,
                                p_user       In  Varchar2,
                                p_yyyy       In  Varchar2,
                                p_yearmode   In  Varchar2,
                                p_yymm       In  Varchar2,
                                p_category   In  Varchar2 Default Null,
                                p_reporttype In  Varchar2 Default Null,
                                p_msg        Out Varchar2) As
        v_iscomplete Varchar2(15);
    Begin
        Select
            Case iscomplete
                When 1 Then
                    'Download'
                When 0 Then
                    'Processing...'
                Else
                    'Process'
            End
        Into
            v_iscomplete
        From
            (
                Select
                    iscomplete
                From
                    rap_rpt_process
                Where
                    reportid                 = p_reportid
                    And userid               = p_user
                    And yyyy                 = p_yyyy
                    And yymm                 = p_yymm
                    And yearmode             = p_yearmode
                    And nvl(category, '-')   = nvl(p_category, '-')
                    And nvl(reporttype, '-') = nvl(p_reporttype, '-')
                Order By sdate Desc
            )
        Where
            Rownum = 1;
        p_msg := v_iscomplete;
    Exception
        When Others Then
            p_msg := 'Process';
    End get_report_status;

    Procedure get_report_keyid(p_reportid   In  Varchar2,
                               p_user       In  Varchar2,
                               p_yyyy       In  Varchar2,
                               p_yearmode   In  Varchar2,
                               p_yymm       In  Varchar2,
                               p_category   In  Varchar2 Default Null,
                               p_reporttype In  Varchar2 Default Null,
                               p_keyid      Out Varchar2) As
        v_keyid rap_rpt_process.keyid%Type;
    Begin
        Select
            keyid
        Into
            v_keyid
        From
            (
                Select
                    keyid
                From
                    rap_rpt_process
                Where
                    reportid                 = p_reportid
                    And userid               = p_user
                    And yyyy                 = p_yyyy
                    And yymm                 = p_yymm
                    And yearmode             = p_yearmode
                    And nvl(category, '-')   = nvl(p_category, '-')
                    And nvl(reporttype, '-') = nvl(p_reporttype, '-')
                    And iscomplete           = 1
                Order By sdate Desc
            )
        Where
            Rownum = 1;
        p_keyid := v_keyid;
    Exception
        When Others Then
            p_keyid := ' ';
    End get_report_keyid;

    Procedure get_list_4_worker_process(p_result Out Sys_Refcursor) Is
    Begin
        Open p_result For
            Select 
                * 
            From 
                rap_rpt_process 
            Where 
                IsComplete = 0
            Order By sdate;

    End get_list_4_worker_process;
end rap_reports;
/
---------------------------
--Changed PACKAGE BODY
--RAP_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "TIMECURR"."RAP_SELECT_LIST_QRY" As

    Function fn_year_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                ts_yyyy data_value_field,
                ts_yyyy data_text_field
            From
                timecurr.ngts_year_mast
            Where
                ts_isactive = 1
            Order By
                ts_yyyy Desc;

        Return c;
    End;

    Function fn_yearmode_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                'A'             data_value_field,
                'April - March' data_text_field
            From
                dual
            Union All
            Select
                'J'                  data_value_field,
                'January - December' data_text_field
            From
                dual;

        Return c;
    End;

    Function fn_yearmonth_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_yyyy      Varchar2,
        p_yearmode  Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                value data_value_field,
                text  data_text_field
            From
                (
                    Select
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 0), 'yyyymm')   value,
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 0), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 1), 'yyyymm')   value,
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 1), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 2), 'yyyymm')   value,
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 2), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 3), 'yyyymm')   value,
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 3), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 4), 'yyyymm')   value,
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 4), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 5), 'yyyymm')   value,
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 5), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 6), 'yyyymm')   value,
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 6), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 7), 'yyyymm')   value,
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 7), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 8), 'yyyymm')   value,
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 8), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 9), 'yyyymm')   value,
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 9), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 10), 'yyyymm')   value,
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 10), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 11), 'yyyymm')   value,
                        to_char(add_months(to_date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 11), 'Mon Yyyy') text
                    From
                        dual
                )
            Where
                to_number(value) <= (
                    Select
                        to_number(pros_month)
                    From
                        tsconfig
                )
            Order By
                value Desc;

        Return c;
    End;
    
    Function fn_costcode_list_proco(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c          Sys_Refcursor;
    Begin        
        Open c For
            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                costmast
            Where
                active = 1
                And costcode Like '02%'
            Order By
                costcode;

        Return c;
    End;

    Function fn_costcode_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c          Sys_Refcursor;
        v_empno    Varchar2(5);
        n_costcode Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        Select
            Count(costcode)
        Into
            n_costcode
        From
            costmast
        Where
            hod = v_empno;
        If n_costcode = 0 Then
            Open c For
                Select
                    costcode                  data_value_field,
                    costcode || ' - ' || name data_text_field
                From
                    costmast
                Where
                    active = 1
                    And costcode Like '02%'
                Order By
                    costcode;
        Else
            Open c For
                Select
                    costcode                  data_value_field,
                    costcode || ' - ' || name data_text_field
                From
                    costmast
                Where
                    active = 1
                    And hod = v_empno
                    And costcode Like '02%'
                Order By
                    costcode;
        End If;

        Return c;
    End;
    
    Function fn_projno_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                projno                  data_value_field,
                projno || ' - ' || name data_text_field
            From
                projmast
            Where
                active = 1
            Order By
                projno;

        Return c;
    End;

    Function fn_empno_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                empno                  data_value_field,
                empno || ' - ' || name data_text_field
            From
                emplmast
            Where
                status = 1
            Order By
                empno;

        Return c;
    End;

    Function fn_simulation_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                'A' data_value_field,
                'A' data_text_field
            From
                dual
            Union All
            Select
                'B' data_value_field,
                'B' data_text_field
            From
                dual
            Union All
            Select
                'C' data_value_field,
                'C' data_text_field
            From
                dual;

        Return c;
    End;

    Function fn_expt_projno_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                projno                  data_value_field,
                projno || ' - ' || name data_text_field
            From
                exptjobs
            Where
                nvl(active, 0)          = 1
                Or nvl(activefuture, 0) = 1
            Order By
                projno;

        Return c;
    End;

    Function fn_job_tmagroup_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                tmagroup                          data_value_field,
                tmagroup || ' - ' || tmagroupdesc data_text_field
            From
                job_tmagroup
            Order By
                tmagroup;
        Return c;
    End;

End rap_select_list_qry;
/
---------------------------
--New PACKAGE BODY
--RAP_EXPCTJOBS
---------------------------
CREATE OR REPLACE PACKAGE BODY "TIMECURR"."RAP_EXPCTJOBS" as

   procedure sp_add_expectedjobs(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_PROJNO           varchar2,
      P_NAME             varchar2,
      P_ACTIVE           number,
      P_BU               varchar2 default null,
      P_ACTIVEFUTURE     number,
      P_FINAL_PROJNO     varchar2 default null,
      P_NEWCOSTCODE      varchar2 default null,
      P_TCMNO            varchar2 default null,
      P_LCK              number   default null,
      P_PROJ_TYPE        varchar2 default null,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as

      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      insert into EXPTJOBS
      (
         PROJNO, NAME, ACTIVE, BU, ACTIVEFUTURE, FINAL_PROJNO,
         NEWCOSTCODE, TCMNO, LCK, PROJ_TYPE
      )
      values (
         P_PROJNO, P_NAME, P_ACTIVE, P_BU, P_ACTIVEFUTURE, P_FINAL_PROJNO,
         P_NEWCOSTCODE, P_TCMNO, P_LCK, P_PROJ_TYPE
      );

      commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_add_expectedjobs;

   procedure sp_update_expectedjobs(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_PROJNO           varchar2,
      P_NAME             varchar2,
      P_ACTIVE           number,
      P_BU               varchar2 default null,
      P_ACTIVEFUTURE     number,
      P_FINAL_PROJNO     varchar2 default null,
      P_NEWCOSTCODE      varchar2 default null,
      P_TCMNO            varchar2 default null,
      P_LCK              number   default null,
      P_PROJ_TYPE        varchar2 default null,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as

      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      update EXPTJOBS
         set NAME = P_NAME,
             ACTIVE = P_ACTIVE,
             BU = P_BU,
             ACTIVEFUTURE = P_ACTIVEFUTURE,
             FINAL_PROJNO = P_FINAL_PROJNO,
             NEWCOSTCODE = P_NEWCOSTCODE,
             TCMNO = P_TCMNO,
             LCK = P_LCK,
             PROJ_TYPE = P_PROJ_TYPE
       where PROJNO = P_PROJNO;

      commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_update_expectedjobs;

   procedure sp_delete_expectedjobs(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_PROJNO           varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as

      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      delete from EXPTJOBS
       where PROJNO = P_PROJNO;

      commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_delete_expectedjobs;

   procedure sp_mv_by_months(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Projno           varchar2,
      P_Number_Of_Months number,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as

      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      update exptprjc
         set yymm = to_char(add_months(to_date(yymm, 'yyyymm'), P_Number_Of_Months), 'yyyymm')
       where projno = P_Projno;
      commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_mv_by_months;

   procedure sp_mv_to_final_real(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Projno           varchar2,
      P_Real_Projno      varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      cursor C1 is select * from EXPTPRJC where PROJNO = P_Projno;
      V_COSTCODE     char(4);
      V_YYMM         char(6);
      V_HOURS        number;
      V_COUNT1       integer;
      V_COUNT        integer;
      REC            EXPTPRJC%ROWTYPE;
      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      open c1;
      select count(*) into V_COUNT from projmast where projno = P_Real_Projno;
      if V_COUNT > 0 then
         select count(*) into V_COUNT1 from prjcmast where projno = P_Real_Projno;
         if V_COUNT1 = 0 then
            loop
               fetch c1 into rec;
               exit when c1%NOTFOUND;
               V_COSTCODE := rec.costcode;
               v_yymm     := rec.yymm;
               v_hours    := rec.hours;
               insert into prjcMAST values (v_COSTCODE, P_Real_Projno, v_YYMM, v_HOURS);
            end loop;
            close c1;
         else
            p_message_type := 'KO';
            p_message_text := 'Projections already exists';
            return;

         end if;
      else
         p_message_type := 'KO';
         p_message_text := 'New project not availabe in master';
         return;
      end if;

      commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         rollback;
         raise;
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_mv_to_final_real;

   procedure sp_mv_to_final_expected(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Projno           varchar2,
      P_expected_Projno  varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as

      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
      V_COSTCODE     char(4);
      V_YYMM         char(6);
      V_HOURS        number;
      V_COUNT1       integer;
      V_COUNT        integer;
      REC            EXPTPRJC%ROWTYPE;

   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      select count(*) into V_COUNT from exptJOBS where projno = P_expected_Projno;
      if V_COUNT > 0 then

         select count(*) into V_COUNT1 from exptprjc where projno = P_expected_Projno;

         if V_COUNT1 = 0 then
            update exptprjc set projno = P_expected_Projno where projno = P_Projno;
         else
            p_message_type := 'KO';
            p_message_text := 'Projections already exists';
            return;
         end if;
      else
         p_message_type := 'KO';
         p_message_text := 'Project not availabe in master';
         return;
      end if;

      commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         rollback;
         raise;
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_mv_to_final_expected;

   procedure sp_mv_to_final_Real_PC(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Projno           varchar2,
      P_New_Projno       varchar2,
      P_Costcode         varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as

      cursor C1 is select *
                     from EXPTPRJC
                    where PROJNO = P_Projno
                      and COSTCODE = P_Costcode;
      V_COSTCODE     char(4);
      V_YYMM         char(6);
      V_HOURS        number;
      V_COUNT1       integer;
      V_COUNT        integer;
      REC            EXPTPRJC%ROWTYPE;
      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      open c1;
      select count(*) into V_COUNT
        from projmast
       where projno = P_New_Projno
         and COSTCODE = P_Costcode;

      if V_COUNT > 0 then
         select count(*) into V_COUNT1
           from prjcmast
          where projno = P_New_Projno
            and COSTCODE = P_Costcode;
         if V_COUNT1 = 0 then
            loop
               fetch c1 into rec;
               exit when c1%NOTFOUND;
               V_COSTCODE := rec.costcode;
               v_yymm     := rec.yymm;
               v_hours    := rec.hours;
               insert into prjcMAST values (v_COSTCODE, P_New_Projno, v_YYMM, v_HOURS);
            end loop;
            close c1;
            delete from EXPTPRJC
             where PROJNO = P_Projno
               and COSTCODE = P_Costcode;
         else
            p_message_type := 'KO';
            p_message_text := 'Projections  for costcode '
                              || P_Costcode
                              || ' already exists';
            return;
         end if;
      else
         p_message_type := 'KO';
         p_message_text := 'Project and costcode combination not availabe';
         return;
      end if;

      commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         rollback;
         raise;
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_mv_to_final_Real_PC;

end RAP_EXPCTJOBS;
/
---------------------------
--New PACKAGE BODY
--RAP_EXPCTJOBS_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "TIMECURR"."RAP_EXPCTJOBS_QRY" as
 
   function fn_expected_Jobs(
      p_person_id   varchar2,
      p_meta_id     varchar2,

      p_row_number  number,
      p_page_length number

   ) return sys_refcursor as
      c sys_refcursor;
   begin

      open c for
         select *
           from (
                   select PROJNO as Project_No,
                          NAME as Project_Name,
                          ACTIVE as Is_Active,
                          BU as Bu,
                          ACTIVEFUTURE as Is_Active_Future,
                          FINAL_PROJNO as Final_Project_No,
                          NEWCOSTCODE as New_Costcode,
                          TCMNO as Tcmno,
                          LCK as Is_Locked,
                          PROJ_TYPE as Project_Type,
                          row_number() over (order by PROJNO desc) row_number,
                          count(*) over () total_row
                     from EXPTJOBS
                )
          where row_number between (nvl(p_row_number, 0) + 1) and (nvl(p_row_number, 0) + p_page_length)
          order by Project_No desc;
      return c;
   end fn_expected_Jobs;


   procedure sp_expectedjobs_details(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_PROJNO       varchar2,

      P_NAME         out varchar2,
      P_ACTIVE       out varchar2,
      P_BU           out varchar2,
      P_ACTIVEFUTURE out varchar2,
      P_FINAL_PROJNO out varchar2,
      P_NEWCOSTCODE  out varchar2,
      P_TCMNO        out varchar2,
      P_LCK          out varchar2,
      P_PROJ_TYPE    out varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      select NAME as Project_Name,
             ACTIVE as Is_Active,
             BU as Bu,
             ACTIVEFUTURE as Is_Active_Future,
             FINAL_PROJNO as Final_Project_No,
             NEWCOSTCODE as New_Costcode,
             TCMNO as Tcmno,
             LCK as Is_Locked,
             PROJ_TYPE as Project_Type
        into P_NAME,
             P_ACTIVE,
             P_BU,
             P_ACTIVEFUTURE,
             P_FINAL_PROJNO,
             P_NEWCOSTCODE,
             P_TCMNO,
             P_LCK,
             P_PROJ_TYPE
        from EXPTJOBS
       where PROJNO = P_PROJNO;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_expectedjobs_details;

end RAP_EXPCTJOBS_QRY;
/
