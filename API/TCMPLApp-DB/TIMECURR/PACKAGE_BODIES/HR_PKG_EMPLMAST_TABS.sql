--------------------------------------------------------
--  DDL for Package Body HR_PKG_EMPLMAST_TABS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."HR_PKG_EMPLMAST_TABS" As

    Procedure update_organization_tab (
        p_empno                 Varchar2,
        p_dol                   Date,
        p_dor                   Date,
        p_mngr                  Varchar2,
        p_emp_hod               Varchar2,
        p_location              Varchar2,
        p_sapemp                Varchar2,
        p_itno                  Varchar2,
        p_contract_end_date     Date,
        p_subcontract           Varchar2,
        p_cid                   Varchar2,
        p_bankcode              Varchar2,
        p_acctno                Varchar2,
        p_ifscno                Varchar2,
        p_graduation            Varchar2,
        p_place                 Varchar2,
        p_qualification         Varchar2,
        p_tit_cd                Varchar2,
        p_job_title             Varchar2,
        p_gradyear              Varchar2,
        p_expbefore             Decimal,
        p_qual_group            Number,
        p_gratutityno           Varchar2,
        p_aadharno              Varchar2,
        p_pfno                  Varchar2,
        p_superannuationno      Varchar2,
        p_uanno                 Varchar2,
        p_pensionno             Varchar2,
        p_diploma_year          Varchar2,
        p_postgraduation_year   Varchar2,
        
        p_success               Out Varchar2,
        p_message               Out Varchar2
    ) As
    Begin
        If (To_Number(Nvl(p_postgraduation_year, Nvl(p_gradyear, Nvl(p_diploma_year, 0)))) < 
            To_Number(Nvl(p_gradyear, Nvl(p_diploma_year, 0)))) 
            Or
            (To_Number(Nvl(p_gradyear, Nvl(p_diploma_year, 0))) < To_Number(Nvl(p_diploma_year, 0))) Then
            p_success := 'KO';
            p_message := 'Year of Diploma / Graduation / Postgraduation not in order';
            Return;
        End If;
        
    
        ins_del_emplmast_qualification(p_empno, p_qualification, p_success, p_message);
        If p_success = 'OK' Then
            Update hr_emplmast_organization
            Set
                dol = p_dol,
                dor = p_dor,
                mngr = p_mngr,
                emp_hod = p_emp_hod,
                location = p_location,
                sapemp = p_sapemp,
                itno = p_itno,
                contract_end_date = p_contract_end_date,
                subcontract = p_subcontract,
                cid = p_cid,
                bankcode = p_bankcode,
                acctno = p_acctno,
                ifscno = p_ifscno,
                graduation = p_graduation,
                place = p_place,
                tit_cd = p_tit_cd,
                gradyear = p_gradyear,
                expbefore = p_expbefore,
                qual_group = p_qual_group,
                gratutityno = p_gratutityno,
                aadharno = p_aadharno,
                pfno = p_pfno,
                superannuationno = p_superannuationno,
                uanno = p_uanno,
                pensionno = p_pensionno,
                diploma_year = p_diploma_year,
                postgraduation_year = p_postgraduation_year
            Where
                empno = p_empno;

            Update emplmast
            Set
                dol = p_dol,
                dor = p_dor,
                mngr = p_mngr,
                emp_hod = p_emp_hod,
                location = p_location,
                sapemp = p_sapemp,
                itno = p_itno,
                contract_end_date = p_contract_end_date,
                subcontract = p_subcontract,
                cid = p_cid,
                bankcode = p_bankcode,
                acctno = p_acctno,
                ifscno = p_ifscno,
                graduation = hr_pkg_common.get_graduation(p_graduation),
                place = hr_pkg_common.get_place(p_place),
                jobtitle = p_job_title,
                gradyear = p_gradyear,
                expbefore = p_expbefore,
                qual_group = p_qual_group,
                gratutityno = p_gratutityno,
                aadharno = p_aadharno,
                pfno = p_pfno,
                superannuationno = p_superannuationno,
                uanno = p_uanno,
                pensionno = p_pensionno,
                diploma_year = p_diploma_year,
                postgraduation_year = p_postgraduation_year
            Where
                empno = p_empno;

            p_success := 'OK';
            p_message := 'Organization details updated successfully';
        Else
            Return;
        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_organization_tab;

    Procedure update_address_tab (
        p_empno   Varchar2,
        p_add1    Varchar2,
        p_add2    Varchar2,
        p_add3    Varchar2,
        p_add4    Varchar2,
        p_pincode Number,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
    Begin
        Update hr_emplmast_address
        Set
            add1 = p_add1,
            add2 = p_add2,
            add3 = p_add3,
            add4 = p_add4,
            pincode = p_pincode
        Where
            empno = p_empno;

      /* Update EMPLMAST */
        Update emplmast
        Set
            add1 = p_add1,
            add2 = p_add2,
            add3 = p_add3,
            add4 = p_add4,
            pincode = p_pincode
        Where
            empno = p_empno;

        p_success := 'OK';
        p_message := 'Address details updated successfully';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_address_tab;

    Procedure update_applications_tab (
        p_empno        Varchar2,
        p_expatriate   Number,
        p_hr_opr       Number,
        p_inv_auth     Number,
        p_job_incharge Number,
        p_newemp       Number,
        p_payroll      Number,
        p_proc_opr     Number,
        p_seatreq      Number,
        p_submit       Number,
        p_success      Out Varchar2,
        p_message      Out Varchar2
    ) As
    Begin
        Update hr_emplmast_applications
        Set
            expatriate = p_expatriate,
            hr_opr = p_hr_opr,
            inv_auth = p_inv_auth,
            job_incharge = p_job_incharge,
            newemp = p_newemp,
            payroll = p_payroll,
            proc_opr = p_proc_opr,
            seatreq = p_seatreq,
            submit = p_submit
        Where
            empno = p_empno;

      /* Update EMPLMAST */
        Update emplmast
        Set
            expatriate = p_expatriate,
            hr_opr = p_hr_opr,
            inv_auth = p_inv_auth,
            job_incharge = p_job_incharge,
            newemp = p_newemp,
            payroll = p_payroll,
            proc_opr = p_proc_opr,
            seatreq = p_seatreq,
            submit = p_submit
        Where
            empno = p_empno;

        p_success := 'OK';
        p_message := 'Applications detail updated successfully';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_applications_tab;

    Procedure update_roles_tab (
        p_empno     Varchar2,
        p_amfi_auth Number,
        p_amfi_user Number,
        p_costdy    Number,
        p_costhead  Number,
        p_costopr   Number,
        p_dba       Number,
        p_director  Number,
        p_dirop     Number,
        p_projdy    Number,
        p_projmngr  Number,
        p_success   Out Varchar2,
        p_message   Out Varchar2
    ) As
    Begin
        Update hr_emplmast_roles
        Set
            amfi_auth = p_amfi_auth,
            amfi_user = p_amfi_user,
            costdy = p_costdy,
            costhead = p_costhead,
            costopr = p_costopr,
            dba = p_dba,
            director = p_director,
            dirop = p_dirop,
            projdy = p_projdy,
            projmngr = p_projmngr
        Where
            empno = p_empno;

      /* Update EMPLMAST */
        Update emplmast
        Set
            amfi_auth = p_amfi_auth,
            amfi_user = p_amfi_user,
            costdy = p_costdy,
            costhead = p_costhead,
            costopr = p_costopr,
            dba = p_dba,
            director = p_director,
            dirop = p_dirop,
            projdy = p_projdy,
            projmngr = p_projmngr
        Where
            empno = p_empno;

        p_success := 'OK';
        p_message := 'Roles detail updated successfully';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_roles_tab;

    Procedure update_misc_tab (
        p_empno                Varchar2,
        p_dept_code            Varchar2,
        p_eow                  Varchar2,
        p_eow_date             Date,
        p_eow_week             Number,
        p_esi_cover            Number,
        p_ipadd                Varchar2,
        p_jobcategoorydesc     Varchar2,
        p_jobcategory          Varchar2,
        p_jobdiscipline        Varchar2,
        p_jobgroup             Varchar2,
        p_jobsubcategory       Varchar2,
        p_jobsubcategorydesc   Varchar2,
        p_jobsubdiscipline     Varchar2,
        p_jobsubdisciplinedesc Varchar2,
        p_jobtitle_code        Varchar2,
        p_lastday              Date,
        p_loc_id               Varchar2,
        p_no_tcm_upd           Number,
        p_oldco                Varchar2,
        p_ondeputation         Number,
        p_pfslno               Varchar2,
        p_projno               Varchar2,
        p_pwd                  Raw,
        p_reporting            Number,
        p_reporto              Varchar2,
        p_secretary            Number,
        p_trans_in             Date,
        p_trans_out            Date,
        p_user_domain          Varchar2,
        p_userid               Number,
        p_web_itdecl           Number,
        p_winid_reqd           Number,
        p_success              Out Varchar2,
        p_message              Out Varchar2
    ) As
    Begin
        Update hr_emplmast_misc
        Set
            dept_code = p_dept_code,
            eow = p_eow,
            eow_date = p_eow_date,
            eow_week = p_eow_week,
            esi_cover = p_esi_cover,
            ipadd = p_ipadd,
            jobcategoorydesc = p_jobcategoorydesc,
            jobcategory = p_jobcategory,
            jobdiscipline = p_jobdiscipline,
            jobdisciplinedesc = hr_pkg_common.get_jobdiscipline_desc(p_jobdiscipline),
            jobgroup = p_jobgroup,
            jobgroupdesc = hr_pkg_common.get_jobgroup_desc(p_jobgroup),
            jobsubcategory = p_jobsubcategory,
            jobsubcategorydesc = p_jobsubcategorydesc,
            jobsubdiscipline = p_jobsubdiscipline,
            jobsubdisciplinedesc = p_jobsubdisciplinedesc,
            jobtitle_code = p_jobtitle_code,
            jobtitledesc = hr_pkg_common.get_jobtitle_desc(p_jobtitle_code),
            jobgroupdesc_milan = hr_pkg_common.get_jobgroup_milan_desc(p_jobgroup),
            lastday = p_lastday,
            loc_id = p_loc_id,
            no_tcm_upd = p_no_tcm_upd,
            oldco = p_oldco,
            ondeputation = p_ondeputation,
            pfslno = p_pfslno,
            projno = p_projno,
            pwd = p_pwd,
            reporting = p_reporting,
            reporto = p_reporto,
            secretary = p_secretary,
            trans_in = p_trans_in,
            trans_out = p_trans_out,
            user_domain = p_user_domain,
            userid = p_userid,
            web_itdecl = p_web_itdecl,
            winid_reqd = p_winid_reqd
        Where
            empno = p_empno;

      /* Update EMPLMAST */
        Update emplmast
        Set
            dept_code = p_dept_code,
            eow = p_eow,
            eow_date = p_eow_date,
            eow_week = p_eow_week,
            esi_cover = p_esi_cover,
            ipadd = p_ipadd,
            jobcategoorydesc = p_jobcategoorydesc,
            jobcategory = p_jobcategory,
            jobdiscipline = p_jobdiscipline,
            jobdisciplinedesc = hr_pkg_common.get_jobdiscipline_desc(p_jobdiscipline),
            jobgroup = p_jobgroup,
            jobgroupdesc = hr_pkg_common.get_jobgroup_desc(p_jobgroup),
            jobsubcategory = p_jobsubcategory,
            jobsubcategorydesc = p_jobsubcategorydesc,
            jobsubdiscipline = p_jobsubdiscipline,
            jobsubdisciplinedesc = p_jobsubdisciplinedesc,
            jobtitle_code = p_jobtitle_code,
            jobtitledesc = hr_pkg_common.get_jobtitle_desc(p_jobtitle_code),
            jobgroupdesc_milan = hr_pkg_common.get_jobgroup_milan_desc(p_jobgroup),
            lastday = p_lastday,
            loc_id = p_loc_id,
            no_tcm_upd = p_no_tcm_upd,
            oldco = p_oldco,
            ondeputation = p_ondeputation,
            pfslno = p_pfslno,
            projno = p_projno,
            pwd = p_pwd,
            reporting = p_reporting,
            reporto = p_reporto,
            secretary = p_secretary,
            trans_in = p_trans_in,
            trans_out = p_trans_out,
            user_domain = p_user_domain,
            userid = p_userid,
            web_itdecl = p_web_itdecl,
            winid_reqd = p_winid_reqd
        Where
            empno = p_empno;

        p_success := 'OK';
        p_message := 'Misc detail updated successfully';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End;

    Procedure ins_del_emplmast_qualification (
        p_empno         Varchar2,
        p_qualification Varchar2,
        p_success       Out Varchar2,
        p_message       Out Varchar2
    ) As
        v_qualification_text Varchar2(50) := Null;
    Begin
        If p_qualification Is Null Then
            Delete From hr_emplmast_organization_qual
            Where
                empno = Trim(p_empno);

        Else
            With qualification_list As (
                Select
                    regexp_substr(p_qualification, '[^,]+', 1, level) qualification_id
                From
                    dual
                Connect By
                    regexp_substr(p_qualification, '[^,]+', 1, level) Is Not Null
            )
            Select
                Listagg(qualification, ', ') Within Group(
                Order By
                    qualification
                )
            Into v_qualification_text
            From
                hr_qualification_master hqm,
                qualification_list      ql
            Where
                hqm.qualification_id = ql.qualification_id;

            If length(v_qualification_text) > 50 Then
                p_success := 'KO';
                p_message := 'Qualification is more than 50 characters !!!';
                Return;
            End If;

            Delete From hr_emplmast_organization_qual
            Where
                hr_emplmast_organization_qual.qualification_id Not In (
                    Select
                        regexp_substr(p_qualification, '[^,]+', 1, level) qualification_id
                    From
                        dual
                    Connect By
                        regexp_substr(p_qualification, '[^,]+', 1, level) Is Not Null
                )
                And hr_emplmast_organization_qual.empno = Trim(p_empno);

            Insert Into hr_emplmast_organization_qual
                With qualification_list As (
                    Select
                        regexp_substr(p_qualification, '[^,]+', 1, level) qualification_id
                    From
                        dual
                    Connect By
                        regexp_substr(p_qualification, '[^,]+', 1, level) Is Not Null
                )
                Select
                    p_empno,
                    qualification_list.qualification_id
                From
                    qualification_list
                Where
                    qualification_list.qualification_id Not In (
                        Select
                            qualification_id
                        From
                            hr_emplmast_organization_qual
                        Where
                            empno = Trim(p_empno)
                    );

        End If;
        /* Update EMPLMAST */
        Update emplmast
        Set
            qualification = v_qualification_text
        Where
            empno = p_empno;

        p_success := 'OK';
        p_message := 'OK';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End;

End hr_pkg_emplmast_tabs;

/
