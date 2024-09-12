--------------------------------------------------------
--  DDL for Package Body PKG_9794_TS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PKG_9794_TS" As

    Procedure update_time_sheet (
        param_empno Varchar2, param_hrs_csv Varchar2, param_pdate_hrs_csv Varchar2, param_yyyymm Varchar2, param_by_win_uid Varchar2
      , param_success Out Varchar2, param_message Out Varchar2
    ) As
        v_sum_hrs Number;
        v_count Number;
        v_by_empno Varchar2(5);
    Begin
        Begin
            v_by_empno   := pkg_09794.get_empno(param_by_win_uid);
            If v_by_empno Is Null Then
                param_success   := 'KO';
                param_message   := 'Err - Data Entry by EmpNo not found.';
                return;
            End If;
            --Check Supplied HRS are numeric

            Select
                Sum(sum_hrs)
              Into v_sum_hrs
              From
                ( Select
                      to_number(column_value) sum_hrs
                    From
                      Table ( ss.csv_to_table(param_hrs_csv) )
                );

        Exception
            When Others Then
                param_success   := 'KO';
                param_message   := 'Err - ' || sqlcode || ' - ' || sqlerrm;
                return;
        End;

        Delete From ss_9794_daily_ts_mast
         Where
            yyyymm   = param_yyyymm And empno    = param_empno;

        Delete From ss_9794_daily_ts
         Where
            To_Char(pdate, 'yyyymm')  = param_yyyymm and empno = param_empno;

        Insert Into ss_9794_daily_ts (
            empno, pdate, hrs
        )
            Select
                param_empno, To_Date(col_date, 'yyyymmdd'), to_number(col_hrs)
              From
                ( Select
                      substr(column_value, 1, 8) col_date, substr(column_value, 10) col_hrs
                    From
                      Table ( ss.csv_to_table(param_pdate_hrs_csv) )
                );

        Insert Into ss_9794_daily_ts_mast (
            empno, yyyymm, sum_hrs, modified_on, modified_by_empno
        )
            Select
                param_empno, param_yyyymm, Sum(hrs), Sysdate, v_by_empno
              From
                ss_9794_daily_ts
             Where
                empno                     = param_empno And To_Char(pdate, 'yyyymm')  = param_yyyymm;

        Commit;
        param_success   := 'OK';
        param_message   := 'TimeSheet Saved successfully';
    Exception
        When Others Then
            Rollback;
            param_success   := 'KO';
            param_message   := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_time_sheet;

    Procedure add_ts_period (
        param_period Varchar2, param_open Varchar2, param_by_win_uid Varchar2, param_success Out Varchar2, param_message Out Varchar2
    ) As
        v_count Number;
        v_date Date;
        v_by_empno Varchar2(5);
    Begin
        Begin
            v_date   := To_Date(param_period, 'mm-yyyy');
        Exception
            When Others Then
                param_success   := 'KO';
                param_message   := 'Err - Invalid date format';
                return;
        End;

        v_by_empno      := pkg_09794.get_empno(param_by_win_uid);
        If v_by_empno Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - Data Entry by EmpNo not found.';
            return;
        End If;

        Select
            Count(*)
          Into v_count
          From
            ss_9794_ts_period
         Where
            period   = To_Char(v_date, 'yyyymm');

        If v_count <> 0 Then
            param_success   := 'KO';
            param_message   := 'Err - Period already exists.';
            return;
        End If;

        Insert Into ss_9794_ts_period (
            period, is_open, modified_on, modified_by
        ) Values (
            To_Char(v_date, 'yyyymm'), param_open, Sysdate, v_by_empno
        );

        If param_open = 'OK' Then
            Update ss_9794_ts_period
               Set
                is_open = 'KO'
             Where
                period != To_Char(v_date, 'yyyymm') And is_open   = 'OK';

        End If;

        Commit;
        param_success   := 'OK';
        param_message   := 'Period successfully added.';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure edit_ts_period (
        param_period Varchar2, param_open Varchar2, param_by_win_uid Varchar2, param_success Out Varchar2, param_message Out Varchar2
    ) As
        v_count Number;
        v_date Date;
        v_by_empno Varchar2(5);
    Begin
        Begin
            v_date   := To_Date(param_period, 'yyyymm');
        Exception
            When Others Then
                param_success   := 'KO';
                param_message   := 'Err - Invalid date format';
                return;
        End;

        v_by_empno      := pkg_09794.get_empno(param_by_win_uid);
        If v_by_empno Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - Data Entry by EmpNo not found.';
            return;
        End If;

        Select
            Count(*)
          Into v_count
          From
            ss_9794_ts_period
         Where
            period   = To_Char(v_date, 'yyyymm');

        If v_count <> 1 Then
            param_success   := 'KO';
            param_message   := 'Err - Period not found in database.';
            return;
        End If;

        Update ss_9794_ts_period
           Set
            is_open = param_open
         Where
            period   = To_Char(v_date, 'yyyymm');

        If param_open = 'OK' Then
            Update ss_9794_ts_period
               Set
                is_open = 'KO'
             Where
                period != To_Char(v_date, 'yyyymm') And is_open   = 'OK';

        End If;

        Commit;
        param_success   := 'OK';
        param_message   := 'Period successfully updated.';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure summarize_ts (
        param_yyyymm Varchar2
    ) As

        Cursor emp_ts Is Select
                            empno
                          From
                            ss_9794_daily_ts_mast
                         Where
                            yyyymm   = param_yyyymm
                        Union
                        Select
                            empno
                          From
                            ss_9794_daily_ts
                         Where
                            To_Char(pdate, 'yyyymm')  = param_yyyymm;

        v_sum_hrs Number;
    Begin
        For c2 In emp_ts Loop
            Begin
                Select
                    Sum(hrs)
                  Into v_sum_hrs
                  From
                    ss_9794_daily_ts
                 Where
                    empno                     = c2.empno And To_Char(pdate, 'yyyymm')  = param_yyyymm;

            Exception
                When Others Then
                    v_sum_hrs   := 0;
            End;

            Begin
                Update ss_9794_daily_ts_mast
                   Set
                    sum_hrs = nvl(v_sum_hrs, 0)
                 Where
                    empno    = c2.empno And yyyymm   = param_yyyymm;

            Exception
                When Others Then
                    Insert Into ss_9794_daily_ts_mast (
                        empno, yyyymm, sum_hrs, modified_on, modified_by_empno
                    ) Values (
                        c2.empno, param_yyyymm, nvl(v_sum_hrs, 0), Sysdate, 'SYS'
                    );

            End;

        End Loop;
        commit;
    End;

End pkg_9794_ts;


/
