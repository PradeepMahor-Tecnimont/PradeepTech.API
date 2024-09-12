Create Or Replace Package Body tcmpl_hr.pkg_base_common As

    Procedure sp_employee_details(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_empno             Varchar2 Default Null,

        p_for_empno             Out Varchar2,
        p_name              Out Varchar2,
        p_emp_type          Out Varchar2,
        p_grade             Out Varchar2,
        p_desg_code         Out Varchar2,
        p_desg_name         Out Varchar2,
        p_doj               Out Varchar2,
        p_parent            Out Varchar2,
        p_cost_name         Out Varchar2,
        p_sapcc             Out Varchar2,
        p_assign            Out Varchar2,
        p_assign_name       Out Varchar2,
        p_sapccassign       Out Varchar2,
        p_ho_d              Out Varchar2,
        p_ho_d_name         Out Varchar2,
        p_mngr_name         Out Varchar2,
        p_secretary         Out Varchar2,
        p_sec_name          Out Varchar2,
        p_card_r_f_i_d      Out Varchar2,
        p_hexa_card_r_f_i_d Out Varchar2,
        p_emp_person_id     Out Varchar2,
        p_emp_meta_id       Out Varchar2,
        p_todays_first_punch_office    Out Varchar2,
        p_base_office                  Out Varchar2,
        p_current_office_location      Out Varchar2,
        p_primary_workspace            Out Varchar2,
        p_desk_id                      Out Varchar2,
        p_email                        Out Varchar2,
        p_show_all_details             Out Varchar2,
        P_job_title         Out Varchar2,
        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        v_by_empno  Varchar2(5);
        v_parent_valid_count  number;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERROR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_empno Is Not Null Then
            p_for_empno := p_empno;
        Else
            p_for_empno := v_by_empno;
        End If;

        p_show_all_details := not_ok;

        select count(parent)
               into
               v_parent_valid_count
        from vu_emplmast
            where empno = v_by_empno
            and status = 1
            and parent in ('0106','0107','0119','0180','0181','0OB06','0OB07','OB181');

            if v_parent_valid_count > 0 then
                p_show_all_details := ok;
            end if;

            p_todays_first_punch_office := selfservice.self_attendance.get_emp_office(p_for_empno, trunc(sysdate));
            p_current_office_location := tcmpl_hr.pkg_common.fn_get_office_location_Desc
                                            (tcmpl_hr.pkg_common.fn_get_emp_office_location(p_for_empno,sysdate));
            p_primary_workspace := selfservice.iot_swp_common.fn_get_pws_text
                                            (to_char(selfservice.iot_swp_common.fn_get_emp_pws(p_for_empno, sysdate)));
            p_desk_id := selfservice.iot_swp_common.get_desk_from_dms(p_for_empno);


           p_todays_first_punch_office := REPLACE(p_todays_first_punch_office, 'ERR', 'NA');
           p_current_office_location := REPLACE(p_current_office_location, 'ERR', 'NA');
           p_primary_workspace := REPLACE(p_primary_workspace, 'ERR', 'NA');
           p_desk_id := REPLACE(p_desk_id, 'ERR', 'NA');

        Select
            a.name,
            a.emptype,
            a.grade,
            a.desgcode,
            c.desg                                                                             As desgname,
            a.doj,
            a.parent,
            b.name                                                                             As costname,
            b.sapcc                                                                            As sapcc,
            a.assign,
            e.name                                                                             As assignname,
            e.sapcc                                                                            As sapccassign,
            b.hod,
            pkg_common.fn_get_employee_name(b.hod)                                             As hod_name,
            pkg_common.fn_get_employee_name(a.mngr)                                            As mngr_name,
            b.secretary,
            pkg_common.fn_get_employee_name(b.secretary)                                       As sec_name,
            trim(d.card_rfid),
            --trim(to_char(nvl(d.card_rfid, 0), lpad('X', length(to_char(nvl(d.card_rfid, 0))), 'X'))) As hexa_card_rfid,
            trim(to_char(nvl(trim(d.card_rfid), 0), lpad('X', length(to_char(nvl(trim(d.card_rfid), 0))), 'X'))) As hexa_card_rfid,
            a.personid,
            a.metaid,
            a.office,
            a.email,
            a.jobtitle
        Into
            p_name,
            p_emp_type,
            p_grade,
            p_desg_code,
            p_desg_name,
            p_doj,
            p_parent,
            p_cost_name,
            p_sapcc,
            p_assign,
            p_assign_name,
            p_sapccassign,
            p_ho_d,
            p_ho_d_name,
            p_mngr_name,
            p_secretary,
            p_sec_name,
            p_card_r_f_i_d,
            p_hexa_card_r_f_i_d,
            p_emp_person_id,
            p_emp_meta_id,
            p_base_office,
            p_email,
            P_job_title
        From
            vu_emplmast            a,
            vu_costmast            b,
            vu_costmast            e,
            vu_desgmast            c,
            vu_emplmast_supplement d
        Where
            a.parent       = b.costcode
            And a.assign   = e.costcode
            And a.desgcode = c.desgcode
            And a.empno    = Trim(p_for_empno)
            And a.empno    = d.empno (+);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_employee_details;

End pkg_base_common;