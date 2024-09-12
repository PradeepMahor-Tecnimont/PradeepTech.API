--------------------------------------------------------
--  DDL for Package Body HR_PKG_COMMON
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."HR_PKG_COMMON" As

    Function get_emp_abbreviation (
        p_empno Char
    ) Return Char As
        v_abbr hr_emplmast_main.abbr%Type;
    Begin
        Select
            abbr
        Into v_abbr
        From
            hr_emplmast_main
        Where
            empno = p_empno;

        Return v_abbr;
    Exception
        When Others Then
            Return Null;
    End; --get_emp_abbreviation;

    Function get_employee_name (
        p_empno Char
    ) Return Varchar2 As
        v_name hr_emplmast_main.name%Type;
    Begin
        Select
            name
        Into v_name
        From
            hr_emplmast_main
        Where
            empno = p_empno;

        Return v_name;
    Exception
        When Others Then
            Return Null;
    End; --get_employee_name;

    Function get_costcode (
        p_costcodeid Char
    ) Return Char As
        v_costcode hr_costmast_main.costcode%Type;
    Begin
        Select
            costcode
        Into v_costcode
        From
            hr_costmast_main
        Where
            costcodeid = p_costcodeid;

        Return v_costcode;
    Exception
        When Others Then
            Return Null;
    End; --get_costcode;

    Function get_costcenter_name (
        p_costcode Char
    ) Return Varchar2 As
        v_name hr_costmast_main.name%Type;
    Begin
        Select
            name
        Into v_name
        From
            hr_costmast_main
        Where
            costcode = p_costcode;

        Return v_name;
    Exception
        When Others Then
            Return Null;
    End; --get_costcenter_name;

    Function get_costcenter_abbr (
        p_costcode Char
    ) Return Varchar2 As
        v_abbr hr_costmast_main.abbr%Type;
    Begin
        Select
            abbr
        Into v_abbr
        From
            hr_costmast_main
        Where
            costcode = p_costcode;

        Return v_abbr;
    Exception
        When Others Then
            Return Null;
    End; --get_costcenter_name;

    Function get_costcenter_hod (
        p_costcode Char
    ) Return Varchar2 As
        v_hod hr_costmast_main.hod%Type;
    Begin
        Select
            hod
        Into v_hod
        From
            hr_costmast_main
        Where
            costcode = p_costcode;

        Return v_hod;
    End; --get_costcenter_hod;

    Function get_costgroup (
        p_costgroupid Char
    ) Return Char As
        v_costgroup hr_costgroup_master.costgroup%Type;
    Begin
        Select
            costgroup
        Into v_costgroup
        From
            hr_costgroup_master
        Where
            costgroupid = p_costgroupid;

        Return v_costgroup;
    Exception
        When Others Then
            Return Null;
    End; --get_costgroup;

    Function get_costgroup_name (
        p_costgroupid Char
    ) Return Varchar2 As
        v_costgroup_name hr_costgroup_master.description%Type;
    Begin
        Select
            description
        Into v_costgroup_name
        From
            hr_costgroup_master
        Where
            costgroupid = p_costgroupid;

        Return v_costgroup_name;
    Exception
        When Others Then
            Return Null;
    End; --get_costgroup_name;

    Function get_cost_type (
        p_cost_type_id Char
    ) Return Char As
        v_cost_type hr_cost_type_master.cost_type%Type;
    Begin
        Select
            cost_type
        Into v_cost_type
        From
            hr_cost_type_master
        Where
            cost_type_id = p_cost_type_id;

        Return v_cost_type;
    Exception
        When Others Then
            Return Null;
    End; --get_cost_type;

    Function get_cost_type_name (
        p_cost_type_id Char
    ) Return Varchar2 As
        v_cost_type_name hr_cost_type_master.description%Type;
    Begin
        Select
            description
        Into v_cost_type_name
        From
            hr_cost_type_master
        Where
            cost_type_id = p_cost_type_id;

        Return v_cost_type_name;
    Exception
        When Others Then
            Return Null;
    End; --get_cost_type_name;


    Function get_comp_report (
        p_cmid Char
    ) Return Char As
        v_comp hr_comp_report_master.comp%Type;
    Begin
        Select
            comp
        Into v_comp
        From
            hr_comp_report_master
        Where
            cmid = p_cmid;

        Return v_comp;
    Exception
        When Others Then
            Return Null;
    End; --get_comp_report;

    Function get_comp_report_name (
        p_cmid Char
    ) Return Varchar2 As
        v_description hr_comp_report_master.description%Type;
    Begin
        Select
            description
        Into v_description
        From
            hr_comp_report_master
        Where
            cmid = p_cmid;

        Return v_description;
    Exception
        When Others Then
            Return Null;
    End; --get_comp_report_name;
    
    Function get_sap_cc_name (
        p_costcode Char
    ) Return Varchar2 as
        v_sapcc hr_costmast_main.sapcc%Type;
    Begin
        Select
            sapcc
          Into v_sapcc
        From
            hr_costmast_main
        Where
            costcode = p_costcode;    
        Return v_sapcc;
      Exception
        When Others Then
            Return Null;
    End; --get_sap_cc_name;
    
    Function get_tcm_act_ph (
        p_tcm_act_ph_id Char
    ) Return Char As
        v_tcm_act_ph hr_tcm_act_ph_master.tcm_act_ph%Type;
    Begin
        Select
            tcm_act_ph
        Into v_tcm_act_ph
        From
            hr_tcm_act_ph_master
        Where
            tcm_act_ph_id = p_tcm_act_ph_id;

        Return v_tcm_act_ph;
    Exception
        When Others Then
            Return Null;
    End; --get_tcm_act_ph;

    Function get_tcm_act_ph_name (
        p_tcm_act_ph_id Char
    ) Return Varchar2 As
        v_description hr_tcm_act_ph_master.description%Type;
    Begin
        Select
            description
        Into v_description
        From
            hr_tcm_act_ph_master
        Where
            tcm_act_ph_id = p_tcm_act_ph_id;

        Return v_description;
    Exception
        When Others Then
            Return Null;
    End; --get_tcm_act_ph_name;

    Function get_tcm_pas_ph (
        p_tcm_pas_ph_id Char
    ) Return Char As
        v_tcm_pas_ph hr_tcm_pas_ph_master.tcm_pas_ph%Type;
    Begin
        Select
            tcm_pas_ph
        Into v_tcm_pas_ph
        From
            hr_tcm_pas_ph_master
        Where
            tcm_pas_ph_id = p_tcm_pas_ph_id;

        Return v_tcm_pas_ph;
    Exception
        When Others Then
            Return Null;
    End; --get_tcm_pas_ph;

    Function get_tcm_pas_ph_name (
        p_tcm_pas_ph_id Char
    ) Return Varchar2 As
        v_description hr_tcm_pas_ph_master.description%Type;
    Begin
        Select
            description
        Into v_description
        From
            hr_tcm_pas_ph_master
        Where
            tcm_pas_ph_id = p_tcm_pas_ph_id;

        Return v_description;
    Exception
        When Others Then
            Return Null;
    End; --get_tcm_pas_ph_name;

    Function get_tcm_cost_center (
        p_tcmcostcodeid Char
    ) Return Char As
        v_tcm_cc hr_tcm_cost_master.tcm_cc%Type;
    Begin
        Select
            tcm_cc
        Into v_tcm_cc
        From
            hr_tcm_cost_master
        Where
            tcmcostcodeid = p_tcmcostcodeid;

        Return v_tcm_cc;
    Exception
        When Others Then
            Return Null;
    End; --get_tcm_cost_center;

    Function get_tcm_cost_center_name (
        p_tcmcostcodeid Char
    ) Return Varchar2 As
        v_description hr_tcm_cost_master.description%Type;
    Begin
        Select
            description
        Into v_description
        From
            hr_tcm_cost_master
        Where
            tcmcostcodeid = p_tcmcostcodeid;

        Return v_description;
    Exception
        When Others Then
            Return Null;
    End; --get_tcm_cost_center_name;

    Function get_tm01_grp (
        p_tm01id Char
    ) Return Char As
        v_tm01_grp hr_tm01_grp_master.tm01_grp%Type;
    Begin
        Select
            tm01_grp
        Into v_tm01_grp
        From
            hr_tm01_grp_master
        Where
            tm01id = p_tm01id;

        Return v_tm01_grp;
    Exception
        When Others Then
            Return Null;
    End; --get_tm01_grp;

    Function get_tm01_grp_name (
        p_tm01id Char
    ) Return Varchar2 As
        v_description hr_tm01_grp_master.description%Type;
    Begin
        Select
            description
        Into v_description
        From
            hr_tm01_grp_master
        Where
            tm01id = p_tm01id;

        Return v_description;
    Exception
        When Others Then
            Return Null;
    End; --get_tm01_grp_name;

    Function get_tma_grp (
        p_tmaid Char
    ) Return Char As
        v_tma_grp hr_tma_grp_master.tma_grp%Type;
    Begin
        Select
            tma_grp
        Into v_tma_grp
        From
            hr_tma_grp_master
        Where
            tmaid = p_tmaid;

        Return v_tma_grp;
    Exception
        When Others Then
            Return Null;
    End; --get_tma_grp;

    Function get_tma_grp_name (
        p_tmaid Char
    ) Return Varchar2 As
        v_description hr_tma_grp_master.description%Type;
    Begin
        Select
            description
        Into v_description
        From
            hr_tma_grp_master
        Where
            tmaid = p_tmaid;

        Return v_description;
    Exception
        When Others Then
            Return Null;
    End; --get_tma_grp_name;
    
    Function get_tma_grp_4_costcode (
        p_costcode Char
    ) Return Char As
        v_tma_grp hr_tma_grp_master.tma_grp%Type;
      begin
         select 
            ct.tma_grp into v_tma_grp
         from 
            hr_costmast_main cm, 
            hr_costmast_costcontrol cc, 
            hr_tma_grp_master ct
         where 
            cm.costcodeid = cc.costcodeid and 
            cc.tmaid = ct.tmaid and 
            cm.costcode = p_costcode;
         Return v_tma_grp;
      Exception
        When Others Then
            Return Null;
    End; -- get_tma_grp_4_costcode;    
    
    Function get_job_phases_name (
        p_phase Varchar2
    ) Return Varchar2 As
        v_description job_phases.description%Type;
    Begin
        Select
            description
        Into v_description
        From
            job_phases
        Where
            phase = p_phase;

        Return v_description;
    Exception
        When Others Then
            Return Null;
    End; --get_job_phases_name;

    Function is_editable_tab (
        p_empno      Char,
        p_costcodeid Char,
        p_tab        Varchar2
    ) Return Char Is

        v_costcodeid       hr_costmast_main.costcodeid%Type;
        v_role_id          tcmpl_app_config.sec_module_user_roles.role_id%Type;
        v_payroll_role     Char(4) := 'R010';
        v_costcontrol_role Char(4) := 'R012';
        v_afc_role         Char(4) := 'R013';
    Begin
        If p_tab = 'HOD' Then
            Select
                costcodeid
            Into v_costcodeid
            From
                hr_costmast_main
            Where
                    hod = p_empno
                And costcodeid = p_costcodeid
                And active = 1;

            Return 'OK';
        Elsif p_tab = 'MAIN' Then
            Select
                smur.role_id
            Into v_role_id
            From
                tcmpl_app_config.sec_module_user_roles smur,
                tcmpl_app_config.sec_roles             sr
            Where
                    smur.role_id = sr.role_id
                And smur.role_id = v_payroll_role
                And sr.role_is_active = 'OK'
                And smur.empno = p_empno
                And Rownum = 1;

            Return 'OK';
        Elsif p_tab = 'COSTCONTROL' Then
            Select
                smur.role_id
            Into v_role_id
            From
                tcmpl_app_config.sec_module_user_roles smur,
                tcmpl_app_config.sec_roles             sr
            Where
                    smur.role_id = sr.role_id
                And smur.role_id = v_costcontrol_role
                And sr.role_is_active = 'OK'
                And smur.empno = p_empno
                And Rownum = 1;

            Return 'OK';
        Elsif p_tab = 'AFC' Then
            Select
                smur.role_id
            Into v_role_id
            From
                tcmpl_app_config.sec_module_user_roles smur,
                tcmpl_app_config.sec_roles             sr
            Where
                    smur.role_id = sr.role_id
                And smur.role_id = v_afc_role
                And sr.role_is_active = 'OK'
                And smur.empno = p_empno
                And Rownum = 1;

            Return 'OK';
        End If;
    Exception
        When Others Then
            Return 'KO';
    End; --is_editable_tab;

    Function is_editable_emplmast (
        p_empno Char
    ) Return Char Is

        v_role_id         tcmpl_app_config.sec_module_user_roles.role_id%Type;
        v_payroll_role    Char(4) := 'R010';
        v_attendance_role Char(4) := 'R011';
    Begin
        Select
            smur.role_id
        Into v_role_id
        From
            tcmpl_app_config.sec_module_user_roles smur,
            tcmpl_app_config.sec_roles             sr
        Where
                smur.role_id = sr.role_id
            And smur.role_id In ( v_payroll_role, v_attendance_role )
            And sr.role_is_active = 'OK'
            And smur.empno = p_empno
            And Rownum = 1;

        Return 'OK';
    Exception
        When Others Then
            Return 'KO';
    End; --is_editable_emplmast;

    Function get_emp_count_4_desgcode (
        p_desgcode In Char
    ) Return Number Is
        v_cnt Number(4);
    Begin
        Select
            Count(empno)
        Into v_cnt
        From
            emplmast
        Where
            desgcode = p_desgcode;

        Return v_cnt;
    Exception
        When Others Then
            Return -1;
    End; --get_emp_count_4_desgcode

    Function get_leaving_reason (
        p_reasonid In Varchar2
    ) Return Varchar2 As
        v_desc Varchar2(100);
    Begin
        Select
            reasondesc
        Into v_desc
        From
            hr_leavingreason_master
        Where
            reasonid = p_reasonid;

        Return v_desc;
    Exception
        When Others Then
            Return '';
    End; --get_leaving_reason

    Function get_subcontract_4_empno (
        p_empno In Varchar2
    ) Return Varchar2 As
        v_id Varchar2(100);
    Begin
        Select
            subcontract
        Into v_id
        From
            hr_emplmast_organization
        Where
            empno = p_empno;

        Return v_id;
    Exception
        When Others Then
            Return '';
    End; --get_subcontract_4_empno

    Function get_subcontract_name (
        p_subcontract In Varchar2
    ) Return Varchar2 As
        v_desc Varchar2(100);
    Begin
        Select
            description
        Into v_desc
        From
            subcontractmast
        Where
            subcontract = p_subcontract;

        Return v_desc;
    Exception
        When Others Then
            Return '';
    End; --get_subcontract_name

    Function get_designation (
        p_desgcode In Varchar2
    ) Return Varchar2 As
        v_desg Varchar2(100);
    Begin
        Select
            desg
        Into v_desg
        From
            desgmast
        Where
            desgcode = p_desgcode;

        Return v_desg;
    Exception
        When Others Then
            Return '';
    End; --get_designation


    Function get_place (
        p_place In Varchar2
    ) Return Varchar2 As
        v_place Varchar2(50);
    Begin
        Select
            place_desc
        Into v_place
        From
            hr_place_master
        Where
            place_id = p_place;

        Return v_place;
    Exception
        When Others Then
            Return Null;
    End; --get_place

    Function get_graduation (
        p_graduation In Varchar2
    ) Return Varchar2 As
        v_graduation Varchar2(15);
    Begin
        Select
            graduation_desc
        Into v_graduation
        From
            hr_graduation_master
        Where
            graduation_id = p_graduation;

        Return v_graduation;
    Exception
        When Others Then
            Return Null;
    End; --get_graduation

    Function get_qualification (
        p_empno In Char
    ) Return Varchar2 As
        v_qualification Varchar2(100);
    Begin
        Select
            Listagg(qualification, ', ') Within Group(
            Order By
                qualification
            )
        Into v_qualification
        From
            hr_qualification_master hqm
        Where
            Exists (
                Select
                    *
                From
                    hr_emplmast_organization_qual heoq
                Where
                        heoq.qualification_id = hqm.qualification_id
                    And empno = p_empno
            );

        Return v_qualification;
    Exception
        When Others Then
            Return '';
    End; --get_qualification


    Function get_job_title (
        p_tit_cd In Varchar2
    ) Return Varchar2 As
        v_job_title job_tit.title%Type;
    Begin
        Select
            jt.title
        Into v_job_title
        From
            job_tit jt
        Where
            jt.tit_cd = Trim(p_tit_cd);

        Return v_job_title;
    Exception
        When Others Then
            Return Null;
    End; --get_job_title      


    Function get_job_title_detailed (
        p_tit_cd In Varchar2
    ) Return Varchar2 As
        v_job_title Varchar2(300);
    Begin
        Select Distinct
            Case jt.title
                When Null Then
                    Null
                Else
                    jt.title
                    || ' [ Job group : '
                    || jg.grp_cd
                    || ' - '
                    || jg.grp_name
                    || ' :: '
                    || 'Job discipline : '
                    || jd.dis_cd
                    || ' - '
                    || jd.dis_name
                    || ' ]'
            End
        Into v_job_title
        From
            job_tit jt,
            job_grp jg,
            job_dis jd
        Where
                jg.grp_cd = jd.grp_cd
            And jd.grp_cd = jt.grp_cd
            And jd.dis_cd = jt.dis_cd
            And jt.tit_cd = Trim(p_tit_cd);

        Return v_job_title;
    Exception
        When Others Then
            Return Null;
    End; --get_job_title_detailed
    
    Function get_age_group (
       p_age in number
    ) return varchar2 As
        v_age_group Varchar2(10);        
    Begin
      for rec in (select age_group_id, min_age, max_age from hr_age_group)
      loop
        if rec.min_age <= p_age and rec.max_age >= p_age then
          v_age_group := rec.age_group_id;
          exit;
        end if;
      end loop; 
    
      Return v_age_group;
    Exception
        When Others Then
            Return '';
    End; -- get_age_group
    
    Function get_experience_group (
       p_year in number
    ) return varchar2 As
        v_experience_group Varchar2(10);        
    Begin
      for rec in (select exp_group_id, min_exp, max_exp from hr_exprerience_group)
      loop
        if rec.min_exp <= p_year and rec.max_exp >= p_year then
          v_experience_group := rec.exp_group_id;
          exit;
        end if;
      end loop; 
    
      Return v_experience_group;
    Exception
        When Others Then
            Return '';
    End; -- get_experience_group
    
    Function get_engg_nonengg_status (
      p_costcode in varchar2
    ) return varchar2 as
      v_cnt number;
      v_status Varchar2(10);        
    Begin
      --select count(costcode) into v_cnt 
      --  from hr_engg_costcode_list 
      --  where costcode = p_costcode;
      select count(costcode) into v_cnt  from ts_costcode_group_costcode 
      where costcode_group_id in ('CG003', 'CG005') and
        costcode = p_costcode;
      if v_cnt = 1 then
        v_status := 'Engg';
      else
       v_status := 'Non Engg';
      end if;
      Return v_status;
    Exception
        When Others Then
            Return '';
    End; -- get_engg_nonengg_status
    
     Function get_manpower_group  (
      p_costcode in varchar2
    ) return varchar2 as
      v_exist_val varchar2(50);
      v_groupname Varchar2(50);        
    Begin
      select details into v_exist_val 
        from ts_costcode_group_costcode 
        where costcode = p_costcode and 
            costcode_group_id in ('CG007', 'CG008');      
      if v_exist_val = '' then
        v_groupname := 'NA';
      else
       v_groupname := v_exist_val;
      end if;
      Return v_groupname;
    Exception
        When Others Then
            Return '';
    End; -- get_manpower_group 
    
    Function get_relieving_date  (
      p_empno in varchar2
    ) return Date as
      v_exist_val Date := null;
    Begin
      select 
        relieving_date 
      into
        v_exist_val
      from 
        tcmpl_hr.ofb_emp_exits 
      where 
        empno = p_empno;
      Return v_exist_val;
    Exception
        When Others Then
            Return null;
    End; -- get_relieving_date
    
    Function get_jobgroup_desc (
        p_jobgroup in varchar2
    ) return varchar2 as
      v_desc    Varchar2(75) := '';
    Begin
        select 
            substr(job_group,1,75)
        Into
            v_desc
        from 
            hr_jobgroup_master 
        where 
            job_group_code = p_jobgroup;
        Return v_desc;
      Exception
        When Others Then
            Return '';
    End get_jobgroup_desc;
    
    Function get_jobgroup_milan_desc (
        p_jobgroup in varchar2
    ) return varchar2 as
      v_desc    Varchar2(75) := '';
    Begin
        select 
            substr(milan_job_group,1,75)
        Into
            v_desc
        from 
            hr_jobgroup_master 
        where 
            job_group_code = p_jobgroup;
        Return v_desc;
      Exception
        When Others Then
            Return '';
    End get_jobgroup_milan_desc;
    
    Function get_jobdiscipline_desc(
        p_jobdiscipline in varchar2
    ) return varchar2 as
      v_desc    Varchar2(75) := '';
    Begin
        select 
            substr(jobdiscipline,1,75)
        Into
            v_desc
        from 
            hr_jobdiscipline_master 
        where 
            jobdiscipline_code = p_jobdiscipline;
        Return v_desc;
      Exception
        When Others Then
            Return '';
    End get_jobdiscipline_desc;
    
    Function get_jobtitle_desc(
        p_jobtitle in varchar2
    ) return varchar2 as
      v_desc    Varchar2(75) := '';
    Begin
        select 
            substr(jobtitle,1,75)
        Into
            v_desc
        from 
            hr_jobtitle_master 
        where 
            jobtitle_code = p_Jobtitle;
        Return v_desc;
      Exception
        When Others Then
            Return '';
    End get_jobtitle_desc;
    
    Function get_secretary_empno(
        p_costcode in varchar2
    ) return varchar2 as
        v_empno    Varchar2(5) := '';
    Begin
        select 
            secretary
        Into
            v_empno
        from 
            hr_costmast_main 
        where 
            costcode = p_costcode;
        Return v_empno;
      Exception
        When Others Then
            Return '';
    End get_secretary_empno;
    
End hr_pkg_common;

/
