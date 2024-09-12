--------------------------------------------------------
--  DDL for Package Body RAP_REPORTS_GEN
--------------------------------------------------------

create or replace PACKAGE BODY                       "TIMECURR"."RAP_REPORTS_GEN" As

function get_actual_start_month (
       p_yyyy       in varchar2,
       p_yymm       in varchar2,
       p_yearmode   in varchar2
    ) return varchar2 as
      v_startmonth  varchar2(6);
    begin
      if substr(p_yymm,5,2) = '04' and p_yearmode = 'A' and substr(p_yyyy,1,4) <> substr(p_yymm,1,4) then
        v_startmonth := to_char(to_number(substr(trim(p_yymm), 1, 4)) - 1) || '04';
      else
        v_startmonth := get_yymm_begin(p_yymm, p_yearmode);
      end if;
      return v_startmonth;
    end get_actual_start_month;

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

        Return nvl(n_month_hours,0);
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

        Return nvl(n_year_hours,0);
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
                    Sum(nvl(open01, 0)),
                    Sum(nvl(open04, 0))
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
                    Sum(nvl(open01, 0)),
                    Sum(nvl(open04, 0))
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
            Return Nvl(n_open01,0);
        Elsif p_yearmode = 'A' Then
            Return Nvl(n_open04,0);
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
        p_simul      In  Varchar2,
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
                reporttype,
                simul
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
                p_reporttype,
                p_simul
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

     Procedure delete_rpt_process(
        p_keyid      In  Varchar2,
        p_user       In  Varchar2,
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
            keyid   = Trim(p_keyid) and
            upper(Trim(userid))  = upper(Trim(p_user));

        If vcount > 0 Then
            delete from rap_rpt_process
               where keyid = trim(p_keyid) and upper(Trim(userid))  = upper(Trim(p_user));
	        p_msg := 'Done';
        Else
           p_msg := 'KO';
        End If;
    Exception
        When Others Then
            p_msg := 'Error ';
    End delete_rpt_process;

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
                    projno = p_projno
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
                    --substr(projno, 1, 5) = substr(TRIM(p_projno), 1, 5)
                    projno = TRIM(p_projno)
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
                    --substr(projno, 1, 5) = substr(trim(p_projno), 1, 5)
                    projno = TRIM(p_projno)
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
                    --substr(projno, 1, 5) = substr(trim(p_projno), 1, 5)
                    projno = TRIM(p_projno)
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
                    --substr(projno, 1, 5) = substr(trim(p_projno), 1, 5)
                    projno = TRIM(p_projno)
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

    function get_e_ep_type  (
        p_projno   in varchar2
    ) return varchar2 is
        v_typename inv_ratemaster.rate_desc%TYPE;
    begin
         select
            rate_desc
                into v_typename
        from
            (
                select
                    distinct b.rate_desc
                from
                    inv_proj_dept_ratemaster a,
                    inv_ratemaster b
                where
                    a.rate_code1 = b.rate_code
                    and a.projno = trim(p_projno)
            )
        where
            rownum = 1;
        return v_typename;
      exception
        when others then
            return '';
    end;

    function get_sap_codecode  (
        p_costcode   in varchar2
    ) return varchar2 as
      v_sapcc costmast.sapcc%TYPE;
    begin
         select
            sapcc
                into v_sapcc
        from
            costmast
        where
            costcode = p_costcode;
        return v_sapcc;
      exception
        when others then
            return '';
    end;

    Procedure get_costcode_name_proc(
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_costcode          Varchar2,
        p_name    Out     Varchar2
    )  As
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

        p_name := v_name;
    Exception
        When Others Then
            p_name := Null;
    End;

    procedure insert_notfilled as
        cursor c1 is select * FROM CC_POST_DET_LOCK;
        --cursor c2 (vProjno char) is select * from projmast where rownum = 1 and substr(projno,1,5) = substr(vProjno,1,5) and cdate is null order by projno;
        c1_rec c1%rowtype;
        c_lockedmnth varchar2(6);
        --c2_rec c2%rowtype;
        --test_projno CHAR(7);
      begin
        select LOCKEDMNTH into c_LOCKEDMNTH from tsconfig;
        open c1;
        loop
        fetch c1 into c1_rec;
        exit when c1%NOTFOUND;
        -- test_projno := c1_rec.projno;
        -- open c2 (c1_rec.projno);
        -- loop
        -- fetch c2 into c2_rec;
        -- exit when c2%NOTFOUND;
        insert into tsnotfilled
        (yymm,emptype,assign,costname,hod,desc1,empno,name,doj,email,dol,PARENT)
        values
        (c_LOCKEDMNTH,c1_rec.emptype,c1_rec.assign,c1_rec.costname,c1_rec.hod,c1_rec.desc1,c1_rec.empno,c1_rec.name,c1_rec.doj,c1_rec.email,c1_rec.dol,C1_REC.PARENT) ;
        -- end loop;
        -- close c2;
        end loop;
        commit;
        close c1;
        commit;
    end insert_notfilled;

    Procedure get_proj_revcdate_proc(
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_projno          Varchar2,
        p_revcdate    Out     Varchar2
    )  As
        v_revcdate projmast.revcdate%Type;
    Begin
        Select
            revcdate
            into
            v_revcdate
        From
            projmast
        Where
           projno = Trim(p_projno);

        p_revcdate := v_revcdate;
    Exception
        When Others Then
            p_revcdate := Null;
    End get_proj_revcdate_proc;
End rap_reports_gen;


/
