Create Or Replace Package Body timecurr.pkg_ts_posted_hours_total_qry As

    Procedure sp_get_total_hours(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_yyyymm                  Varchar2,

        p_time_mast_total     Out Number,
        p_time_daily_ot_total Out Number,
        p_timetran_total      Out Number,
        p_osc_master_total    Out Number,
        p_osc_detail_total    Out Number,
        p_timetran_osc_total  Out Number,

        p_message_type        Out Varchar2,
        p_message_text        Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_yyyymm Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Invalid Year/Month';
            Return;
        End If;
        --Select pros_month
        --Into v_pros_month
        --From tsconfig;

        Select (
                   Select Sum(nvl(tm.tot_nhr, 0) + nvl(tm.tot_ohr, 0))
                     From time_mast tm
                    Where nvl(tm.posted, 0) = 1
                      And tm.yymm = p_yyyymm
               ) p_from_time_mast_total,
               (
                   Select Sum(nvl(pd.nhrs, 0) + nvl(pd.ohrs, 0))
                     From postingdata pd,
                          time_mast tm
                    Where pd.yymm = tm.yymm
                      And pd.empno = tm.empno
                      And pd.parent = tm.parent
                      And pd.assign = tm.assign
                      And nvl(tm.posted, 0) = 1
                      And tm.yymm = p_yyyymm
               ) p_from_time_daily_ot_total,
               (
                   Select Sum(nvl(t.hours, 0) + nvl(t.othours, 0))
                     From timetran t
                    Where t.yymm = p_yyyymm
                      And t.empno Not Like 'W%'
               ) p_from_timetran_total,
               (
                   Select Sum(nvl(tomm.hours, 0))
                     From ts_osc_mhrs_master tomm
                    Where nvl(tomm.is_post, not_ok) = ok
                      And tomm.yymm = p_yyyymm
               ) p_from_osc_master_total,
               (
                   Select Sum(nvl(tomd.hours, 0))
                     From ts_osc_mhrs_master tomm,
                          ts_osc_mhrs_detail tomd
                    Where tomd.oscm_id = tomm.oscm_id
                      And nvl(tomm.is_post, not_ok) = ok
                      And tomm.yymm = p_yyyymm
               ) p_from_osc_detail_total,
               (
                   Select Sum(nvl(t.hours, 0) + nvl(t.othours, 0))
                     From timetran t
                    Where t.yymm = p_yyyymm
                      And t.empno Like 'W%'
               ) p_from_timetran_osc_total
          Into p_time_mast_total, p_time_daily_ot_total, p_timetran_total, p_osc_master_total, p_osc_detail_total, p_timetran_osc_total
          From dual;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_get_total_hours;

End pkg_ts_posted_hours_total_qry;