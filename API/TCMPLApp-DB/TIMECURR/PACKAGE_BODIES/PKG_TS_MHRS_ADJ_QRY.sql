--------------------------------------------------------
--  DDL for Package Body PKG_TS_MHRS_ADJ_QRY
--------------------------------------------------------

Create Or Replace Package Body timecurr.pkg_ts_mhrs_adj_qry As

    Procedure sp_allow_to_process(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        If commonmasters.pkg_environment.is_development = ok Or commonmasters.pkg_environment.is_staging = ok Then
            p_message_type := ok;
            p_message_text := 'Success';
        Elsif commonmasters.pkg_environment.is_production = ok Then
            p_message_type := not_ok;
            p_message_text := 'Error...';
        End If;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_allow_to_process;

    Function fn_get_shift_hrs_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_yyyymm          Varchar2,
        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Char(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        log_id,
                        yymm_from,
                        yymm_to,
                        projno_from,
                        projno_to,
                        Case message_type
                            When ok Then
                                'Success'
                            Else
                                'Error'
                        End                                           As message_type,
                        message_text,
                        Row_Number() Over (Order By modified_on Desc) row_number,
                        Count(*) Over ()                              total_row
                    From
                        time_adj_log
                    Where
                        yymm_to = Trim(p_yyyymm)
                        And (
                            upper(projno_from) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(projno_to) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End;

    Procedure sp_get_shift_hrs_excel(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_log_id             Varchar2,

        p_time_mast_log  Out Sys_Refcursor,
        p_time_daily_log Out Sys_Refcursor,
        p_time_ot_log    Out Sys_Refcursor,

        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Or p_log_id Is Null Then
            p_time_mast_log  := Null;
            p_time_daily_log := Null;
            p_time_ot_log    := Null;
            p_message_type   := not_ok;
            p_message_text   := 'Error...';
        End If;

        Open p_time_mast_log For
            Select
                tmal.yymm,
                tmal.empno,
                e.name,
                tmal.parent,
                tmal.assign,
                tmal.grp,
                To_Number(Nvl(tmal.tot_nhr,0)) As normal_hours,
                To_Number(Nvl(tmal.tot_ohr,0)) As ot_hours,
                tmal.company,
                Case tmal.exceed
                    When 1 Then
                        'Yes'
                    Else
                        'No'
                End exceed,
                Case tmal.message_type
                    When ok Then
                        'Success'
                    Else
                        'Error'
                End As status,
                tmal.message_text As remarks
            From
                time_mast_adj_log tmal,
                emplmast          e
            Where
                e.empno = tmal.empno
                And tmal.log_id = Trim(p_log_id)
            Order By
                empno;

        Open p_time_daily_log For
            Select
                tdal.yymm,
                tdal.empno,
                e.name,
                tdal.parent,
                tdal.assign,
                tdal.projno,
                p.name As projno_name,
                tdal.wpcode,
                tdal.activity,
                To_Number(Nvl(tdal.d1, 0)) As d1,
                To_Number(Nvl(tdal.d2, 0)) As d2,
                To_Number(Nvl(tdal.d3, 0)) As d3,
                To_Number(Nvl(tdal.d4, 0)) As d4,
                To_Number(Nvl(tdal.d5, 0)) As d5,/*
                To_Number(Nvl(tdal.d6, 0)) As d6,
                To_Number(Nvl(tdal.d7, 0)) As d7,
                To_Number(Nvl(tdal.d8, 0)) As d8,
                To_Number(Nvl(tdal.d9, 0)) As d9,
                To_Number(Nvl(tdal.d10, 0)) As d10,
                To_Number(Nvl(tdal.d11, 0)) As d11,
                To_Number(Nvl(tdal.d12, 0)) As d12,
                To_Number(Nvl(tdal.d13, 0)) As d13,
                To_Number(Nvl(tdal.d14, 0)) As d14,
                To_Number(Nvl(tdal.d15, 0)) As d15,
                To_Number(Nvl(tdal.d16, 0)) As d16,
                To_Number(Nvl(tdal.d17, 0)) As d17,
                To_Number(Nvl(tdal.d18, 0)) As d18,
                To_Number(Nvl(tdal.d19, 0)) As d19,
                To_Number(Nvl(tdal.d20, 0)) As d20,
                To_Number(Nvl(tdal.d21, 0)) As d21,
                To_Number(Nvl(tdal.d22, 0)) As d22,
                To_Number(Nvl(tdal.d23, 0)) As d23,
                To_Number(Nvl(tdal.d24, 0)) As d24,
                To_Number(Nvl(tdal.d25, 0)) As d25,
                To_Number(Nvl(tdal.d26, 0)) As d26,
                To_Number(Nvl(tdal.d27, 0)) As d27,
                To_Number(Nvl(tdal.d28, 0)) As d28,
                To_Number(Nvl(tdal.d29, 0)) As d29,
                To_Number(Nvl(tdal.d30, 0)) As d30,
                To_Number(Nvl(tdal.d31, 0)) As d31,*/
                To_Number(Nvl(tdal.total, 0)) As total,
                tdal.grp,
                tdal.company,
                Case tdal.message_type
                    When ok Then
                        'Success'
                    Else
                        'Error'
                End As status,
                tdal.message_text As remarks
            From
                time_daily_adj_log tdal,
                time_mast_adj_log  tmal,
                time_adj_log       tal,
                emplmast           e,
                projmast           p
            Where
                e.empno = tmal.empno
                And p.projno = tdal.projno
                And tdal.time_mast_id = tmal.time_mast_id
                And tal.log_id = tmal.log_id
                And tal.log_id = Trim(p_log_id)
            Order By
                e.empno,
                tdal.projno,
                tdal.wpcode,
                tdal.activity;

        Open p_time_ot_log For
            Select
                toal.yymm,
                toal.empno,
                e.name,
                toal.parent,
                p.name As projno_name,
                toal.assign,
                toal.projno,
                toal.wpcode,
                toal.activity,
                To_Number(Nvl(toal.d1, 0)) As d1,
                To_Number(Nvl(toal.d2, 0)) As d2,
                To_Number(Nvl(toal.d3, 0)) As d3,
                To_Number(Nvl(toal.d4, 0)) As d4,
                To_Number(Nvl(toal.d5, 0)) As d5,/*
                To_Number(Nvl(toal.d6, 0)) As d6,
                To_Number(Nvl(toal.d7, 0)) As d7,
                To_Number(Nvl(toal.d8, 0)) As d8,
                To_Number(Nvl(toal.d9, 0)) As d9,
                To_Number(Nvl(toal.d10, 0)) As d10,
                To_Number(Nvl(toal.d11, 0)) As d11,
                To_Number(Nvl(toal.d12, 0)) As d12,
                To_Number(Nvl(toal.d13, 0)) As d13,
                To_Number(Nvl(toal.d14, 0)) As d14,
                To_Number(Nvl(toal.d15, 0)) As d15,
                To_Number(Nvl(toal.d16, 0)) As d16,
                To_Number(Nvl(toal.d17, 0)) As d17,
                To_Number(Nvl(toal.d18, 0)) As d18,
                To_Number(Nvl(toal.d19, 0)) As d19,
                To_Number(Nvl(toal.d20, 0)) As d20,
                To_Number(Nvl(toal.d21, 0)) As d21,
                To_Number(Nvl(toal.d22, 0)) As d22,
                To_Number(Nvl(toal.d23, 0)) As d23,
                To_Number(Nvl(toal.d24, 0)) As d24,
                To_Number(Nvl(toal.d25, 0)) As d25,
                To_Number(Nvl(toal.d26, 0)) As d26,
                To_Number(Nvl(toal.d27, 0)) As d27,
                To_Number(Nvl(toal.d28, 0)) As d28,
                To_Number(Nvl(toal.d29, 0)) As d29,
                To_Number(Nvl(toal.d30, 0)) As d30,
                To_Number(Nvl(toal.d31, 0)) As d31,*/
                To_Number(Nvl(toal.total, 0)) As total,
                toal.grp,
                toal.company,
                Case toal.message_type
                    When ok Then
                        'Success'
                    Else
                        'Error'
                End As status,
                toal.message_text as remarks
            From
                time_ot_adj_log   toal,
                time_mast_adj_log tmal,
                time_adj_log      tal,
                emplmast          e,
                projmast          p
            Where
                e.empno = tmal.empno
                And p.projno = toal.projno
                And toal.time_mast_id = tmal.time_mast_id
                And tal.log_id = tmal.log_id
                And tal.log_id = Trim(p_log_id)
            Order By
                e.empno,
                toal.projno,
                toal.wpcode,
                toal.activity;

        p_message_type := ok;
        p_message_text := 'Success';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

End pkg_ts_mhrs_adj_qry;