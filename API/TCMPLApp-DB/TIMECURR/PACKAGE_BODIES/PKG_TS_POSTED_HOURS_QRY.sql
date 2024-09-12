--------------------------------------------------------
--  DDL for Package Body PKG_TS_POSTED_HOURS_QRY
--------------------------------------------------------

Create Or Replace Package Body timecurr.pkg_ts_posted_hours_qry As

    Function sp_get_hours(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_yyyymm    Varchar2
        
    ) Return Sys_Refcursor As
        c            Sys_Refcursor;
        v_empno      Char(5);   
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Return Null;
        End If;

        If p_yyyymm Is Null Then
            Return Null;
        End If;
        
        --Select pros_month
          --Into v_pros_month
          --From tsconfig;

        Open c For

            With
                assign_list As (
                    Select assign
                      From time_mast
                     Where yymm = p_yyyymm
                       And nvl(posted, 0) = 1
                    Union
                    Select costcode assign
                      From timetran
                     Where yymm = p_yyyymm
                    Union
                    Select assign
                      From ts_osc_mhrs_master
                     Where yymm = p_yyyymm
                       And nvl(is_post, not_ok) = ok
                )
            Select al.assign,
                   (
                       Select Sum(nvl(tm.tot_nhr, 0) + nvl(tm.tot_ohr, 0))
                         From time_mast tm
                        Where nvl(tm.posted, 0) = 1
                          And tm.assign = al.assign
                          And tm.yymm = p_yyyymm
                   )    p_from_time_mast,
                   (
                       Select Sum(nvl(pd.nhrs, 0) + nvl(pd.ohrs, 0))
                         From postingdata pd,
                              time_mast tm
                        Where pd.yymm = tm.yymm
                          And pd.empno = tm.empno
                          And pd.parent = tm.parent
                          And pd.assign = tm.assign
                          And nvl(tm.posted, 0) = 1
                          And tm.assign = al.assign
                          And tm.yymm = p_yyyymm
                   )    p_from_time_daily_ot,
                   (
                       Select Sum(nvl(t.hours, 0) + nvl(t.othours, 0))
                         From timetran t
                        Where t.costcode = al.assign
                          And t.yymm = p_yyyymm
                          And t.empno Not Like 'W%'
                   )    p_from_timetran,
                   Null As p_blank,
                   (
                       Select Sum(nvl(tomm.hours, 0))
                         From ts_osc_mhrs_master tomm
                        Where nvl(tomm.is_post, not_ok) = ok
                          And tomm.assign = al.assign
                          And tomm.yymm = p_yyyymm
                   )    p_from_osc_master,
                   (
                       Select Sum(nvl(tomd.hours, 0))
                         From ts_osc_mhrs_master tomm,
                              ts_osc_mhrs_detail tomd
                        Where tomd.oscm_id = tomm.oscm_id
                          And nvl(tomm.is_post, not_ok) = ok
                          And tomm.assign = al.assign
                          And tomm.yymm = p_yyyymm
                   )    p_from_osc_detail,
                   (
                       Select Sum(nvl(t.hours, 0) + nvl(t.othours, 0))
                         From timetran t
                        Where t.costcode = al.assign
                          And t.yymm = p_yyyymm
                          And t.empno Like 'W%'
                   )    p_from_timetran_osc
              From dual, assign_list al;

        Return c;

    End;

End pkg_ts_posted_hours_qry;