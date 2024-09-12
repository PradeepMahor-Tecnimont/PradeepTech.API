--------------------------------------------------------
--  DDL for Package Body HR_PKG_COSTMAST_MAIN
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."HR_PKG_COSTMAST_MAIN" As

    Procedure create_cost_center(
        param_costcode          Char,
        param_name              Varchar2,
        param_abbr              Varchar2,
        param_hod               Char,
        param_noofemps          Number,
        param_costgroupid       Char,
        param_groupid           Char,
        param_cost_type_id      Char,
        param_secretary         Char,
        param_sdate             Date,
        param_edate             Date,
        param_sapcc             Varchar2,
        param_parent_costcodeid Char,
        param_engg_nonengg      Varchar2,
        
        param_success Out       Varchar2,
        param_message Out       Varchar2
    ) As
        n_costcode Number;
    Begin
        Select
            Count(costcode)
        Into
            n_costcode
        From
            hr_costmast_main
        Where
            costcode = lpad(upper(Trim(param_costcode)), 4, '0');

        If n_costcode = 0 Then
            Select
                Count(costcode)
            Into
                n_costcode
            From
                costmast
            Where
                costcode = lpad(upper(Trim(param_costcode)), 4, '0');

        End If;

        If n_costcode = 0 Then
            Insert Into hr_costmast_main (
                costcodeid,
                costcode,
                name,
                abbr,
                hod,
                noofemps,
                costgroupid,
                groupid,
                cost_type_id,
                secretary,
                sdate,
                edate,
                sapcc,
                parent_costcodeid,
                engg_nonengg
            )
            Values (
                'CC' || upper(lpad(Trim(param_costcode), 4, '0')),
                upper(lpad(Trim(param_costcode), 4, '0')),
                param_name,
                param_abbr,
                param_hod,
                param_noofemps,
                param_costgroupid,
                param_groupid,
                param_cost_type_id,
                param_secretary,
                param_sdate,
                param_edate,
                param_sapcc,
                param_parent_costcodeid,
                param_engg_nonengg
            );

            Insert Into hr_costmast_hod (costcodeid) Values ('CC' || upper(lpad(Trim(param_costcode), 4, '0')));

            Insert Into hr_costmast_costcontrol (costcodeid) Values ('CC' || upper(lpad(Trim(param_costcode), 4, '0')));

            Insert Into hr_costmast_afc (costcodeid) Values ('CC' || upper(lpad(Trim(param_costcode), 4, '0')));

            Insert Into costmast (
                costcode,
                name,
                abbr,
                hod,
                noofemps,
                costgroup,
                groups,
                cost_type,
                secretary,
                sdate,
                edate,
                sapcc,
                parent_costcode,
                hod_abbr,
                engg_nonengg
            )
            Values (
                upper(lpad(Trim(param_costcode), 4, '0')),
                param_name,
                param_abbr,
                param_hod,
                param_noofemps,
                hr_pkg_common.get_costgroup(param_costgroupid),
                hr_pkg_common.get_costcode(param_groupid),
                hr_pkg_common.get_cost_type(param_cost_type_id),
                param_secretary,
                param_sdate,
                param_edate,
                param_sapcc,
                hr_pkg_common.get_costcode(param_parent_costcodeid),
                hr_pkg_common.get_emp_abbreviation(param_hod),
                param_engg_nonengg
            );

            Commit;
            param_success := 'OK';
            param_message := 'Cost center created successfully';
        Else
            param_success := 'KO';
            param_message := 'Cost center already created';
        End If;

    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End create_cost_center;

    Procedure update_cost_center(
        param_costcodeid        Char,
        param_name              Varchar2,
        param_abbr              Varchar2,
        param_hod               Char,
        param_noofemps          Number,
        param_costgroupid       Char,
        param_groupid           Char,
        param_cost_type_id      Char,
        param_secretary         Char,
        param_sdate             Date,
        param_edate             Date,
        param_sapcc             Varchar2,
        param_parent_costcodeid Char,
        param_engg_nonengg      Varchar2,
        
        param_success Out       Varchar2,
        param_message Out       Varchar2
    ) As
    Begin
        Update
            hr_costmast_main
        Set
            name = param_name,
            abbr = param_abbr,
            hod = param_hod,
            noofemps = param_noofemps,
            costgroupid = param_costgroupid,
            groupid = param_groupid,
            cost_type_id = param_cost_type_id,
            secretary = param_secretary,
            sdate = param_sdate,
            edate = param_edate,
            sapcc = param_sapcc,
            parent_costcodeid = param_parent_costcodeid,
            engg_nonengg = param_engg_nonengg
        Where
            costcodeid = param_costcodeid;

        Update
            costmast
        Set
            name = param_name,
            abbr = param_abbr,
            hod = param_hod,
            noofemps = param_noofemps,
            costgroup = hr_pkg_common.get_costgroup(param_costgroupid),
            groups = hr_pkg_common.get_costcode(param_groupid),
            cost_type = hr_pkg_common.get_cost_type(param_cost_type_id),
            secretary = param_secretary,
            sdate = param_sdate,
            edate = param_edate,
            sapcc = param_sapcc,
            parent_costcode = hr_pkg_common.get_costcode(param_parent_costcodeid),
            engg_nonengg = param_engg_nonengg
        Where
            costcode = hr_pkg_common.get_costcode(param_costcodeid);

        Commit;
        param_success := 'OK';
        param_message := 'Cost center updated successfully';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_cost_center;

    Procedure deactivate_cost_center(
        param_costcodeid  Char,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
    Begin
        If get_cost_center_linked(param_costcodeid) > 0 Then
            param_success := 'KO';
            param_message := 'Cost center linked as Parent / Group...cannot deactivate !!';
            Return;
        End If;

        Update
            hr_costmast_main
        Set
            active = 0
        Where
            costcodeid = param_costcodeid;

        Update
            costmast
        Set
            active = 0
        Where
            costcode = hr_pkg_common.get_costcode(param_costcodeid);

        Commit;
        param_success := 'OK';
        param_message := 'Cost center deactivated !!';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End deactivate_cost_center;

    Function get_cost_center_linked(
        param_costcodeid Char
    ) Return Number Is
        n_count Number;
    Begin
        Select
            Count(costcodeid)
        Into
            n_count
        From
            hr_costmast_main
        Where
            (groupid                 = param_costcodeid
                Or parent_costcodeid = param_costcodeid)
            And active               = 1;

        If n_count = 0 Then
            Select
                Count(empno)
            Into
                n_count
            From
                hr_emplmast_main
            Where
                (parent       = hr_pkg_common.get_costcode(param_costcodeid)
                    Or assign = hr_pkg_common.get_costcode(param_costcodeid))
                And status    = 1;

        End If;

        Return n_count;
    End; --get_cost_center_linked;

    Function fn_costcode_list_4_utilities(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        v_isdate             Boolean := false;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        costcode,
                        name,
                        abbr,
                        sapcc,
                        initcap(hr_pkg_common.get_employee_name(hod) || ' [ ' || hod || ' ]') hod,
                        Row_Number() Over (Order By costcode)                                 row_number,
                        Count(*) Over ()                                                      total_row
                    From
                        costmast
                    Where
                        active = 1
                        And (
                            upper(costcode) Like upper('%' || p_generic_search || '%') Or
                            upper(name) Like upper('%' || p_generic_search || '%') Or
                            upper(abbr) Like upper('%' || p_generic_search || '%') Or
                            upper(sapcc) Like upper('%' || p_generic_search || '%') Or
                            upper(hod) Like upper('%' || p_generic_search || '%') Or
                            upper(hr_pkg_common.get_employee_name(hod)) Like upper('%' || p_generic_search || '%')
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                costcode;
        Return c;
    End fn_costcode_list_4_utilities;

    Procedure sp_dg_empl_costcode_update(
        p_person_id          Varchar2 Default Null,
        p_meta_id            Varchar2 Default Null,

        p_empno              Varchar2,
        p_transfer_type      Varchar2,
        p_costcode           Varchar2 Default Null,
        p_desgcode           Varchar2 Default Null,
        p_job_group_code     Varchar2 Default Null,
        p_jobdiscipline_code Varchar2 Default Null,
        p_jobtitle_code      Varchar2 Default Null,

        p_message_type Out   Varchar2,
        p_message_text Out   Varchar2) As
        v_empno         Varchar2(5);
        v_hod           Varchar2(5);
        v_job_group     hr_jobgroup_master.job_group%Type;
        v_jobdiscipline hr_jobdiscipline_master.jobdiscipline%Type;
        v_jobtitle      hr_jobtitle_master.jobtitle%Type;
    Begin
        If p_meta_id Is Not Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                p_message_type := not_ok;
                p_message_text := 'Employee not found';
            End If;
        End If;

        Select
            hod
        Into
            v_hod
        From
            costmast
        Where
            costcode = Trim(p_costcode);

        If p_transfer_type = 'Permanent' Then
            Select
                job_group
            Into
                v_job_group
            From
                hr_jobgroup_master
            Where
                job_group_code = Trim(p_job_group_code);

            Select
                jobdiscipline
            Into
                v_jobdiscipline
            From
                hr_jobdiscipline_master
            Where
                jobdiscipline_code = Trim(p_jobdiscipline_code);

            Select
                jobtitle
            Into
                v_jobtitle
            From
                hr_jobtitle_master
            Where
                jobtitle_code = Trim(p_jobtitle_code);

            Update
                emplmast
            Set
                parent = Trim(p_costcode),
                assign = Trim(p_costcode),
                desgcode = Trim(p_desgcode),
                mngr = v_hod,
                emp_hod = v_hod,
                jobgroup = p_job_group_code,
                jobgroupdesc = v_job_group,
                jobdiscipline = p_jobdiscipline_code,
                jobdisciplinedesc = v_jobdiscipline,
                jobtitle_code = p_jobtitle_code,
                jobtitle = v_jobtitle
            Where
                empno      = Trim(p_empno)
                And status = 1;

            Update
                hr_emplmast_main
            Set
                parent = Trim(p_costcode),
                assign = Trim(p_costcode),
                desgcode = Trim(p_desgcode)
            Where
                empno      = Trim(p_empno)
                And status = 1;

            Update
                hr_emplmast_misc
            Set
                jobgroup = p_job_group_code,
                jobgroupdesc = v_job_group,
                jobdiscipline = p_jobdiscipline_code,
                jobdisciplinedesc = v_jobdiscipline,
                jobtitle_code = p_jobtitle_code,
                jobtitledesc = v_jobtitle
            Where
                empno = Trim(p_empno);
                
            Update
                hr_emplmast_organization
            Set
                mngr = v_hod,
                emp_hod = v_hod
            Where
                empno = Trim(p_empno);
        Else
            Update
                emplmast
            Set
                assign = nvl(Trim(p_costcode), parent)
            Where
                empno      = Trim(p_empno)
                And status = 1;

            Update
                hr_emplmast_main
            Set
                assign = nvl(Trim(p_costcode), parent)
            Where
                empno      = Trim(p_empno)
                And status = 1;
        End If;        

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_dg_empl_costcode_update;

End hr_pkg_costmast_main;
/
Grant Execute On "TIMECURR"."HR_PKG_COSTMAST_MAIN" To "TCMPL_APP_CONFIG";