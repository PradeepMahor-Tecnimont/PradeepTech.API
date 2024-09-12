--------------------------------------------------------
--  DDL for Package Body PKG_09794
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."PKG_09794" As

    Function emp_ts Return typ_tab_emp_ts
        Pipelined
    As

        Cursor cur_ts_4_9794 Is
            Select *
            From nhrs9794;

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
                rec_emp_ts_singel_day.empno         := tbl_ts_p9794(indx).empno;
                rec_emp_ts_singel_day.yyyymm        := tbl_ts_p9794(indx).yymm;
                rec_emp_ts_singel_day.projno        := tbl_ts_p9794(indx).projno;
                If nvl(
                    tbl_ts_p9794(indx).d1,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'01',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d1;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d2,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'02',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d2;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d3,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'03',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d3;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d4,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'04',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d4;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d5,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'05',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d5;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d6,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'06',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d6;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d7,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'07',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d7;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d8,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'08',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d8;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d9,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'09',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d9;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d10,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'10',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d10;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d11,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'11',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d11;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d12,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'12',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d12;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d13,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'13',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d13;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d14,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'14',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d14;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d15,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'15',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d15;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d16,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'16',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d16;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d17,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'17',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d17;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d18,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'18',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d18;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d19,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'19',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d19;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d20,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'20',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d20;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d21,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'21',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d21;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d22,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'22',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d22;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d23,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'23',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d23;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d24,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'24',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d24;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d25,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'25',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d25;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d26,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'26',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d26;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d27,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'27',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d27;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d28,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'28',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d28;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d29,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'29',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d29;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d30,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'30',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d30;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                If nvl(
                    tbl_ts_p9794(indx).d31,
                    0
                ) > 0 Then
                    rec_emp_ts_singel_day.ts_date       := To_Date(
                        tbl_ts_p9794(indx).yymm ||'31',
                        'yyyymmdd'
                    );

                    rec_emp_ts_singel_day.work_hours    := tbl_ts_p9794(indx).d31;
                    rec_emp_ts_singel_day.first_punch   := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'OK'
                    );
                    rec_emp_ts_singel_day.last_punch    := get_punch(
                        rec_emp_ts_singel_day.empno,
                        rec_emp_ts_singel_day.ts_date,
                        'KO'
                    );
                    Pipe Row ( rec_emp_ts_singel_day );
                End If;

                rec_emp_ts_singel_day               := rec_emp_ts_singel_day_null;
            End Loop;

            Exit When cur_ts_4_9794%notfound;
        End Loop;

    End emp_ts;

    Function get_punch (
        param_empno         Varchar2,
        param_date          Date,
        param_first_punch   Varchar2
    ) Return Varchar2 As
        rec_punch_data   selfservice.ss_integratedpunch%rowtype;
        v_ret_val        Varchar2(13);
    Begin
        If param_first_punch = 'OK' Then
            Select *
            Into
                rec_punch_data
            From (
                    Select *
                    From selfservice.ss_integratedpunch
                    Where empno   = param_empno
                        And pdate   = param_date
                    Order By hh, mm, ss
                )
            Where Rownum = 1;
            
            
        Elsif param_first_punch = 'KO' Then
            Select *
            Into
                rec_punch_data
            From (
                    Select *
                    From selfservice.ss_integratedpunch
                    Where empno   = param_empno
                        And pdate   = param_date
                    Order By
                        hh Desc,
                        mm Desc,
                        ss Desc
                )
            Where Rownum = 1;

        Else
            Return '';
        End If;

        v_ret_val   := To_Char(rec_punch_data.hh, 'FM00') ||':' ||To_Char(rec_punch_data.mm, 'FM00') ||':' ||To_Char(rec_punch_data.ss, 'FM00') ||'.000';

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
        v_ss number(6);
        v_random_num number(6);
    Begin
        If param_first_punch = 'OK' Then
            Select *
            Into
                rec_punch_data
            From (
                    Select *
                    From selfservice.ss_integratedpunch
                    Where empno   = param_empno
                        And pdate   = param_date
                    Order By hh, mm, ss
                )
            Where Rownum = 1;
            
            v_ss := ( rec_punch_data.hh * 60 * 60) + ( rec_punch_data.mm * 60) + ( rec_punch_data.ss);
            v_random_num := round(dbms_random.value(150,270)); -- 2.5min , 4.5min
            v_ss := v_ss + v_random_num;
            
            rec_punch_data.hh := trunc(v_ss / 3600 );
            rec_punch_data.mm := trunc(mod(v_ss , 3600)/60 );
            rec_punch_data.ss := mod(mod(v_ss , 3600),60 );
            
        Elsif param_first_punch = 'KO' Then
            Select *
            Into
                rec_punch_data
            From (
                    Select *
                    From selfservice.ss_integratedpunch
                    Where empno   = param_empno
                        And pdate   = param_date
                    Order By
                        hh Desc,
                        mm Desc,
                        ss Desc
                )
            Where Rownum = 1;
            v_ss := ( rec_punch_data.hh * 60 * 60) + ( rec_punch_data.mm * 60) + ( rec_punch_data.ss);
            v_random_num := round(dbms_random.value(150,270)); -- 2.5min , 4.5min
            v_ss := v_ss - v_random_num;
            
            rec_punch_data.hh := trunc(v_ss / 3600 );
            rec_punch_data.mm := trunc(mod(v_ss , 3600)/60 );
            rec_punch_data.ss := mod(mod(v_ss , 3600),60 );
            

        Else
            Return '';
        End If;

        v_ret_val   := To_Char(rec_punch_data.hh, 'FM00') ||':' ||To_Char(rec_punch_data.mm, 'FM00') ||':' ||To_Char(rec_punch_data.ss, 'FM00') ||'.000';

        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;

    Function get_punch_tea(
        param_empno         Varchar2,
        param_date          Date
    ) Return Varchar2 As
        rec_punch_data   selfservice.ss_integratedpunch%rowtype;
        v_ret_val        Varchar2(50);
        v_ss number(6);
        v_random_num number(6);
    Begin
        
            Select *
            Into
                rec_punch_data
            From (
                    Select *
                    From selfservice.ss_integratedpunch
                    Where empno   = param_empno
                        And pdate   = param_date
                    Order By hh, mm, ss
                )
            Where Rownum = 1;
            
            v_ss := ( rec_punch_data.hh * 60 * 60) + ( rec_punch_data.mm * 60) + ( rec_punch_data.ss);
            v_random_num := round(dbms_random.value(5400,5400 + 900)); -- InTime + 1.5Hrs , InTime + 1.5Hrs + 15Mns
            v_ss := v_ss + v_random_num;
            
            rec_punch_data.hh := trunc(v_ss / 3600 );
            rec_punch_data.mm := trunc(mod(v_ss , 3600)/60 );
            rec_punch_data.ss := mod(mod(v_ss , 3600),60 );
            
            --Out for Tea
            v_ret_val   := To_Char(rec_punch_data.hh, 'FM00') ||':' ||To_Char(rec_punch_data.mm, 'FM00') ||':' ||To_Char(rec_punch_data.ss, 'FM00') ||'.000';

            --In From Tea
            v_random_num := round(dbms_random.value(600,900)); -- 10Min , 15Min
            v_ss := v_ss + v_random_num;
            
            rec_punch_data.hh := trunc(v_ss / 3600 );
            rec_punch_data.mm := trunc(mod(v_ss , 3600)/60 );
            rec_punch_data.ss := mod(mod(v_ss , 3600),60 );
            
            --Out - IN ffrom Tea
            v_ret_val   := v_ret_val   || ' - ' || To_Char(rec_punch_data.hh, 'FM00') ||':' ||To_Char(rec_punch_data.mm, 'FM00') ||':' ||To_Char(rec_punch_data.ss, 'FM00') ||'.000';
        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;

    Function get_lunch(
        param_empno         Varchar2,
        param_date          Date,
        param_ok            varchar2
    ) Return Varchar2 As
        rec_punch_data   selfservice.ss_integratedpunch%rowtype;
        v_ret_val        Varchar2(50);
        v_ss number(6);
        v_random_num number(6);
        rec_punch_data_last   selfservice.ss_integratedpunch%rowtype;
        v_ss_last number(6);
    Begin
        
            Select *
            Into
                rec_punch_data
            From (
                    Select *
                    From selfservice.ss_integratedpunch
                    Where empno   = param_empno
                        And pdate   = param_date
                    Order By hh, mm, ss
                )
            Where Rownum = 1;



            Select *
            Into
                rec_punch_data_last
            From (
                    Select *
                    From selfservice.ss_integratedpunch
                    Where empno   = param_empno
                        And pdate   = param_date
                    Order By hh desc, mm desc, ss desc
                )
            Where Rownum = 1;

            v_ss := ( rec_punch_data.hh * 60 * 60) + ( rec_punch_data.mm * 60) + ( rec_punch_data.ss);
            v_ss_last := ( rec_punch_data_last.hh * 60 * 60) + ( rec_punch_data_last.mm * 60) + ( rec_punch_data_last.ss);
            if v_ss_last - v_ss < 19000 Then
                return '0';
            End If;

            v_random_num := round(dbms_random.value(15300,15900)); -- InTime + 4.25Hrs , InTime + 1.5Hrs + 10Mns
            v_ss := v_ss + v_random_num;
            
            rec_punch_data.hh := trunc(v_ss / 3600 );
            rec_punch_data.mm := trunc(mod(v_ss , 3600)/60 );
            rec_punch_data.ss := mod(mod(v_ss , 3600),60 );
            
            --Out for Lunch
            v_ret_val   := To_Char(rec_punch_data.hh, 'FM00') ||':' ||To_Char(rec_punch_data.mm, 'FM00') ||':' ||To_Char(rec_punch_data.ss, 'FM00') ||'.000';

            --In From Lunch
            v_random_num := round(dbms_random.value(2100,2700)); -- 35Min , 45Min
            v_ss := v_ss + v_random_num;
            
            rec_punch_data.hh := trunc(v_ss / 3600 );
            rec_punch_data.mm := trunc(mod(v_ss , 3600)/60 );
            rec_punch_data.ss := mod(mod(v_ss , 3600),60 );
            
            --Out - IN ffrom Tea
            v_ret_val   := v_ret_val   || ' - ' || To_Char(rec_punch_data.hh, 'FM00') ||':' ||To_Char(rec_punch_data.mm, 'FM00') ||':' ||To_Char(rec_punch_data.ss, 'FM00') ||'.000';
        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;

    Function get_evening_tea(
        param_empno         Varchar2,
        param_date          Date,
        param_ok            varchar2
    ) Return Varchar2 As
        rec_punch_data   selfservice.ss_integratedpunch%rowtype;
        rec_punch_data_last   selfservice.ss_integratedpunch%rowtype;
        v_ret_val        Varchar2(50);
        v_ss number(6);
        v_ss_last number(6);
        v_random_num number(6);
    Begin
        
            Select *
            Into
                rec_punch_data
            From (
                    Select *
                    From selfservice.ss_integratedpunch
                    Where empno   = param_empno
                        And pdate   = param_date
                    Order By hh, mm, ss
                )
            Where Rownum = 1;
            

            Select *
            Into
                rec_punch_data_last
            From (
                    Select *
                    From selfservice.ss_integratedpunch
                    Where empno   = param_empno
                        And pdate   = param_date
                    Order By hh desc, mm desc, ss desc
                )
            Where Rownum = 1;

            v_ss := ( rec_punch_data.hh * 60 * 60) + ( rec_punch_data.mm * 60) + ( rec_punch_data.ss);
            v_ss_last := ( rec_punch_data_last.hh * 60 * 60) + ( rec_punch_data_last.mm * 60) + ( rec_punch_data_last.ss);
            if v_ss_last - v_ss < 25000 Then
                return '0';
            End If;
            v_random_num := round(dbms_random.value(23400,23400 + 600)); -- InTime + 6.5Hrs , InTime + 6.5Hrs + 10Mns
            v_ss := v_ss + v_random_num;
            
            rec_punch_data.hh := trunc(v_ss / 3600 );
            rec_punch_data.mm := trunc(mod(v_ss , 3600)/60 );
            rec_punch_data.ss := mod(mod(v_ss , 3600),60 );
            
            --Out for Lunch
            v_ret_val   := To_Char(rec_punch_data.hh, 'FM00') ||':' ||To_Char(rec_punch_data.mm, 'FM00') ||':' ||To_Char(rec_punch_data.ss, 'FM00') ||'.000';

            --In From Lunch
            v_random_num := round(dbms_random.value(600,900)); -- 35Min , 45Min
            v_ss := v_ss + v_random_num;
            
            rec_punch_data.hh := trunc(v_ss / 3600 );
            rec_punch_data.mm := trunc(mod(v_ss , 3600)/60 );
            rec_punch_data.ss := mod(mod(v_ss , 3600),60 );
            
            --Out - IN ffrom Tea
            v_ret_val   := v_ret_val   || ' - ' || To_Char(rec_punch_data.hh, 'FM00') ||':' ||To_Char(rec_punch_data.mm, 'FM00') ||':' ||To_Char(rec_punch_data.ss, 'FM00') ||'.000';
        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;

End pkg_09794;

/
