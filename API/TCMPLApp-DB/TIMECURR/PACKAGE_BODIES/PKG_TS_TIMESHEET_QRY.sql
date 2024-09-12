Create Or Replace Package Body "TIMECURR"."PKG_TS_TIMESHEET_QRY" As

    Procedure sp_get_timesheet (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_empno        Varchar2 Default Null,
        p_yymm         Varchar2,
        p_costcode     Varchar2,
        p_parent       Out Varchar2,
        p_locked       Out Number,
        p_approved     Out Number,
        p_posted       Out Number,
        p_appr_on      Out Date,
        p_grp          Out Varchar2,
        p_tot_nhr      Out Number,
        p_tot_ohr      Out Number,
        p_company      Out Varchar2,
        p_remark       Out Varchar2,
        p_exceed       Out Number,
        p_status       Out Varchar2,
        p_time_daily   Out Sys_Refcursor,
        p_time_ot      Out Sys_Refcursor,
        p_holidays     Out Sys_Refcursor,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            parent,
            locked,
            approved,
            posted,
            appr_on,
            grp,
            tot_nhr,
            tot_ohr,
            company,
            remark,
            exceed
          Into
            p_parent,
            p_locked,
            p_approved,
            p_posted,
            p_appr_on,
            p_grp,
            p_tot_nhr,
            p_tot_ohr,
            p_company,
            p_remark,
            p_exceed
          From
            time_mast
         Where
                assign = Trim(p_costcode)
               And empno = Trim(nvl(
                p_empno,
                v_empno
            ))
               And yymm  = Trim(p_yymm);

        If nvl(
              p_posted,
              0
           ) = 1 Then
            p_status := 'Posted';
        Elsif nvl(
                 p_approved,
                 0
              ) = 1 Then
            p_status := 'Approved';
        Elsif nvl(
                 p_locked,
                 0
              ) = 1 Then
            p_status := 'Locked';
        Else
            p_status := 'Unlocked';
        End If;

        Open p_time_daily For Select
                                                      *
                                                    From
                                                      time_daily
                              Where
                                     assign = Trim(p_costcode)
                                    And empno = Trim(nvl(
                                     p_empno,
                                     v_empno
                                 ))
                                    And yymm  = Trim(p_yymm)
                              Order By
                                 projno,
                                 wpcode,
                                 activity;

        Open p_time_ot For Select
                                                *
                                              From
                                                time_ot
                           Where
                                  assign = Trim(p_costcode)
                                 And empno = Trim(nvl(
                                  p_empno,
                                  v_empno
                              ))
                                 And yymm  = Trim(p_yymm)
                           Order By
                              projno,
                              wpcode,
                              activity;
                              
        rap_timesheet.get_holidays(p_yyyymm    => p_yymm,
                                   p_dayslist  => p_holidays);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End;

    Function fn_get_timesheet_costcode_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null,
        p_yymm      Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Return Null;
        End If;
        Open c For Select
                                  c.costcode                    data_value_field,
                                  c.costcode || ' - ' || c.name data_text_field
                                From
                                  time_mast tm,
                                  costmast  c
                    Where
                           c.costcode = tm.assign
                          And tm.empno = Trim(nvl(
                           p_empno,
                           v_empno
                       ))
                          And tm.yymm  = Trim(p_yymm)
                    Order By
                       1;

        Return c;
    End;

End pkg_ts_timesheet_qry;