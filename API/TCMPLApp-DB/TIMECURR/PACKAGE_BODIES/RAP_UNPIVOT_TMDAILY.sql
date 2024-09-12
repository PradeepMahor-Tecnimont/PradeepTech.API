--------------------------------------------------------
--  DDL for Package Body RAP_UNPIVOT_TMDAILY
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."RAP_UNPIVOT_TMDAILY" As

    Function get_latest_process_keyid (
        param_process_option Varchar2
    ) Return Varchar2 Is
        v_process_keyid Varchar2(5);
    Begin
        Select
            process_keyid
        Into v_process_keyid
        From
            rap_process4rep_trans
        Where
            process_type = c_process_type
            And Trim(process_options) = Trim(param_process_option);

        Return v_process_keyid;
    Exception
        When Others Then
            Return '';
    End;

    Function get_process_options4costcenter (
        param_costcenter Varchar2,
        param_yyyymm Varchar2
    ) Return Varchar2 Is
    Begin
        Return 'COSTCENTER:' || param_costcenter || '-' || 'YYYYMM:' || param_yyyymm;
    End;

    Function get_process_options4project (
        param_project Varchar2,
        param_yyyymm Varchar2
    ) Return Varchar2 Is
    Begin
        Return 'PROJECT:' || param_project || '-' || 'YYYYMM:' || param_yyyymm;
    End;

    Procedure get_process_status (
        param_costcenter         Varchar2,
        param_project            Varchar2,
        param_yyyymm             Varchar2,
        param_can_init_process   Out                      Varchar2,
        param_can_download       Out                      Varchar2,
        param_success            Out                      Varchar2,
        param_message            Out                      Varchar2
    ) As

        v_process_options     Varchar2(100);
        v_process_type        Varchar2(4) := 'P001';
        v_row_process_trans   rap_process4rep_trans%rowtype;
        v_now                 Date := Sysdate;
        v_date                Date;
        v_key_id              Varchar2(5);
    Begin
        param_success            := 'KO';
        param_can_init_process   := 'KO';
        param_can_download       := 'KO';
        If ( param_costcenter Is Null And param_project Is Null ) Or ( param_costcenter Is Not Null And param_project Is Not Null
        ) Then
            param_message := 'Invalid parameters. Please provide Project / Costcenter.';
            return;
        End If;

        Begin
            v_date := To_Date(param_yyyymm, 'yyyymm');
        Exception
            When Others Then
                param_message := 'Invalid "YYYYMM" provided. Cannot proceed.';
                return;
        End;

        If param_costcenter Is Not Null Then
            v_process_options := get_process_options4costcenter(
                param_costcenter,
                param_yyyymm
            );
        Elsif param_project Is Not Null Then
            v_process_options := get_process_options4project(
                param_project,
                param_yyyymm
            );
        Else
            param_message := 'Invalid processing options provided. Cannot proceed.';
            return;
        End If;

        Begin
            Select
                *
            Into v_row_process_trans
            From
                rap_process4rep_trans
            Where
                process_type = v_process_type
                And Trim(process_options) = Trim(v_process_options);

        Exception
            When Others Then
                Null;
        End;

        param_success            := 'OK';
        If ( v_now - Nvl(v_row_process_trans.process_date, v_now - 10) ) * 1440 < 15 Then
            param_can_init_process   := 'KO';
            param_can_download       := 'OK';
            param_message            := 'Last process initiated on ' || To_Char((v_row_process_trans.process_date), 'dd-Mon-yyyy hh24:mi') ||
            '. Please initiate next process after ' || To_Char((v_row_process_trans.process_date + 15 / 1440), 'dd-Mon-yyyy hh24:mi'
            );

            return;
        End If;

        param_can_init_process   := 'OK';
        If v_row_process_trans.process_date Is Null Then
            param_message        := 'Process not yet initiated.';
            param_can_download   := 'KO';
        Else
            param_message        := 'Last process initiated on ' || To_Char(v_row_process_trans.process_date, 'dd-Mon-yyyy hh24:mi');
            param_can_download   := 'OK';
        End If;

    Exception
        When Others Then
            param_success            := 'KO';
            param_can_init_process   := 'KO';
            param_can_download       := 'KO';
            param_message            := 'Error :- ' || Sqlcode || ' - ' || Sqlerrm;
    End;

    Procedure set_init_attributes (
        param_costcenter   Varchar2,
        param_project      Varchar2,
        param_yyyymm       Varchar2,
        param_keyid        Out                Varchar2,
        param_success      Out                Varchar2,
        param_message      Out                Varchar2
    ) As

        v_process_options     Varchar2(100);
        v_process_type        Varchar2(4) := 'P001';
        v_row_process_trans   rap_process4rep_trans%rowtype;
        v_now                 Date := Sysdate;
        v_date                Date;
        v_key_id              Varchar2(5);
        v_success             Varchar2(10);
        v_message             Varchar2(1000);
        v_can_init_process    Varchar2(10);
        v_can_download        Varchar2(10);
    Begin
    /*
        If ( param_costcenter Is Null And param_project Is Null ) Or ( param_costcenter Is Not Null And param_project Is Not Null
        ) Then
            param_success   := 'KO';
            param_message   := 'Invalid parameters. Please provide Project / Costcenter.';
            return;
        End If;

        Begin
            v_date := To_Date(param_yyyymm, 'yyyymm');
        Exception
            When Others Then
                param_success   := 'KO';
                param_message   := 'Invalid "YYYYMM" provided. Cannot proceed.';
                return;
        End;

        If param_costcenter Is Not Null Then
            v_process_options := get_process_options4costcenter(
                param_costcenter,
                param_yyyymm
            );
        Elsif param_project Is Not Null Then
            v_process_options := get_process_options4project(
                param_project,
                param_yyyymm
            );
        Else
            param_success   := 'KO';
            param_message   := 'Invalid processing options provided. Cannot proceed.';
            return;
        End If;

        Begin
            Select
                *
            Into v_row_process_trans
            From
                rap_process4rep_trans
            Where
                process_type = v_process_type
                And Trim(process_options) = Trim(v_process_options);

        Exception
            When Others Then
                Null;
        End;

        If ( v_now - Nvl(v_row_process_trans.process_date, v_now - 10) ) * 1440 < 15 Then
            param_success   := 'KO';
            param_message   := 'Please process after ' || To_Char((v_row_process_trans.process_date + 15 / 1440), 'dd-Mon-yyyy hh24:mi'
            );

            return;
        End If;
*/
        get_process_status(
            param_costcenter         => param_costcenter,
            param_project            => param_project,
            param_yyyymm             => param_yyyymm,
            param_can_download       => v_can_download,
            param_can_init_process   => v_can_init_process,
            param_success            => v_success,
            param_message            => v_message
        );

        If v_can_init_process = 'KO' Then
            param_success   := 'KO';
            param_message   := v_message;
            return;
        End If;

        If param_costcenter Is Not Null Then
            v_process_options := get_process_options4costcenter(
                param_costcenter,
                param_yyyymm
            );
        Elsif param_project Is Not Null Then
            v_process_options := get_process_options4project(
                param_project,
                param_yyyymm
            );
        Else
            param_success   := 'KO';
            param_message   := 'Invalid processing options provided. Cannot proceed.';
            return;
        End If;

        Begin
            Select
                *
            Into v_row_process_trans
            From
                rap_process4rep_trans
            Where
                process_type = c_process_type
                And Trim(process_options) = Trim(v_process_options);

        Exception
            When Others Then
                Null;
        End;

        Delete From rap_tmdaily_unpivot
        Where
            process_keyid = v_row_process_trans.process_keyid;

        Delete From rap_process4rep_trans
        Where
            process_keyid = v_row_process_trans.process_keyid;

        Commit;
        v_key_id        := dbms_random.string(
            'X',
            5
        );
        Insert Into rap_process4rep_trans (
            process_type,
            process_date,
            process_options,
            process_keyid
        ) Values (
            v_process_type,
            v_now,
            v_process_options,
            v_key_id
        );

        Commit;
        param_success   := 'OK';
        param_keyid     := v_key_id;
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

