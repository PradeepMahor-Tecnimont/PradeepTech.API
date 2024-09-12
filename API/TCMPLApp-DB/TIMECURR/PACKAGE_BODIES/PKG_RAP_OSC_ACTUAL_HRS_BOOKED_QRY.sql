--------------------------------------------------------
--  DDL for Package Body PKG_RAP_OSC_ACTUAL_HRS_BOOKED_QRY
--------------------------------------------------------

Create Or Replace Package Body timecurr.pkg_rap_osc_actual_hrs_booked_qry As

    Function fn_actual_hrs_booked_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_oscm_id        Varchar2,

        p_generic_search Varchar2,

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
                        tc.yymm,
                        tc.costcode || ' - ' || c.name                              costcode,                                                
                        Sum(Nvl(tc.hours,0)) as hours,
                        Sum(Nvl(tc.othours,0)) as othours,
                        Sum(nvl(tc.hours, 0) + nvl(tc.othours, 0))                       total_hours,
                        Row_Number() Over (Order By tc.yymm, tc.costcode) row_number,
                        Count(*) Over ()                                            total_row
                    From
                        rap_osc_master   rom,
                        emplmast         e,
                        timetran_combine tc,
                        costmast         c
                    Where
                        tc.empno                    = e.empno
                        And rom.oscm_vendor         = e.subcontract
                        And e.emptype               = 'O'
                        And substr(tc.projno, 1, 5) = rom.projno5
                        And tc.costcode             = c.costcode
                        And rom.oscm_id             = Trim(p_oscm_id)
                        And (
                            upper(tc.costcode) Like '%' || upper(Trim(p_generic_search)) || '%' Or                            
                            upper(c.name) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            tc.yymm Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                    Group By tc.yymm, tc.costcode, c.name
                )

            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_actual_hrs_booked_list;

    Function fn_actual_hrs_booked_sum(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_oscm_id   Varchar2

    ) Return Number As
        v_actual_hrs Number;
    Begin
        Select
            Sum(nvl(tc.hours, 0) + nvl(tc.othours, 0))
        Into
            v_actual_hrs
        From
            rap_osc_master   rom,
            emplmast         e,
            timetran_combine tc,
            costmast         c
        Where
            tc.empno                    = e.empno
            And rom.oscm_vendor         = e.subcontract
            And e.emptype               = 'O'
            And substr(tc.projno, 1, 5) = rom.projno5
            And tc.costcode             = c.costcode
            And rom.oscm_id             = Trim(p_oscm_id);

        Return v_actual_hrs;
    Exception
        When Others Then
            Return 0;
    End fn_actual_hrs_booked_sum;

    Function fn_xl_download_actual_hrs_booked_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_oscm_id        Varchar2

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
                tc.yymm,
                tc.costcode || ' - ' || c.name        costcode,
                Sum(Nvl(tc.hours,0)) as hours,
                Sum(Nvl(tc.othours,0)) as othours,
                Sum(nvl(tc.hours, 0) + nvl(tc.othours, 0))                       total_hours
            From
                rap_osc_master   rom,
                emplmast         e,
                timetran_combine tc,
                costmast         c
            Where
                tc.empno                    = e.empno
                And rom.oscm_vendor         = e.subcontract
                And e.emptype               = 'O'
                And substr(tc.projno, 1, 5) = rom.projno5
                And tc.costcode             = c.costcode
                And rom.oscm_id             = Trim(p_oscm_id)
            Group By tc.yymm, tc.costcode, c.name
            Order By tc.yymm, tc.costcode;

        Return c;
    End fn_xl_download_actual_hrs_booked_list;

End pkg_rap_osc_actual_hrs_booked_qry;
/
Grant Execute On "TIMECURR"."PKG_RAP_OSC_ACTUAL_HRS_BOOKED_QRY" To "TCMPL_APP_CONFIG";