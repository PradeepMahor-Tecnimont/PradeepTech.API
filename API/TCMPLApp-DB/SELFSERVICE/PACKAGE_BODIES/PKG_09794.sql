--------------------------------------------------------
--  DDL for Package Body PKG_09794
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PKG_09794" As

    Procedure normalize_punch_data As
    Begin
        --return;
        Delete From ss_9794_punch_temp
        Where
            emp_code Not In (
                Select
                    Lpad(empno, 8, '0') emp_code
                From
                    ss_9794_emp_list
            );

        Commit;
        Delete From ss_9794_punch
        Where
            ( empno,
              pdate ) In (
                Select
                    Substr('00000000' || Trim(emp_code), - 5, 5),
                    Trunc(pdate)
                From
                    ss_9794_punch_temp
            );

        Commit;
        Insert Into ss_9794_punch (
            empno,
            hh,
            mm,
            pdate,
            dd,
            mon,
            yyyy,
            ss
        )
            Select
                Substr('00000000' || Trim(emp_code), - 5, 5),
                To_Char(pdate, 'hh24'),
                To_Char(pdate, 'mi'),
                Trunc(pdate),
                To_Char(pdate, 'dd'),
                To_Char(pdate, 'MM'),
                To_Char(pdate, 'yyyy'),
                To_Char(pdate, 'ss')
            From
                ss_9794_punch_temp;

        Commit;
    /*exception
    when others then null;*/
    End;

    Function emp_ts Return typ_tab_emp_ts
        Pipelined
    As

        Cursor cur_ts_4_9794 Is
        Select
            *
        From
            ss_9794_vu_ts;

        rec_emp_ts_singel_day        typ_rec_emp_ts_singel_day;
        rec_emp_ts_singel_day_null   typ_rec_emp_ts_singel_day;
        tbl_emp_ts                   typ_tab_emp_ts;
        Type typ_tbl_ts_9794 Is
            Table Of cur_ts_4_9794%rowtype Index By Pls_Integer;
        tbl_ts_p9794                 typ_tbl_ts_9794;
    Begin
    -- TODO: Implementation required for Function PKG_09794.emp_ts
        Open cur_ts_4_9794;
        Loop
            Fetch cur_ts_4_9794 Bulk Collect Into tbl_ts_p9794 Limit 50;
            For indx In 1..tbl_ts_p9794.count Loop
                rec_emp_ts_singel_day.empno    := tbl_ts_p9794(indx).empno;
                rec_emp_ts_singel_day.yyyymm   := tbl_ts_p9794(indx).yymm;
                --rec_emp_ts_singel_day.projno        := tbl_ts_p9794(indx).projno;
                If Nvl(tbl_ts_p9794(indx).d1, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '01', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d1;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d2, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '02', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d2;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d3, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '03', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d3;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d4, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '04', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d4;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d5, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '05', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d5;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d6, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '06', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d6;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d7, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '07', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d7;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d8, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '08', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d8;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d9, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '09', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d9;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d10, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '10', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d10;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d11, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '11', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d11;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d12, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '12', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d12;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d13, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '13', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d13;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d14, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '14', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d14;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d15, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '15', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d15;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d16, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '16', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d16;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d17, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '17', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d17;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d18, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '18', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d18;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d19, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '19', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d19;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d20, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '20', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d20;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d21, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '21', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d21;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d22, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '22', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d22;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d23, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '23', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d23;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d24, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '24', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d24;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d25, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '25', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d25;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d26, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '26', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d26;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d27, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '27', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d27;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d28, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '28', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d28;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d29, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '29', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d29;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d30, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '30', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d30;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d31, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date           := To_Date(tbl_ts_p9794(indx).yymm || '31', 'yyyymmdd');

                    rec_emp_ts_singel_day.work_hours        := tbl_ts_p9794(indx).d31;
                    rec_emp_ts_singel_day.first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                rec_emp_ts_singel_day          := rec_emp_ts_singel_day_null;
            End Loop;

            Exit When cur_ts_4_9794%notfound;
        End Loop;

    End emp_ts;

    Function emp_ts_4_month (
        param_yyyymm Varchar2
    ) Return typ_tab_emp_ts_ac
        Pipelined
    As

        Cursor cur_ts_4_9794 Is
        Select
            *
        From
            ss_9794_vu_ts
        Where
            yymm = param_yyyymm
        Order By
            empno;--and empno='03455';

        rec_emp_ts_singel_day        typ_rec_emp_ts_ac_singel_day;
        rec_emp_ts_singel_day_null   typ_rec_emp_ts_ac_singel_day;
        tbl_emp_ts                   typ_tab_emp_ts_ac;
        Type typ_tbl_ts_9794 Is
            Table Of cur_ts_4_9794%rowtype Index By Pls_Integer;
        tbl_ts_p9794                 typ_tbl_ts_9794;
    Begin
    -- TODO: Implementation required for Function PKG_09794.emp_ts
        Open cur_ts_4_9794;
        Loop
            Fetch cur_ts_4_9794 Bulk Collect Into tbl_ts_p9794 Limit 50;
            For indx In 1..tbl_ts_p9794.count Loop
                rec_emp_ts_singel_day.empno    := tbl_ts_p9794(indx).empno;
                rec_emp_ts_singel_day.yyyymm   := tbl_ts_p9794(indx).yymm;
                Select
                    name,
                    parent
                Into
                        rec_emp_ts_singel_day
                    .emp_name,
                    rec_emp_ts_singel_day.parent
                From
                    ss_emplmast
                Where
                    empno = rec_emp_ts_singel_day.empno;
                --rec_emp_ts_singel_day.projno        := tbl_ts_p9794(indx).projno;

                If Nvl(tbl_ts_p9794(indx).d1, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '01', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d1;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d2, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '02', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d2;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d3, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '03', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d3;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d4, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '04', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d4;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d5, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '05', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d5;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d6, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '06', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d6;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d7, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '07', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d7;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d8, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '08', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d8;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d9, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '09', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d9;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d10, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '10', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d10;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d11, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '11', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d11;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d12, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '12', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d12;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d13, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '13', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d13;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d14, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '14', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d14;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d15, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '15', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d15;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d16, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '16', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d16;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d17, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '17', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d17;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d18, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '18', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d18;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d19, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '19', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d19;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d20, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '20', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d20;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d21, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '21', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d21;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d22, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '22', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d22;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d23, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '23', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d23;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d24, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '24', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d24;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d25, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '25', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d25;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d26, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '26', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d26;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d27, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '27', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d27;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d28, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '28', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d28;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d29, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '29', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d29;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d30, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '30', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d30;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d31, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date              := To_Date(tbl_ts_p9794(indx).yymm || '31', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours             := tbl_ts_p9794(indx).d31;
                    rec_emp_ts_singel_day.ss_first_punch       := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch        := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_first_punch_sec   := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.ss_last_punch_sec    := get_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch       := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch        := get_access_control_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.bt_first_punch_sec   := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.bt_last_punch_sec    := get_access_control_punch_sec(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    rec_emp_ts_singel_day.ss_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.ss_last_punch_sec - rec_emp_ts_singel_day
                    .ss_first_punch_sec) / 60));

                    rec_emp_ts_singel_day.bt_work_hrs          := to_hrs(Trunc((rec_emp_ts_singel_day.bt_last_punch_sec - rec_emp_ts_singel_day
                    .bt_first_punch_sec) / 60));

                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                rec_emp_ts_singel_day          := rec_emp_ts_singel_day_null;
            End Loop;

            Exit When cur_ts_4_9794%notfound;
        End Loop;

    End emp_ts_4_month;

    Function get_emp_ts_4_month (
        param_empno Varchar2,
        param_yyyymm Varchar2
    ) Return typ_tab_emp_time_sheet
        Pipelined
    Is

        Cursor cur_ts_4_9794 Is
        Select
            *
        From
            ss_9794_vu_ts
        Where
            yymm = param_yyyymm
            And empno = param_empno;

        rec_emp_ts_singel_day        typ_rec_emp_timesheet;
        rec_emp_ts_singel_day_null   typ_rec_emp_timesheet;
        tbl_emp_ts                   typ_rec_emp_timesheet;
        Type typ_tbl_ts_9794 Is
            Table Of cur_ts_4_9794%rowtype Index By Pls_Integer;
        tbl_ts_p9794                 typ_tbl_ts_9794;
    Begin
        Open cur_ts_4_9794;
        Loop
            Fetch cur_ts_4_9794 Bulk Collect Into tbl_ts_p9794 Limit 50;
            For indx In 1..tbl_ts_p9794.count Loop
                rec_emp_ts_singel_day.empno    := tbl_ts_p9794(indx).empno;
                rec_emp_ts_singel_day.yyyymm   := tbl_ts_p9794(indx).yymm;
                If Nvl(tbl_ts_p9794(indx).d1, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '01', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d1;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d2, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '02', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d2;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d3, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '03', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d3;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d4, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '04', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d4;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d5, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '05', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d5;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d6, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '06', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d6;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d7, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '07', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d7;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d8, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '08', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d8;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d9, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '09', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d9;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d10, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '10', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d10;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d11, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '11', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d11;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d12, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '12', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d12;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d13, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '13', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d13;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d14, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '14', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d14;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d15, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '15', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d15;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d16, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '16', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d16;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d17, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '17', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d17;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d18, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '18', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d18;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d19, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '19', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d19;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d20, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '20', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d20;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d21, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '21', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d21;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d22, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '22', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d22;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d23, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '23', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d23;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d24, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '24', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d24;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d25, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '25', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d25;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d26, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '26', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d26;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d27, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '27', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d27;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d28, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '28', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d28;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d29, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '29', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d29;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d30, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '30', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d30;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If Nvl(tbl_ts_p9794(indx).d31, 0) > 0 Then
                    rec_emp_ts_singel_day.ts_date    := To_Date(tbl_ts_p9794(indx).yymm || '31', 'yyyymmdd');

                    rec_emp_ts_singel_day.ts_hours   := tbl_ts_p9794(indx).d31;
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                rec_emp_ts_singel_day          := rec_emp_ts_singel_day_null;
            End Loop;

            Exit When cur_ts_4_9794%notfound;
        End Loop;

    End;

    Function get_punch (
        param_empno         Varchar2,
        param_date          Date,
        param_first_punch   Varchar2
    ) Return Varchar2 As
        rec_punch_data   selfservice.ss_integratedpunch%rowtype;
        v_ret_val        Varchar2(13);
        v_count          Number;
    Begin
        Select
            Count(*)
        Into v_count
        From
            ss_integratedpunch
        Where
            empno = param_empno
            And pdate = param_date;

        If param_first_punch = 'OK' Then
            If v_count = 0 Then
                Return ' ';
            End If;
            Select
                *
            Into rec_punch_data
            From
                (
                    Select
                        *
                    From
                        selfservice.ss_integratedpunch
                    Where
                        empno = param_empno
                        And pdate = param_date
                    Order By
                        hh,
                        mm,
                        ss
                )
            Where
                Rownum = 1;

        Elsif param_first_punch = 'KO' Then
            If v_count < 2 Then
                Return ' ';
            End If;
            Select
                *
            Into rec_punch_data
            From
                (
                    Select
                        *
                    From
                        selfservice.ss_integratedpunch
                    Where
                        empno = param_empno
                        And pdate = param_date
                    Order By
                        hh Desc,
                        mm Desc,
                        ss Desc
                )
            Where
                Rownum = 1;

        Else
            Return '';
        End If;

        v_ret_val := To_Char(rec_punch_data.hh, 'FM00') || ':' || To_Char(rec_punch_data.mm, 'FM00') || ':' || To_Char(rec_punch_data
        .ss, 'FM00');

        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;

    Function get_access_control_punch (
        param_empno         Varchar2,
        param_date          Date,
        param_first_punch   Varchar2
    ) Return Varchar2 As
        rec_punch_data   ss_9794_punch%rowtype;
        v_ret_val        Varchar2(13);
        v_count          Number;
    Begin
        Select
            Count(*)
        Into v_count
        From
            ss_9794_punch
        Where
            empno = param_empno
            And pdate = param_date;

        If param_first_punch = 'OK' Then
            If v_count = 0 Then
                Return ' ';
            End If;
            Select
                *
            Into rec_punch_data
            From
                (
                    Select
                        *
                    From
                        ss_9794_punch
                    Where
                        empno = param_empno
                        And pdate = param_date
                    Order By
                        hh,
                        mm,
                        ss
                )
            Where
                Rownum = 1;

        Elsif param_first_punch = 'KO' Then
            If v_count < 2 Then
                Return ' ';
            End If;
            Select
                *
            Into rec_punch_data
            From
                (
                    Select
                        *
                    From
                        ss_9794_punch
                    Where
                        empno = param_empno
                        And pdate = param_date
                    Order By
                        hh Desc,
                        mm Desc,
                        ss Desc
                )
            Where
                Rownum = 1;

        Else
            Return '';
        End If;

        v_ret_val := To_Char(rec_punch_data.hh, 'FM00') || ':' || To_Char(rec_punch_data.mm, 'FM00') || ':' || To_Char(rec_punch_data
        .ss, 'FM00');

        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;

    Function get_punch_adjusted (
        param_empno         Varchar2,
        param_date          Date,
        param_first_punch   Varchar2
    ) Return Varchar2 As

        rec_punch_data   selfservice.ss_integratedpunch%rowtype;
        v_ret_val        Varchar2(13);
        v_ss             Number(6);
        v_random_num     Number(6);
    Begin
        If param_first_punch = 'OK' Then
            Select
                *
            Into rec_punch_data
            From
                (
                    Select
                        *
                    From
                        selfservice.ss_integratedpunch
                    Where
                        empno = param_empno
                        And pdate = param_date
                    Order By
                        hh,
                        mm,
                        ss
                )
            Where
                Rownum = 1;

            v_ss                := ( rec_punch_data.hh * 60 * 60 ) + ( rec_punch_data.mm * 60 ) + ( rec_punch_data.ss );

            v_random_num        := Round(dbms_random.Value(
                150,
                270
            )); -- 2.5min , 4.5min
            v_ss                := v_ss + v_random_num;
            rec_punch_data.hh   := Trunc(v_ss / 3600);
            rec_punch_data.mm   := Trunc(Mod(
                v_ss,
                3600
            ) / 60);
            rec_punch_data.ss   := Mod(
                Mod(
                    v_ss,
                    3600
                ),
                60
            );
        Elsif param_first_punch = 'KO' Then
            Select
                *
            Into rec_punch_data
            From
                (
                    Select
                        *
                    From
                        selfservice.ss_integratedpunch
                    Where
                        empno = param_empno
                        And pdate = param_date
                    Order By
                        hh Desc,
                        mm Desc,
                        ss Desc
                )
            Where
                Rownum = 1;

            v_ss                := ( rec_punch_data.hh * 60 * 60 ) + ( rec_punch_data.mm * 60 ) + ( rec_punch_data.ss );

            v_random_num        := Round(dbms_random.Value(
                150,
                270
            )); -- 2.5min , 4.5min
            v_ss                := v_ss - v_random_num;
            rec_punch_data.hh   := Trunc(v_ss / 3600);
            rec_punch_data.mm   := Trunc(Mod(
                v_ss,
                3600
            ) / 60);
            rec_punch_data.ss   := Mod(
                Mod(
                    v_ss,
                    3600
                ),
                60
            );
        Else
            Return '';
        End If;

        v_ret_val := To_Char(rec_punch_data.hh, 'FM00') || ':' || To_Char(rec_punch_data.mm, 'FM00') || ':' || To_Char(rec_punch_data
        .ss, 'FM00') || '.000';

        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;

    Function get_punch_tea (
        param_empno Varchar2,
        param_date Date
    ) Return Varchar2 As

        rec_punch_data   selfservice.ss_integratedpunch%rowtype;
        v_ret_val        Varchar2(50);
        v_ss             Number(6);
        v_random_num     Number(6);
    Begin
        Select
            *
        Into rec_punch_data
        From
            (
                Select
                    *
                From
                    selfservice.ss_integratedpunch
                Where
                    empno = param_empno
                    And pdate = param_date
                Order By
                    hh,
                    mm,
                    ss
            )
        Where
            Rownum = 1;

        v_ss                := ( rec_punch_data.hh * 60 * 60 ) + ( rec_punch_data.mm * 60 ) + ( rec_punch_data.ss );

        v_random_num        := Round(dbms_random.Value(
            5400,
            5400 + 900
        )); -- InTime + 1.5Hrs , InTime + 1.5Hrs + 15Mns
        v_ss                := v_ss + v_random_num;
        rec_punch_data.hh   := Trunc(v_ss / 3600);
        rec_punch_data.mm   := Trunc(Mod(
            v_ss,
            3600
        ) / 60);
        rec_punch_data.ss   := Mod(
            Mod(
                v_ss,
                3600
            ),
            60
        );

            --Out for Tea
        v_ret_val           := To_Char(rec_punch_data.hh, 'FM00') || ':' || To_Char(rec_punch_data.mm, 'FM00') || ':' || To_Char(rec_punch_data
        .ss, 'FM00') || '.000';

            --In From Tea

        v_random_num        := Round(dbms_random.Value(
            600,
            900
        )); -- 10Min , 15Min
        v_ss                := v_ss + v_random_num;
        rec_punch_data.hh   := Trunc(v_ss / 3600);
        rec_punch_data.mm   := Trunc(Mod(
            v_ss,
            3600
        ) / 60);
        rec_punch_data.ss   := Mod(
            Mod(
                v_ss,
                3600
            ),
            60
        );

            --Out - IN ffrom Tea
        v_ret_val           := v_ret_val || ' - ' || To_Char(rec_punch_data.hh, 'FM00') || ':' || To_Char(rec_punch_data.mm, 'FM00') --
         || ':' || To_Char(rec_punch_data.ss, 'FM00') || '.000';

        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;

    Function get_lunch (
        param_empno   Varchar2,
        param_date    Date,
        param_ok      Varchar2
    ) Return Varchar2 As

        rec_punch_data        selfservice.ss_integratedpunch%rowtype;
        v_ret_val             Varchar2(50);
        v_ss                  Number(6);
        v_random_num          Number(6);
        rec_punch_data_last   selfservice.ss_integratedpunch%rowtype;
        v_ss_last             Number(6);
    Begin
        Select
            *
        Into rec_punch_data
        From
            (
                Select
                    *
                From
                    selfservice.ss_integratedpunch
                Where
                    empno = param_empno
                    And pdate = param_date
                Order By
                    hh,
                    mm,
                    ss
            )
        Where
            Rownum = 1;

        Select
            *
        Into rec_punch_data_last
        From
            (
                Select
                    *
                From
                    selfservice.ss_integratedpunch
                Where
                    empno = param_empno
                    And pdate = param_date
                Order By
                    hh Desc,
                    mm Desc,
                    ss Desc
            )
        Where
            Rownum = 1;

        v_ss                := ( rec_punch_data.hh * 60 * 60 ) + ( rec_punch_data.mm * 60 ) + ( rec_punch_data.ss );

        v_ss_last           := ( rec_punch_data_last.hh * 60 * 60 ) + ( rec_punch_data_last.mm * 60 ) + ( rec_punch_data_last.ss );

        If v_ss_last - v_ss < 19000 Then
            Return '0';
        End If;
        v_random_num        := Round(dbms_random.Value(
            15300,
            15900
        )); -- InTime + 4.25Hrs , InTime + 1.5Hrs + 10Mns
        v_ss                := v_ss + v_random_num;
        rec_punch_data.hh   := Trunc(v_ss / 3600);
        rec_punch_data.mm   := Trunc(Mod(
            v_ss,
            3600
        ) / 60);
        rec_punch_data.ss   := Mod(
            Mod(
                v_ss,
                3600
            ),
            60
        );

            --Out for Lunch
        v_ret_val           := To_Char(rec_punch_data.hh, 'FM00') || ':' || To_Char(rec_punch_data.mm, 'FM00') || ':' || To_Char(rec_punch_data
        .ss, 'FM00') || '.000';

            --In From Lunch

        v_random_num        := Round(dbms_random.Value(
            2100,
            2700
        )); -- 35Min , 45Min
        v_ss                := v_ss + v_random_num;
        rec_punch_data.hh   := Trunc(v_ss / 3600);
        rec_punch_data.mm   := Trunc(Mod(
            v_ss,
            3600
        ) / 60);
        rec_punch_data.ss   := Mod(
            Mod(
                v_ss,
                3600
            ),
            60
        );

            --Out - IN ffrom Tea
        v_ret_val           := v_ret_val || ' - ' || To_Char(rec_punch_data.hh, 'FM00') || ':' || To_Char(rec_punch_data.mm, 'FM00') --
         || ':' || To_Char(rec_punch_data.ss, 'FM00') || '.000';

        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;

    Function get_evening_tea (
        param_empno   Varchar2,
        param_date    Date,
        param_ok      Varchar2
    ) Return Varchar2 As

        rec_punch_data        selfservice.ss_integratedpunch%rowtype;
        rec_punch_data_last   selfservice.ss_integratedpunch%rowtype;
        v_ret_val             Varchar2(50);
        v_ss                  Number(6);
        v_ss_last             Number(6);
        v_random_num          Number(6);
    Begin
        Select
            *
        Into rec_punch_data
        From
            (
                Select
                    *
                From
                    selfservice.ss_integratedpunch
                Where
                    empno = param_empno
                    And pdate = param_date
                Order By
                    hh,
                    mm,
                    ss
            )
        Where
            Rownum = 1;

        Select
            *
        Into rec_punch_data_last
        From
            (
                Select
                    *
                From
                    selfservice.ss_integratedpunch
                Where
                    empno = param_empno
                    And pdate = param_date
                Order By
                    hh Desc,
                    mm Desc,
                    ss Desc
            )
        Where
            Rownum = 1;

        v_ss                := ( rec_punch_data.hh * 60 * 60 ) + ( rec_punch_data.mm * 60 ) + ( rec_punch_data.ss );

        v_ss_last           := ( rec_punch_data_last.hh * 60 * 60 ) + ( rec_punch_data_last.mm * 60 ) + ( rec_punch_data_last.ss );

        If v_ss_last - v_ss < 25000 Then
            Return '0';
        End If;
        v_random_num        := Round(dbms_random.Value(
            23400,
            23400 + 600
        )); -- InTime + 6.5Hrs , InTime + 6.5Hrs + 10Mns
        v_ss                := v_ss + v_random_num;
        rec_punch_data.hh   := Trunc(v_ss / 3600);
        rec_punch_data.mm   := Trunc(Mod(
            v_ss,
            3600
        ) / 60);
        rec_punch_data.ss   := Mod(
            Mod(
                v_ss,
                3600
            ),
            60
        );

            --Out for Lunch
        v_ret_val           := To_Char(rec_punch_data.hh, 'FM00') || ':' || To_Char(rec_punch_data.mm, 'FM00') || ':' || To_Char(rec_punch_data
        .ss, 'FM00') || '.000';

            --In From Lunch

        v_random_num        := Round(dbms_random.Value(
            600,
            900
        )); -- 35Min , 45Min
        v_ss                := v_ss + v_random_num;
        rec_punch_data.hh   := Trunc(v_ss / 3600);
        rec_punch_data.mm   := Trunc(Mod(
            v_ss,
            3600
        ) / 60);
        rec_punch_data.ss   := Mod(
            Mod(
                v_ss,
                3600
            ),
            60
        );

            --Out - IN ffrom Tea
        v_ret_val           := v_ret_val || ' - ' || To_Char(rec_punch_data.hh, 'FM00') || ':' || To_Char(rec_punch_data.mm, 'FM00') --
         || ':' || To_Char(rec_punch_data.ss, 'FM00') || '.000';

        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;

    Function get_evening_break (
        param_empno   Varchar2,
        param_date    Date,
        param_ok      Varchar2
    ) Return Varchar2 As

        rec_punch_data        selfservice.ss_integratedpunch%rowtype;
        rec_punch_data_last   selfservice.ss_integratedpunch%rowtype;
        v_ret_val             Varchar2(50);
        v_ss                  Number(6);
        v_ss_last             Number(6);
        v_random_num          Number(6);
    Begin
        Select
            *
        Into rec_punch_data
        From
            (
                Select
                    *
                From
                    selfservice.ss_integratedpunch
                Where
                    empno = param_empno
                    And pdate = param_date
                Order By
                    hh,
                    mm,
                    ss
            )
        Where
            Rownum = 1;

        Select
            *
        Into rec_punch_data_last
        From
            (
                Select
                    *
                From
                    selfservice.ss_integratedpunch
                Where
                    empno = param_empno
                    And pdate = param_date
                Order By
                    hh Desc,
                    mm Desc,
                    ss Desc
            )
        Where
            Rownum = 1;

        v_ss                := ( rec_punch_data.hh * 60 * 60 ) + ( rec_punch_data.mm * 60 ) + ( rec_punch_data.ss );

        v_ss_last           := ( rec_punch_data_last.hh * 60 * 60 ) + ( rec_punch_data_last.mm * 60 ) + ( rec_punch_data_last.ss );

        If v_ss_last - v_ss < 25000 Then
            Return '0';
        End If;
        v_random_num        := Round(dbms_random.Value(
            26100,
            26100 + 600
        )); -- InTime + 6.5Hrs , InTime + 6.5Hrs + 10Mns
        v_ss                := v_ss + v_random_num;
        rec_punch_data.hh   := Trunc(v_ss / 3600);
        rec_punch_data.mm   := Trunc(Mod(
            v_ss,
            3600
        ) / 60);
        rec_punch_data.ss   := Mod(
            Mod(
                v_ss,
                3600
            ),
            60
        );

            --Out for Lunch
        v_ret_val           := To_Char(rec_punch_data.hh, 'FM00') || ':' || To_Char(rec_punch_data.mm, 'FM00') || ':' || To_Char(rec_punch_data
        .ss, 'FM00') || '.000';

            --In From Lunch

        v_random_num        := Round(dbms_random.Value(
            540,
            780
        )); -- 9Min , 13Min
        v_ss                := v_ss + v_random_num;
        rec_punch_data.hh   := Trunc(v_ss / 3600);
        rec_punch_data.mm   := Trunc(Mod(
            v_ss,
            3600
        ) / 60);
        rec_punch_data.ss   := Mod(
            Mod(
                v_ss,
                3600
            ),
            60
        );

            --Out - IN ffrom Tea
        v_ret_val           := v_ret_val || ' - ' || To_Char(rec_punch_data.hh, 'FM00') || ':' || To_Char(rec_punch_data.mm, 'FM00') --
         || ':' || To_Char(rec_punch_data.ss, 'FM00') || '.000';

        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;

    Function get_afternoon_break (
        param_empno   Varchar2,
        param_date    Date,
        param_ok      Varchar2
    ) Return Varchar2 As

        rec_punch_data        selfservice.ss_integratedpunch%rowtype;
        rec_punch_data_last   selfservice.ss_integratedpunch%rowtype;
        v_ret_val             Varchar2(50);
        v_ss                  Number(6);
        v_ss_last             Number(6);
        v_random_num          Number(6);
    Begin
        Select
            *
        Into rec_punch_data
        From
            (
                Select
                    *
                From
                    selfservice.ss_integratedpunch
                Where
                    empno = param_empno
                    And pdate = param_date
                Order By
                    hh,
                    mm,
                    ss
            )
        Where
            Rownum = 1;

        Select
            *
        Into rec_punch_data_last
        From
            (
                Select
                    *
                From
                    selfservice.ss_integratedpunch
                Where
                    empno = param_empno
                    And pdate = param_date
                Order By
                    hh Desc,
                    mm Desc,
                    ss Desc
            )
        Where
            Rownum = 1;

        v_ss                := ( rec_punch_data.hh * 60 * 60 ) + ( rec_punch_data.mm * 60 ) + ( rec_punch_data.ss );

        v_ss_last           := ( rec_punch_data_last.hh * 60 * 60 ) + ( rec_punch_data_last.mm * 60 ) + ( rec_punch_data_last.ss );

        If v_ss_last - v_ss < 25000 Then
            Return '0';
        End If;
        v_random_num        := Round(dbms_random.Value(
            9000,
            9000 + 600
        )); -- InTime + 6.5Hrs , InTime + 6.5Hrs + 10Mns
        v_ss                := v_ss + v_random_num;
        rec_punch_data.hh   := Trunc(v_ss / 3600);
        rec_punch_data.mm   := Trunc(Mod(
            v_ss,
            3600
        ) / 60);
        rec_punch_data.ss   := Mod(
            Mod(
                v_ss,
                3600
            ),
            60
        );

            --Out for Lunch
        v_ret_val           := To_Char(rec_punch_data.hh, 'FM00') || ':' || To_Char(rec_punch_data.mm, 'FM00') || ':' || To_Char(rec_punch_data
        .ss, 'FM00') || '.000';

            --In From Lunch

        v_random_num        := Round(dbms_random.Value(
            540,
            780
        )); -- 9Min , 13Min
        v_ss                := v_ss + v_random_num;
        rec_punch_data.hh   := Trunc(v_ss / 3600);
        rec_punch_data.mm   := Trunc(Mod(
            v_ss,
            3600
        ) / 60);
        rec_punch_data.ss   := Mod(
            Mod(
                v_ss,
                3600
            ),
            60
        );

            --Out - IN ffrom Tea
        v_ret_val           := v_ret_val || ' - ' || To_Char(rec_punch_data.hh, 'FM00') || ':' || To_Char(rec_punch_data.mm, 'FM00') --
         || ':' || To_Char(rec_punch_data.ss, 'FM00') || '.000';

        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;

    Function get_empno (
        param_username Varchar2
    ) Return Varchar2 As

        v_empno         Varchar2(5);
        v_ret_val       Varchar2(60);
        v_emp_count     Number;
        v_user_domain   Varchar2(30);
        v_user_id       Varchar2(30);
    Begin
        v_user_domain   := Substr(param_username, 1, Instr(param_username, '\') - 1);

        v_user_id       := Substr(param_username, Instr(param_username, '\') + 1);
        Select
            a.empno
        Into v_empno
        From
            userids       a,
            ss_emplmast   b
        Where
            a.empno = b.empno
            And userid    = Upper(Trim(v_user_id))
            And domain    = Upper(Trim(v_user_domain))
            And b.status  = 1;

        If v_empno = '02320' Then
            --v_empno := '01773';
            v_empno := '02320';
        End If;
        v_ret_val       := v_empno;
        Return v_ret_val;
    Exception
        When Others Then
            Return 'NONE';
    End get_empno;
 /*=======================================================================*/

    Function check_user_in_role (
        param_username Varchar2,
        param_role Varchar2
    ) Return Varchar2 As

        v_empno       Varchar2(5) := 'XXZZ!';
        v_count       Number;
        v_ret_val     Varchar2(10);
        v_emp_found   Number := 1;
    Begin
        Begin
            Select
                a.empno
            Into v_empno
            From
                userids       a,
                ss_emplmast   b
            Where
                a.empno = b.empno
                And userid    = Upper(Trim(Substr(param_username, 6, 50)))
                And domain    = Upper(Substr(param_username, 1, 4))
                And b.status  = 1;

        Exception
            When Others Then
                Return 'FALSE';
        End;

        If ( Nvl(v_empno, 'XXZZ!') != 'XXZZ!' ) Then
            Select
                Count(*)
            Into v_count
            From
                ss_emplmast
            Where
                empno = v_empno
                And status = 1;

            If ( v_count > 0 ) Then
                v_emp_found := 1;
            End If;
        Else
            v_emp_found := 0;
        End If;
    /*-GENSE
HR
AFC
CONSTLOG
PROJECTS-*/

        If ( v_emp_found = 1 ) Then
            If ( param_role = 'GENSE' ) Then
                Select
                    Count(*)
                Into v_count
                From
                    ss_9794_emp_roles
                Where
                    empno = v_empno;

                If ( v_count > 0 ) Then
                    v_ret_val := 'TRUE';
                    Return v_ret_val;
                Else
                    v_ret_val := 'FALSE';
                    Return v_ret_val;
                End If;

            Elsif ( param_role = 'HR' ) Then
                Select
                    Count(*)
                Into v_count
                From
                    ss_9794_emp_roles
                Where
                    empno = v_empno;

                If ( v_count > 0 ) Then
                    v_ret_val := 'TRUE';
                    Return v_ret_val;
                Else
                    v_ret_val := 'FALSE';
                    Return v_ret_val;
                End If;

            Elsif ( param_role = 'PROJECTS' ) Then
                Select
                    Count(*)
                Into v_count
                From
                    ss_9794_emp_roles
                Where
                    empno = v_empno;

                If ( v_count > 0 ) Then
                    v_ret_val := 'TRUE';
                    Return v_ret_val;
                Else
                    v_ret_val := 'FALSE';
                    Return v_ret_val;
                End If;

            Elsif ( param_role = 'CONSTLOG' ) Then
                Select
                    Count(*)
                Into v_count
                From
                    ss_9794_emp_roles
                Where
                    empno = v_empno;

                If ( v_count > 0 ) Then
                    v_ret_val := 'TRUE';
                    Return v_ret_val;
                Else
                    v_ret_val := 'FALSE';
                    Return v_ret_val;
                End If;

            Elsif ( param_role = 'AFC' ) Then
                Select
                    Count(*)
                Into v_count
                From
                    ss_9794_emp_roles
                Where
                    empno = v_empno;

                If ( v_count > 0 ) Then
                    v_ret_val := 'TRUE';
                    Return v_ret_val;
                Else
                    v_ret_val := 'FALSE';
                    Return v_ret_val;
                End If;

            Else
                v_ret_val := 'Role Not Found';
                Return v_ret_val;
            End If;
        End If;

    Exception
        When Others Then
            Return 'Error - ' || Sqlcode || ' -- ' || Sqlerrm;
    End check_user_in_role;
/*=======================================================================*/

    Function get_role_for_user (
        param_username Varchar2
    ) Return Varchar2 As

        v_empno       Varchar2(5);
        v_count       Number;
        v_ret_val     Varchar2(2100);
        v_emp_count   Number;
        v_csv_roles   Varchar2(2000);
    Begin
        v_empno     := get_empno(param_username);
        If v_empno = 'NONE' Then
            Return 'None';
        End If;
        With emp_list As (
            Select
                empno
            From
                ss_9794_emp_list
            Union
            Select
                empno
            From
                ss_9794_emp_roles
        )
        Select
            Count(b.empno)
        Into v_emp_count
        From
            ss_emplmast   b,
            emp_list      c
        Where
            b.empno = v_empno
            And b.empno   = c.empno
            And b.status  = 1;
        if v_emp_count > 0 Then
            v_ret_val := '9794User';
        end if;
        Select
            Count(*)
        Into v_count
        From
            ss_costmast
        Where
            hod = v_empno;

        If v_ret_val Is Not Null and v_count > 0 Then
            v_ret_val := v_ret_val || ',HOD';
        --Else
            --v_ret_val := 'HOD';
        End If;

        --
        If v_emp_count = 0 And v_count = 0 Then
            Select
                Count(*)
            Into v_emp_count
            From
                ss_9794_emp_roles
            Where
                empno = get_empno(param_username);

            If v_emp_count = 0 Then
                Return 'NONE';
            End If;
        End If;


        Begin
            Select
                csv
            Into v_csv_roles
            From
                (
                    Select
                        Substr(sys_connect_by_path(
                            role_name,
                            ','
                        ), 2) csv
                    From
                        (
                            Select
                                role_name,
                                Row_Number() Over(
                                    Order By
                                        role_name
                                ) rn,
                                Count(*) Over() cnt
                            From
                                (
                                    Select Distinct
                                        b.role_name
                                    From
                                        ss_9794_emp_roles     a,
                                        ss_9794_role_master   b
                                    Where
                                        a.role_id = b.role_id
                                        And empno = v_empno
                                )
                        )
                    Where
                        rn = cnt
                    Start With
                        rn = 1
                    Connect By
                        rn = Prior rn + 1
                );

        Exception
            When Others Then
                v_csv_roles := '';
        End;

        v_ret_val   := v_ret_val || ',' || v_csv_roles;
        Return Trim(Both ',' From v_ret_val);
    Exception
        When Others Then
            Return 'Error - ' || Sqlcode || ' -- ' || Sqlerrm;
    End get_role_for_user;
/*=======================================================================*/

    Function get_emp_name (
        param_empno Varchar2
    ) Return Varchar2 As
        v_ret_val   Varchar2(2000);
        v_count     Number;
    Begin
        Select
            Count(name)
        Into v_count
        From
            ss_emplmast
        Where
            empno = Upper(param_empno)
            And status = 1;

        If ( v_count > 0 ) Then
            Select
                name
            Into v_ret_val
            From
                ss_emplmast
            Where
                empno = Upper(param_empno)
                And status = 1;

            If ( v_ret_val = Null ) Then
                v_ret_val := 'Error';
            End If;
            Return v_ret_val;
        Else
            Return 'Error';
        End If;

    Exception
        When Others Then
            Return 'Error - ' || Sqlcode || ' -- ' || Sqlerrm;
    End get_emp_name;

    Function get_work_hrs_char (
        param_empno Varchar2,
        param_date Date
    ) Return Varchar2 Is
        v_count         Number;
        v_wrk_hrs_num   Number;
        v_ret_val       Varchar2(10);
    Begin
        If Trim(param_empno) Is Null Then
            Return Null;
        End If;
        v_wrk_hrs_num   := get_work_hrs_num(
            param_empno,
            param_date
        );
        If Nvl(v_wrk_hrs_num, 0) = 0 Then
            Return Null;
        End If;
        v_ret_val       := to_hrs(v_wrk_hrs_num);
        Return v_ret_val;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_work_hrs_num (
        param_empno Varchar2,
        param_date Date
    ) Return Number Is
        v_count           Number;
        rec_first_punch   ss_9794_punch%rowtype;
        rec_last_punch    ss_9794_punch%rowtype;
        v_worked_min      Number;
    Begin
        If Trim(param_empno) Is Null Then
            Return Null;
        End If;
        Select
            Count(*)
        Into v_count
        From
            ss_9794_punch
        Where
            empno = param_empno
            And pdate = Trunc(param_date);

        If v_count < 1 Then
            Return Null;
        End If;
        Select
            *
        Into rec_first_punch
        From
            (
                Select
                    *
                From
                    ss_9794_punch
                Where
                    empno = param_empno
                    And pdate = param_date
                Order By
                    hh,
                    mm,
                    ss
            )
        Where
            Rownum = 1;

        Select
            *
        Into rec_last_punch
        From
            (
                Select
                    *
                From
                    ss_9794_punch
                Where
                    empno = param_empno
                    And pdate = param_date
                Order By
                    hh Desc,
                    mm Desc,
                    ss Desc
            )
        Where
            Rownum = 1;

        v_worked_min := ( ( rec_last_punch.hh * 60 ) + rec_last_punch.mm ) - ( ( rec_first_punch.hh * 60 ) + rec_first_punch.mm )
        ;

        Return v_worked_min;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_punch_sec (
        param_empno         Varchar2,
        param_date          Date,
        param_first_punch   Varchar2
    ) Return Number As
        rec_punch_data   selfservice.ss_integratedpunch%rowtype;
        v_ret_val        Number;
        v_count          Number;
    Begin
        Select
            Count(*)
        Into v_count
        From
            ss_integratedpunch
        Where
            empno = param_empno
            And pdate = param_date;

        If param_first_punch = 'OK' Then
            If v_count = 0 Then
                Return ' ';
            End If;
            Select
                *
            Into rec_punch_data
            From
                (
                    Select
                        *
                    From
                        selfservice.ss_integratedpunch
                    Where
                        empno = param_empno
                        And pdate = param_date
                    Order By
                        hh,
                        mm,
                        ss
                )
            Where
                Rownum = 1;

        Elsif param_first_punch = 'KO' Then
            If v_count < 2 Then
                Return ' ';
            End If;
            Select
                *
            Into rec_punch_data
            From
                (
                    Select
                        *
                    From
                        selfservice.ss_integratedpunch
                    Where
                        empno = param_empno
                        And pdate = param_date
                    Order By
                        hh Desc,
                        mm Desc,
                        ss Desc
                )
            Where
                Rownum = 1;

        Else
            Return '';
        End If;

        v_ret_val := ( rec_punch_data.hh * 60 * 60 ) + ( rec_punch_data.mm * 60 ) + rec_punch_data.ss;

        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;

    Function get_access_control_punch_sec (
        param_empno         Varchar2,
        param_date          Date,
        param_first_punch   Varchar2
    ) Return Number As
        rec_punch_data   ss_9794_punch%rowtype;
        v_ret_val        Number;
        v_count          Number;
    Begin
        Select
            Count(*)
        Into v_count
        From
            ss_9794_punch
        Where
            empno = param_empno
            And pdate = param_date;

        If param_first_punch = 'OK' Then
            If v_count = 0 Then
                Return ' ';
            End If;
            Select
                *
            Into rec_punch_data
            From
                (
                    Select
                        *
                    From
                        ss_9794_punch
                    Where
                        empno = param_empno
                        And pdate = param_date
                    Order By
                        hh,
                        mm,
                        ss
                )
            Where
                Rownum = 1;

        Elsif param_first_punch = 'KO' Then
            If v_count < 2 Then
                Return ' ';
            End If;
            Select
                *
            Into rec_punch_data
            From
                (
                    Select
                        *
                    From
                        ss_9794_punch
                    Where
                        empno = param_empno
                        And pdate = param_date
                    Order By
                        hh Desc,
                        mm Desc,
                        ss Desc
                )
            Where
                Rownum = 1;

        Else
            Return '';
        End If;

        --v_ret_val   := To_Char(rec_punch_data.hh, 'FM00') ||':' ||To_Char(rec_punch_data.mm, 'FM00') ||':' ||To_Char(rec_punch_data.ss, 'FM00');

        v_ret_val := ( rec_punch_data.hh * 60 * 60 ) + ( rec_punch_data.mm * 60 ) + rec_punch_data.ss;

        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;

    Function get_bt_work_hrs_actual (
        param_empno Varchar2,
        param_date Date
    ) Return Number Is

        v_count      Number;
        v_tot_mns    Number;
        v_in_time    Number;
        v_out_time   Number;
        v_row_num    Number;
        Cursor c1 Is
        Select
            *
        From
            ss_9794_punch
        Where
            empno = param_empno
            And pdate = param_date
        Order By
            hh,
            mm,
            ss;

    Begin
        Select
            Count(*)
        Into v_count
        From
            ss_9794_punch
        Where
            empno = param_empno
            And pdate = param_date;

        If v_count = 0 Or Mod(
            v_count,
            2
        ) <> 0 Then
            Return Null;
        End If;

        v_row_num    := 0;
        v_in_time    := 0;
        v_out_time   := 0;
        v_tot_mns    := 0;
        For c2 In c1 Loop
            v_row_num := v_row_num + 1;
            If Mod(
                v_row_num,
                2
            ) <> 0 Then
                v_in_time := ( c2.hh * 60 ) + c2.mm;
            Else
                v_out_time   := ( c2.hh * 60 ) + c2.mm;
                v_tot_mns    := v_tot_mns + ( v_out_time - v_in_time );
            End If;

        End Loop;

        Return v_tot_mns;
    End get_bt_work_hrs_actual;

End pkg_09794;


/