--XXXXXXXXXXXXXXXXXXXXX--

    Procedure populate_data (
        param_yyyymm    Varchar2,
        param_assign    Varchar2,
        param_proj_no   Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As

        --Pragma autonomous_transaction;

        v_employees       Varchar2(4000);
        v_count           Number;
        v_process_keyid   Varchar2(5);
        v_projno          Varchar2(7);
        v_assign          Varchar2(4);
    Begin
        set_init_attributes(
            param_costcenter   => param_assign,
            param_project      => param_proj_no,
            param_yyyymm       => param_yyyymm,
            param_keyid        => v_process_keyid,
            param_success      => param_success,
            param_message      => param_message
        );

        If param_success = 'KO' Or v_process_keyid Is Null Then
            return;
        End If;
        v_projno        := Nvl(param_proj_no, '') || '%';
        v_assign        := Nvl(param_assign, '%');
        For cur_row In cur_emp_list(
            param_yyyymm,
            v_assign,
            v_projno
        ) Loop
            --v_employees := chr(39) || cur_row.employees || chr(39);
            v_employees := cur_row.empnos;
            --INSERT NORMAL Hours
            Insert Into rap_tmdaily_unpivot (
                process_keyid,
                yymm,
                empno,
                parent,
                assign,
                projno,
                wpcode,
                activity,
                dd,
                ts_date,
                hrs,
                hrs_type
            )
                Select
                    v_process_keyid,
                    yymm,
                    empno,
                    parent,
                    assign,
                    projno,
                    wpcode,
                    activity,
                    day_no,
                    To_Date(yymm || '-' || day_no, 'yyyymm-dd') t_date,
                    colvalue,
                    'NN' hrs_type
                From
                    (
                        With t As (
                            Select
                                yymm,
                                empno,
                                parent,
                                assign,
                                projno,
                                wpcode,
                                activity,
                                d1,
                                d2,
                                d3,
                                d4,
                                d5,
                                d6,
                                d7,
                                d8,
                                d9,
                                d10,
                                d11,
                                d12,
                                d13,
                                d14,
                                d15,
                                d16,
                                d17,
                                d18,
                                d19,
                                d20,
                                d21,
                                d22,
                                d23,
                                d24,
                                d25,
                                d26,
                                d27,
                                d28,
                                d29,
                                d30,
                                d31,
                                total,
                                grp,
                                company
                            From
                                time_daily
                            Where
                                yymm = param_yyyymm
                                And assign Like v_assign
                                And projno Like v_projno
                                And empno In (
                                    Select
                                        Trim(Regexp_Substr(v_employees, '[^,]+', 1, Level)) empls
                                    From
                                        dual
                                    Connect By
                                        Regexp_Substr(v_employees, '[^,]+', 1, Level) Is Not Null
                                )
                        )
                        Select
                            yymm,
                            empno,
                            parent,
                            assign,
                            projno,
                            wpcode,
                            activity,
                            To_Number(Replace(col, 'D', '')) day_no,
                    --To_Date(yymm || '-' || Replace(col, 'D', ''), 'yyyymm-dd'),
                            colvalue,
                            'NN' hrs_type
                        From
                            t Unpivot ( colvalue
                                For col
                            In ( d1,
                                 d2,
                                 d3,
                                 d4,
                                 d5,
                                 d6,
                                 d7,
                                 d8,
                                 d9,
                                 d10,
                                 d11,
                                 d12,
                                 d13,
                                 d14,
                                 d15,
                                 d16,
                                 d17,
                                 d18,
                                 d19,
                                 d20,
                                 d21,
                                 d22,
                                 d23,
                                 d24,
                                 d25,
                                 d26,
                                 d27,
                                 d28,
                                 d29,
                                 d30,
                                 d31 ) )
                    )
                Where
                    day_no <= To_Number(To_Char(Last_Day(To_Date(param_yyyymm, 'yyyymm')), 'dd'));

            --XXX--

            Commit;
            --INSERT OT Hours
            Insert Into rap_tmdaily_unpivot (
                process_keyid,
                yymm,
                empno,
                parent,
                assign,
                projno,
                wpcode,
                activity,
                dd,
                ts_date,
                hrs,
                hrs_type
            )
                Select
                    v_process_keyid,
                    yymm,
                    empno,
                    parent,
                    assign,
                    projno,
                    wpcode,
                    activity,
                    day_no,
                    To_Date(yymm || '-' || day_no, 'yyyymm-dd') t_date,
                    colvalue,
                    'OT' hrs_type
                From
                    (
                        With t As (
                            Select
                                yymm,
                                empno,
                                parent,
                                assign,
                                projno,
                                wpcode,
                                activity,
                                d1,
                                d2,
                                d3,
                                d4,
                                d5,
                                d6,
                                d7,
                                d8,
                                d9,
                                d10,
                                d11,
                                d12,
                                d13,
                                d14,
                                d15,
                                d16,
                                d17,
                                d18,
                                d19,
                                d20,
                                d21,
                                d22,
                                d23,
                                d24,
                                d25,
                                d26,
                                d27,
                                d28,
                                d29,
                                d30,
                                d31,
                                total,
                                grp,
                                company
                            From
                                time_ot
                            Where
                                yymm = param_yyyymm
                                And assign Like v_assign
                                And projno Like v_projno
                                And empno In (
                                    Select
                                        Trim(Regexp_Substr(v_employees, '[^,]+', 1, Level)) empls
                                    From
                                        dual
                                    Connect By
                                        Regexp_Substr(v_employees, '[^,]+', 1, Level) Is Not Null
                                )
                        )
                        Select
                            yymm,
                            empno,
                            parent,
                            assign,
                            projno,
                            wpcode,
                            activity,
                            To_Number(Replace(col, 'D', '')) day_no,
                    --To_Date(yymm || '-' || Replace(col, 'D', ''), 'yyyymm-dd'),
                            colvalue,
                            'NN' hrs_type
                        From
                            t Unpivot ( colvalue
                                For col
                            In ( d1,
                                 d2,
                                 d3,
                                 d4,
                                 d5,
                                 d6,
                                 d7,
                                 d8,
                                 d9,
                                 d10,
                                 d11,
                                 d12,
                                 d13,
                                 d14,
                                 d15,
                                 d16,
                                 d17,
                                 d18,
                                 d19,
                                 d20,
                                 d21,
                                 d22,
                                 d23,
                                 d24,
                                 d25,
                                 d26,
                                 d27,
                                 d28,
                                 d29,
                                 d30,
                                 d31 ) )
                    )
                Where
                    day_no <= To_Number(To_Char(Last_Day(To_Date(param_yyyymm, 'yyyymm')), 'dd'));                               
/*

            Insert Into ngts_tmdaily_unpivot (
                process_keyid,
                yymm,
                empno,
                parent,
                assign,
                projno,
                wpcode,
                activity,
                reason_code,
                dd,
                ts_date,
                hrs,
                hrs_type
            )
                With t As (
                    Select
                        yymm,
                        empno,
                        parent,
                        assign,
                        projno,
                        wpcode,
                        activity,
                        reasoncode,
                        d1,
                        d2,
                        d3,
                        d4,
                        d5,
                        d6,
                        d7,
                        d8,
                        d9,
                        d10,
                        d11,
                        d12,
                        d13,
                        d14,
                        d15,
                        d16,
                        d17,
                        d18,
                        d19,
                        d20,
                        d21,
                        d22,
                        d23,
                        d24,
                        d25,
                        d26,
                        d27,
                        d28,
                        d29,
                        d30,
                        d31,
                        total,
                        grp,
                        company
                    From
                        time_ot
                    Where
                        yymm = param_yyyymm
                        And assign Like v_assign
                        And projno Like v_projno
                        And empno In (
                            Select
                                Trim(Regexp_Substr(v_employees, '[^,]+', 1, Level)) empls
                            From
                                dual
                            Connect By
                                Regexp_Substr(v_employees, '[^,]+', 1, Level) Is Not Null
                        )
                )
                Select
                    v_process_keyid,
                    yymm,
                    empno,
                    parent,
                    assign,
                    projno,
                    wpcode,
                    activity,
                    reasoncode,
                    Replace(col, 'D', ''),
                    To_Date(yymm || '-' || Replace(col, 'D', ''), 'yyyymm-dd'),
                    colvalue,
                    'OT'
                From
                    t Unpivot ( colvalue
                        For col
                    In ( d1,
                         d2,
                         d3,
                         d4,
                         d5,
                         d6,
                         d7,
                         d8,
                         d9,
                         d10,
                         d11,
                         d12,
                         d13,
                         d14,
                         d15,
                         d16,
                         d17,
                         d18,
                         d19,
                         d20,
                         d21,
                         d22,
                         d23,
                         d24,
                         d25,
                         d26,
                         d27,
                         d28,
                         d29,
                         d30,
                         d31 ) );
                         */
            --XXX--

            --v_count      := Sql%rowcount;

        End Loop;
        
        If v_projno != '%' Then
            v_projno := Substr(v_projno,1,5)||'%';
        End If;
        
        Insert Into rap_tmdaily_unpivot
            Select
                v_process_keyid,
                tomm.yymm,
                tomm.empno,
                tomm.parent,
                tomm.assign,
                tomd.projno,
                tomd.wpcode,
                tomd.activity,
                Null,
                tomd.hours,
                'NN',
                Null
              From
                ts_osc_mhrs_master tomm,
                ts_osc_mhrs_detail tomd
             Where
                    tomm.oscm_id = tomd.oscm_id
                   And tomm.assign Like v_assign
                   And tomd.projno Like v_projno
                   And yymm = param_yyyymm;

        Commit;
        param_success   := 'OK';
        param_message   := 'Data has been successfully processed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := sqlcode || ' - ' || sqlerrm;   
    End;

    Procedure populate_data_for_costcenter (
        param_yyyymm       Varchar2,
        param_costcenter   Varchar2,
        param_success      Out                Varchar2,
        param_message      Out                Varchar2
    ) As
    Begin
        populate_data(
            param_yyyymm    => param_yyyymm,
            param_assign    => param_costcenter,
            param_proj_no   => Null,
            param_success   => param_success,
            param_message   => param_message
        );
    End populate_data_for_costcenter;

    Procedure populate_data_for_project (
        param_yyyymm    Varchar2,
        param_projno    Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As
        v_now               Date;
        v_process_options   Varchar2(100);
    Begin
        populate_data(
            param_yyyymm    => param_yyyymm,
            param_assign    => Null,
            param_proj_no   => param_projno,
            param_success   => param_success,
            param_message   => param_message
        );
    End populate_data_for_project;

    Procedure get_unpivot_4_costcenter (
        param_costcenter       Varchar2,
        param_yyyymm           Varchar2,
        param_unpivot_refcur   Out                    Sys_Refcursor
    ) Is
        v_process_option   Varchar2(500);
        v_key_id           Varchar2(5);
    Begin
        v_process_option := get_process_options4costcenter(
            param_costcenter,
            param_yyyymm
        );
        Select
            process_keyid
        Into v_key_id
        From
            rap_process4rep_trans
        Where
            process_type = 'P001'
            And Trim(process_options)  = v_process_option
            And process_date           = (
                Select
                    Max(process_date)
                From
                    rap_process4rep_trans
                Where
                    process_type = 'P001'
                    And Trim(process_options) = v_process_option
            );

        Open param_unpivot_refcur For Select
                                         *
                                     From
                                         rap_tmdaily_unpivot
                                     Where
                                         process_keyid = v_key_id;

    Exception
        When Others Then
            Open param_unpivot_refcur For Select
                                              *
                                          From
                                              rap_tmdaily_unpivot
                                          Where
                                              1 = 2;

    End;

    Procedure get_unpivot_4_project (
        param_project          Varchar2,
        param_yyyymm           Varchar2,
        param_unpivot_refcur   Out                    Sys_Refcursor
    ) Is
        v_process_option   Varchar2(500);
        v_key_id           Varchar2(5);
    Begin
        v_process_option := get_process_options4project(
            param_project,
            param_yyyymm
        );
        Select
            process_keyid
        Into v_key_id
        From
            rap_process4rep_trans
        Where
            process_type = 'P001'
            And Trim(process_options)  = v_process_option
            And process_date           = (
                Select
                    Max(process_date)
                From
                    rap_process4rep_trans
                Where
                    process_type = 'P001'
                    And Trim(process_options) = v_process_option
            );

        Open param_unpivot_refcur For Select
                                         *
                                     From
                                         rap_tmdaily_unpivot
                                     Where
                                         process_keyid = v_key_id;

    Exception
        When Others Then
            Open param_unpivot_refcur For Select
                                              *
                                          From
                                              rap_tmdaily_unpivot
                                          Where
                                              1 = 2;

    End;

    Procedure do_unpivot (
        param_yymm Varchar2
    ) As
        v_yymm Varchar2(4000);
    Begin
        Select
            Listagg(yymm,
                    ',') Within Group(
                Order By
                    yymm
            )
        Into v_yymm
        From
            (
                Select
                    To_Char(Add_Months(To_Date(param_yymm, 'yyyymm'), n), 'yyyymm') yymm
                From
                    (
                        Select
                            Rownum n
                        From
                            (
                                Select
                                    1 just_a_column
                                From
                                    dual
                                Connect By
                                    Level <= 18
                            )
                    )
            );

        v_yymm   := Replace(v_yymm, ',', Chr(39) || ',' || Chr(39));

        v_yymm   := Chr(39) || v_yymm || Chr(39);
    End;

    Procedure get_process_status_4_cc (
        param_yyyymm             Varchar2,
        param_costcenter         Varchar2,
        param_can_download       Out                      Varchar2,
        param_can_init_process   Out                      Varchar2,
        param_success            Out                      Varchar2,
        param_message            Out                      Varchar2
    ) As
        v_process_options Varchar2(500);
    Begin
        get_process_status(
            param_costcenter         => param_costcenter,
            param_project            => Null,
            param_yyyymm             => param_yyyymm,
            param_can_download       => param_can_download,
            param_can_init_process   => param_can_init_process,
            param_success            => param_success,
            param_message            => param_message
        );
    End;

    Procedure get_process_status_4_proj (
        param_yyyymm             Varchar2,
        param_project            Varchar2,
        param_can_download       Out                      Varchar2,
        param_can_init_process   Out                      Varchar2,
        param_success            Out                      Varchar2,
        param_message            Out                      Varchar2
    ) As
        v_process_options Varchar2(500);
    Begin
        get_process_status(
            param_costcenter         => Null,
            param_project            => param_project,
            param_yyyymm             => param_yyyymm,
            param_can_download       => param_can_download,
            param_can_init_process   => param_can_init_process,
            param_success            => param_success,
            param_message            => param_message
        );
    End;

    Function get_latest_keyid4cc (
        param_costcenter Varchar2,
        param_yyyymm Varchar2
    ) Return Varchar2 As
        v_process_options   Varchar2(500);
        v_keyid             Varchar2(5);
    Begin
        v_process_options   := get_process_options4costcenter(
            param_costcenter,
            param_yyyymm
        );
        v_keyid             := get_latest_process_keyid(v_process_options);
        Return v_keyid;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_latest_keyid4proj (
        param_project Varchar2,
        param_yyyymm Varchar2
    ) Return Varchar2 As
        v_process_options   Varchar2(500);
        v_keyid             Varchar2(5);
    Begin
        v_process_options   := get_process_options4project(
            param_project,
            param_yyyymm
        );
        v_keyid             := get_latest_process_keyid(v_process_options);
        Return v_keyid;
    Exception
        When Others Then
            Return Null;
    End;

end rap_unpivot_tmdaily;

/
