using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public static class HRMastersQueries
    {
        // Lists

        #region >>>>>>>>>>> S E L E C T   L I S T S  <<<<<<<<<<<<<<

        public static string CategorySelectList
        {
            get => @"select categoryid DataValueField, categoryid|| ' - ' || categorydesc DataTextField from timecurr.hr_category_master order by categorydesc";
        }

        public static string CostcenterSelectList
        {
            get => @"Select costcode DataValueField, costcode|| ' - ' || Name DataTextField from timecurr.hr_costmast_main
                    where active = 1 order by costcode";
        }

        public static string CostcenterWithEmployeeSelectList
        {
            get => @"Select costcode DataValueField, costcode|| ' - ' || Name DataTextField from timecurr.hr_costmast_main
                    where active = 1 and  noofemps > 0  order by costcode";
        }

        public static string CostcenterIdSelectList
        {
            get => @"Select costcodeid DataValueField, costcode||' '||Name DataTextField from timecurr.hr_costmast_main
                    where active = 1 order by costcode";
        }

        public static string DesignationSelectList
        {
            get => @"select desgcode DataValueField, desgcode|| ' - ' || desg DataTextField from timecurr.desgmast order by desg";
        }

        public static string EmployeeSelectList
        {
            get => @"select empno  DataValueField, empno|| ' - ' ||initcap(name) DataTextField from timecurr.hr_emplmast_main
                    where status = 1 order by empno";
        }

        public static string EmptypeSelectList
        {
            get => @"select emptype DataValueField, emptype|| ' - ' ||empdesc DataTextField from timecurr.emptypemast order by empdesc";
        }

        public static string GenderSelectList
        {
            get => @"select gender_id DataValueField, gender_desc DataTextField from timecurr.hr_gender_master order by gender_desc";
        }

        public static string GradeSelectList
        {
            get => @"select grade_id DataValueField, grade_desc DataTextField from timecurr.hr_grade_master order by grade_desc";
        }

        public static string OfficeSelectList
        {
            get => @"select office DataValueField, name DataTextField from timecurr.offimast order by name";
        }

        public static string CompanySelectList
        {
            get => @"select company DataValueField, company_name DataTextField from timecurr.company_master order by company_name";
        }

        public static string CostGroupSelectList
        {
            get => @"Select CostGroupId DataValueField, CostGroup ||'  '|| Description DataTextField From timecurr.hr_CostGroup_Master Order By CostGroup";
        }

        public static string TM01GRPSelectList
        {
            get => @"Select TM01Id DataValueField, TM01_Grp ||'  '|| Description DataTextField From timecurr.hr_TM01_Grp_Master Order By TM01_Grp";
        }

        public static string TMAGRPSelectList
        {
            get => @"Select TMAId DataValueField, TMA_Grp ||'  '|| Description DataTextField From timecurr.hr_TMA_Grp_Master Order By TMA_Grp";
        }

        public static string CostTypeSelectList
        {
            get => @"Select Cost_Type_Id DataValueField, Cost_Type ||'  '|| Description DataTextField From timecurr.hr_Cost_Type_Master Order By Cost_Type_Id";
        }

        public static string CompanyReportSelectList
        {
            get => @"Select CMId DataValueField, Comp ||'  '|| Description DataTextField From timecurr.hr_Comp_Report_Master Order By Comp";
        }

        public static string TCMCostCenterSelectList
        {
            get => @"Select TCMCostCodeId DataValueField, TCM_CC ||'  '|| Description DataTextField From timecurr.hr_TCM_Cost_Master Order By TCM_CC";
        }

        public static string TCMActPhSelectList
        {
            get => @"Select TCM_Act_Ph_Id DataValueField, TCM_Act_Ph ||'  '|| Description DataTextField From timecurr.hr_TCM_Act_Ph_Master Order By TCM_Act_Ph";
        }

        public static string TCMPasPhSelectList
        {
            get => @"Select TCM_Pas_Ph_Id DataValueField, TCM_Pas_Ph ||'  '|| Description DataTextField From timecurr.hr_TCM_Pas_Ph_Master Order By TCM_Pas_Ph";
        }

        public static string JobPhasesSelectList
        {
            get => @"Select Phase DataValueField, Phase ||'  '|| Description DataTextField From timecurr.job_phases
                    Where company = (Select comp From timecurr.hr_Comp_Report_Master Where cmid = :pCmId)
                    Order By phase";
        }

        public static string LocationSelectList
        {
            get => @"Select LocationId DataValueField, LocationId ||' - '|| Location DataTextField From timecurr.hr_location_master Order By Location";
        }

        public static string SubContractSelectList
        {
            get => @"Select Subcontract DataValueField, Subcontract ||' - '|| Description DataTextField From timecurr.subcontractmast Order By Description";
        }

        public static string BankcodeSelectList
        {
            get => @"Select Bankcode DataValueField, Bankcode ||'  '|| Bankcodedesc DataTextField From timecurr.hr_bankcode_master Order By Bankcodedesc";
        }

        public static string LeavingReasonSelectList
        {
            get => @"Select reasonid DataValueField, reasonid||' - '||reasondesc DataTextField from timecurr.hr_leavingreason_master
                    order by reasondesc";
        }

        public static string PlaceSelectList
        {
            get => @"Select place_id DataValueField, place_desc DataTextField from timecurr.hr_place_master
                    order by place_desc";
        }

        public static string GraduationSelectList
        {
            get => @"Select graduation_id DataValueField, graduation_desc DataTextField from timecurr.hr_graduation_master
                    order by graduation_desc";
        }

        public static string QualificationSelectList
        {
            get => @"Select qualification_id DataValueField, qualification DataTextField from timecurr.hr_qualification_master
                    order by qualification";
        }

        public static string JobGroupSelectList
        {
            get => @"Select grp_cd DataValueField, grp_cd || ' - ' || grp_name DataTextField from timecurr.job_grp
                    order by grp_cd";
        }

        public static string JobGroupJobDisciplineSelectList
        {
            get => @"Select Distinct
                        jd.grp_cd
                        || ';::;'
                        || jd.dis_cd   DataValueField,
                        jd.dis_cd
                        || ' - '
                        || jd.dis_name DataTextField,
                        jg.grp_cd
                        || ' - '
                        || jg.grp_name DataGroupField
                    From
                        timecurr.job_grp jg,
                        timecurr.job_dis jd
                    Where
                        jg.grp_cd = jd.grp_cd
                    Order By
                        jg.grp_cd
                        || ' - '
                        || jg.grp_name,
                        jd.dis_cd
                        || ' - '
                        || jd.dis_name";
        }

        public static string JobGroupJobDisciplineJobTitleSelectList
        {
            get => @"Select Distinct
                        jt.tit_cd  DataValueField,
                        jt.title   DataTextField,
                        jg.grp_name
                        || ' - '
                        || jd.dis_name DataGroupField
                    From
                        timecurr.job_grp jg,
                        timecurr.job_dis jd,
                        timecurr.job_tit jt
                    Where
                            jg.grp_cd = jd.grp_cd
                        And jd.grp_cd = jt.grp_cd
                        And jd.dis_cd = jt.dis_cd
                    Order By
                        jg.grp_name
                        || ' - '
                        || jd.dis_name,
                        jt.title";
        }

        public static string CostcenterEmployeeSelectList
        {
            get => @"Select
                        empno datavaluefield, empno || ' - ' || initcap(name) datatextfield
                    From
                        timecurr.hr_emplmast_main
                    Where
                        status = 1

                    Union

                    Select
                        empno datavaluefield, empno || ' - ' || initcap(name) datatextfield
                    From
                        timecurr.hr_emplmast_main
                    Where
                        empno = :pHod
                    Order By
                        1";
        }

        public static string SecretaryEmployeeSelectList
        {
            get => @"Select
                        empno datavaluefield, empno || ' - ' || initcap(name) datatextfield
                    From
                        timecurr.hr_emplmast_main
                    Where
                        status = 1

                    Union

                    Select
                        empno datavaluefield, empno || ' - ' || initcap(name) datatextfield
                    From
                        timecurr.hr_emplmast_main
                    Where
                        empno In (
                            Select
                                secretary
                            From
                                timecurr.hr_costmast_main
                        )
                    Order By
                        1";
        }

        public static string CostGroupCostcenterIdSelectList
        {
            get => @"Select
                        costcodeid datavaluefield, costcode || ' ' || name datatextfield
                    From
                        timecurr.hr_costmast_main
                    Where
                        active = 1

                    Union

                    Select
                        costcodeid datavaluefield, costcode || ' ' || name datatextfield
                    From
                        timecurr.hr_costmast_main
                    Where
                        costcodeid In (
                            Select
                                groupid
                            From
                                timecurr.hr_costmast_main
                        )
                    Order By
                        1";
        }

        public static string ParentCostCenterCostcenterIdSelectList
        {
            get => @"Select
                        costcodeid datavaluefield, costcode || ' ' || name datatextfield
                    From
                        timecurr.hr_costmast_main
                    Where
                        active = 1

                    Union

                    Select
                        costcodeid datavaluefield, costcode || ' ' || name datatextfield
                    From
                        timecurr.hr_costmast_main
                    Where
                        costcodeid In (
                            Select
                                parent_costcodeid
                            From
                                timecurr.hr_costmast_main
                        )
                    Order By
                        1";
        }

        public static string HRJobGroupSelectList
        {
            get => @"Select
                        job_group_code                          DataValueField,
                        job_group_code || ' - ' || job_group    DataTextField
                    from
                        timecurr.hr_jobgroup_master
                    order by
                        job_group_code";
        }

        public static string HRJobDisciplineSelectList
        {
            get => @"Select
                        jobdiscipline_code                              DataValueField,
                        jobdiscipline_code || ' - ' || jobdiscipline    DataTextField
                    from
                        timecurr.hr_jobdiscipline_master
                    order by
                        jobdiscipline_code";
        }

        public static string HRJobTitleSelectList
        {
            get => @"Select
                        jobtitle_code      DataValueField,
                        jobtitle_code || ' - ' || jobtitle DataTextField
                    from
                        timecurr.hr_jobtitle_master
                    order by
                        jobtitle_code";
        }

        #endregion >>>>>>>>>>> S E L E C T   L I S T S  <<<<<<<<<<<<<<

        #region >>>>>>>>>>> E M P L O Y E E   M A S T E R <<<<<<<<<<<<<<

        public static string EmployeeMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.hr_emplmast_main
                    Where
                        status = 1";
        }

        public static string EmployeeMasterList
        {
            get => @"Select
                        hem.*,
                        timecurr.hr_pkg_common.get_costcenter_abbr(hem.parent) parentabbr,
                        timecurr.hr_pkg_common.get_costcenter_abbr(hem.assign) assignabbr,
                        timecurr.hr_pkg_common.is_editable_emplmast(:pUser) IsEditable
                    From
                        timecurr.hr_emplmast_main hem
                    Order by
                        hem.empno";
        }

        public static string EmployeeMasterDownload
        {
            get => @"select
                        emm.empno,
                        emm.personid,
                        initcap(emm.name) name,
                        decode(emm.status, 1, 'True', 'False') status,
                        decode(ema.payroll, 1, 'True', 'False') payroll,
                        emm.emptype ||'-'||
                        etm.empdesc emptype,
                        emm.email,
                        emm.parent ||'-'||
                        cmm1.abbr parent,
                        emm.assign ||'-'||
                        cmm2.abbr assign,
                        dm.desgcode,
                        dm.desg,
                        emm.grade,
                        gm.gender_desc gender,
                        emm.category,
                        emm.married,
                        to_char(emm.dob, 'dd-Mon-yyyy') dob,
                        to_char(emm.doj, 'dd-Mon-yyyy') doj,
                        to_char(emm.doc, 'dd-Mon-yyyy') doc,
                        to_char(emo.dol, 'dd-Mon-yyyy') dol,
                        to_char(emo.dor, 'dd-Mon-yyyy') dor,
                        timecurr.hr_pkg_common.get_qualification(emo.empno) qualificationdesc,
                        timecurr.hr_pkg_common.get_graduation(emo.graduation) graduationdesc,
                        emo.gradyear,
                        emo.expbefore,
                        emo.location,
                        emo.subcontract ||'-'||
                        timecurr.hr_pkg_common.get_subcontract_name(emo.subcontract) subcontractname,
                        tcmpl_hr.pkg_common.fn_get_office_location_desc(tcmpl_hr.pkg_common.fn_get_emp_office_location(emm.empno)) officelocation,
                        emm.office,
                        emm.metaid,
                        emm.company,
                        emo.mngr,
                        initcap(timecurr.hr_pkg_common.get_employee_name(emo.mngr)) mngr_name,
                        emo.emp_hod,
                        initcap(timecurr.hr_pkg_common.get_employee_name(emo.emp_hod)) emp_hod_name,
                        trim(emad.add1) add1,
                        trim(emad.add2) add2,
                        trim(emad.add3) add3,
                        trim(emad.add4) add4,
                        emad.pincode,
                        emo.itno,
                        emsc.pfslno,
                        emo.pfno,
                        emo.gratutityno,
                        emo.aadharno,
                        emo.superannuationno,
                        emo.uanno,
                        emo.pensionno
                    from
                        timecurr.hr_emplmast_main emm,
                        timecurr.hr_emplmast_organization emo,
                        timecurr.hr_emplmast_applications ema,
                        timecurr.hr_emplmast_address emad,
                        timecurr.hr_emplmast_misc emsc,
                        timecurr.hr_costmast_main cmm1,
                        timecurr.hr_costmast_main cmm2,
                        timecurr.desgmast dm,
                        timecurr.offimast om,
                        timecurr.emptypemast etm,
                        timecurr.hr_gender_master gm
                    where
                        emo.empno = emm.empno and
                        ema.empno = emm.empno and
                        emm.empno = emsc.empno and
                        emm.empno = emad.empno and
                        emm.parent = cmm1.costcode and
                        emm.assign = cmm2.costcode and
                        emm.desgcode = dm.desgcode and
                        emm.emptype = etm.emptype and
                        emm.sex = gm.gender_id(+) and
                        emm.office = om.office and
                        emm.status = :pStatus
                    Order by
                        emm.empno";
        }

        public static string EmployeeMainDetail
        {
            get => @"select
                        emm.empno,
                        initcap(emm.name) name,
                        emm.abbr,
                        emm.emptype,
                        etm.empdesc emptypedesc,
                        emm.email,
                        emm.parent,
                        cmm1.abbr parentabbr,
                        timecurr.hr_pkg_common.get_sap_cc_name(emm.parent)      sap_parent,
                        emm.assign,
                        cmm2.abbr assignabbr,
                        timecurr.hr_pkg_common.get_sap_cc_name(emm.assign)      sap_assign,
                        emm.desgcode,
                        dm.desg,
                        emm.dob,
                        emm.doj,
                        emm.office,
                        om.name officename,
                        emm.sex,
                        gm.gender_desc genderdesc,
                        emm.category,
                        emm.married,
                        emm.metaid,
                        emm.personid,
                        emm.grade,
                        emm.company,
                        emm.doc,
                        emm.firstname,
                        emm.middlename,
                        emm.lastname,
                        emm.status,
                        timecurr.hr_pkg_common.is_editable_emplmast(:pUser) IsEditable
                    from
                        timecurr.hr_emplmast_main emm,
                        timecurr.hr_costmast_main cmm1,
                        timecurr.hr_costmast_main cmm2,
                        timecurr.desgmast dm,
                        timecurr.offimast om,
                        timecurr.emptypemast etm,
                        timecurr.hr_gender_master gm
                    where
                        emm.parent = cmm1.costcode and
                        emm.assign = cmm2.costcode and
                        emm.desgcode = dm.desgcode and
                        emm.emptype = etm.emptype and
                        emm.sex = gm.gender_id(+) and
                        emm.office = om.office and
                        emm.empno = :pEmpno";
        }

        public static string EmployeeMasterAddressDetail
        {
            get => @"select
                        ema.empno,
                        initcap(timecurr.hr_pkg_common.get_employee_name(ema.empno)) name,
                        ema.add1,
                        ema.add2,
                        ema.add3,
                        ema.add4,
                        ema.pincode,
                        emm.status,
                        timecurr.hr_pkg_common.is_editable_emplmast(:pUser) IsEditable
                    from
                        timecurr.hr_emplmast_address ema,
                        timecurr.hr_emplmast_main emm
                    where
                        ema.empno = emm.empno and
                        ema.empno = :pEmpno";
        }

        public static string EmployeeMasterApplicationsDetail
        {
            get => @"select
                        ema.empno,
                        initcap(timecurr.hr_pkg_common.get_employee_name(ema.empno)) name,
                        ema.expatriate,
                        ema.hr_opr,
                        ema.inv_auth,
                        ema.job_incharge,
                        ema.newemp,
                        ema.payroll,
                        ema.proc_opr,
                        ema.seatreq,
                        ema.submit,
                        emm.status,
                        timecurr.hr_pkg_common.is_editable_emplmast(:pUser) IsEditable
                    from
                        timecurr.hr_emplmast_applications ema,
                        timecurr.hr_emplmast_main emm
                    where
                        ema.empno = emm.empno and
                        ema.empno = :pEmpno";
        }

        public static string EmployeeMasterOrganizationDetail
        {
            get => @"select
                        eo.empno,
                        initcap(timecurr.hr_pkg_common.get_employee_name(eo.empno)) name,
                        eo.dol,
                        eo.dor,
                        timecurr.hr_pkg_common.get_secretary_empno(emm.assign) secretary,
                        initcap(timecurr.hr_pkg_common.get_employee_name(timecurr.hr_pkg_common.get_secretary_empno(emm.assign))) secretaryname,
                        eo.mngr,
                        initcap(timecurr.hr_pkg_common.get_employee_name(eo.mngr)) mngr_name,
                        eo.emp_hod,
                        initcap(timecurr.hr_pkg_common.get_employee_name(eo.emp_hod)) emp_hod_name,
                        eo.sapemp,
                        eo.location,
                        lm.location locationdesc,
                        eo.itno,
                        eo.contract_end_date,
                        eo.subcontract,
                        sm.description,
                        eo.cid,
                        eo.bankcode,
                        bm.bankcodedesc,
                        eo.acctno,
                        eo.ifscno,
                        emm.status,
                        eo.reasonid,
                        timecurr.hr_pkg_common.get_leaving_reason(eo.reasonid) reasondesc,
                        pm.place_id place,
                        timecurr.hr_pkg_common.get_place(eo.place) placedesc,
                        eo.graduation,
                        timecurr.hr_pkg_common.get_graduation(eo.graduation) graduationdesc,
                        timecurr.hr_pkg_common.get_qualification(eo.empno) qualificationdesc,
                        timecurr.hr_pkg_common.is_editable_emplmast(:pUser) IsEditable,
                        eo.tit_cd titcd,
                        emsc.jobtitle_code JobTitle,
                        emsc.jobtitledesc JobTitleDetailed,
                        eo.expbefore,
                        eo.gradyear,
                        eo.qual_group,
                        eo.gratutityno,
                        eo.aadharno,
                        eo.pfno,
                        eo.superannuationno,
                        eo.uanno,
                        eo.pensionno,
                        eo.diploma_year,
                        eo.postgraduation_year
                    from
                        timecurr.hr_emplmast_organization eo,
                        timecurr.hr_emplmast_main emm,
                        timecurr.hr_location_master lm,
                        timecurr.subcontractmast sm,
                        timecurr.hr_bankcode_master bm,
                        timecurr.hr_place_master pm,
                        timecurr.hr_emplmast_misc emsc
                    where
                        eo.empno = emm.empno and
                        eo.location = lm.locationid(+) and
                        eo.subcontract = sm.subcontract(+) and
                        eo.bankcode = bm.bankcode(+) and
                        eo.place = pm.place_id(+) and
                        eo.empno = emsc.empno(+) and
                        eo.empno = :pEmpno";
        }

        public static string EmployeeMasterOrganizationQualificationList
        {
            get => @"Select
                        eoq.empno,
                        eoq.qualification_id,
                        gm.qualification_desc
                    From
                        timecurr.hr_emplmast_organization_qual eoq,
                        timecurr.hr_qualification_master gm
                    Where
                        eoq.qualification_id = gm.qualification_id
                        And eoq.empno = :pEmpno
                    Order by gm.qualification_desc";
        }

        public static string EmployeeMasterRolesDetail
        {
            get => @"select
                        emr.empno,
                        initcap(timecurr.hr_pkg_common.get_employee_name(emr.empno)) name,
                        emr.amfi_auth,
                        emr.amfi_user,
                        emr.costdy,
                        emr.costhead,
                        emr.costopr,
                        emr.dba,
                        emr.director,
                        emr.dirop,
                        emr.projdy,
                        emr.projmngr,
                        emm.status,
                        timecurr.hr_pkg_common.is_editable_emplmast(:pUser) IsEditable
                     from
                        timecurr.hr_emplmast_roles emr,
                        timecurr.hr_emplmast_main emm
                     where
                        emr.empno = emm.empno and
                        emr.empno = :pEmpno";
        }

        public static string EmployeeMasterMiscDetail
        {
            get => @"select
                        em.empno,
                        initcap(timecurr.hr_pkg_common.get_employee_name(em.empno)) name,
                        em.dept_code,
                        em.eow,
                        em.eow_date,
                        em.eow_week,
                        em.esi_cover,
                        em.ipadd,
                        em.jobcategoorydesc,
                        em.jobcategory,
                        em.jobdiscipline,
                        em.jobdisciplinedesc,
                        em.jobgroup,
                        em.jobgroupdesc,
                        em.jobsubcategory,
                        em.jobsubcategorydesc,
                        em.jobsubdiscipline,
                        em.jobsubdisciplinedesc,
                        em.jobtitle_code,
                        em.jobtitledesc,
                        em.jobgroupdesc_milan,
                        em.lastday,
                        em.loc_id,
                        em.no_tcm_upd,
                        em.oldco,
                        em.ondeputation,
                        em.pfslno,
                        em.projno,
                        em.pwd,
                        em.reporting,
                        em.reporto,
                        em.secretary,
                        em.trans_in,
                        em.trans_out,
                        em.user_domain,
                        em.userid,
                        em.web_itdecl,
                        em.winid_reqd,
                        emm.status,
                        timecurr.hr_pkg_common.is_editable_emplmast(:pUser) IsEditable
                    from
                        timecurr.hr_emplmast_misc em,
                        timecurr.hr_emplmast_main emm
                    where
                        em.empno = emm.empno and
                        em.empno = :pEmpno";
        }

        public static string CostcodeMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.hr_costmast_main";
        }

        #endregion >>>>>>>>>>> E M P L O Y E E   M A S T E R <<<<<<<<<<<<<<

        #region Cost center master

        public static string CostCenterMasterListCount
        {
            get => @"Select
                        count(costcode) cnt
                     From
                        timecurr.hr_costmast_main
                     Where
                        active = 1";
        }

        public static string CostCenterMasterMainDataTableList
        {
            get => @"Select
                        cmm.CostCodeId Costcodeid,
                        cmm.CostCode Costcode,
                        cmm.Name,
                        cmm.Abbr,
                        timecurr.hr_pkg_common.get_employee_name(cmm.HoD) Hodname,
                        timecurr.hr_pkg_common.is_editable_tab(:p_EmpNo, cmm.costcodeid, 'MAIN') IsEditable
                     From
                        timecurr.hr_costmast_main cmm
                     Where
                        cmm.Active = 1
/*
                        And cmm.hod = :p_EmpNo

                     Union

                     Select
                        cmm.CostCodeId Costcodeid,
                        cmm.CostCode Costcode,
                        cmm.Name,
                        cmm.Abbr,
                        timecurr.hr_pkg_common.get_employee_name(cmm.HoD) Hodname,
                        timecurr.hr_pkg_common.is_editable_tab(:p_EmpNo, cmm.costcodeid, 'MAIN') IsEditable
                     From
                        timecurr.hr_costmast_main cmm
                     Where
                        cmm.Active = 1
                        And (timecurr.hr_pkg_common.is_editable_tab(:p_EmpNo, cmm.costcodeid, 'MAIN') = 'OK' or
                             timecurr.hr_pkg_common.is_editable_tab(:p_EmpNo, cmm.costcodeid, 'COSTCONTROL') = 'OK' or
                             timecurr.hr_pkg_common.is_editable_tab(:p_EmpNo, cmm.costcodeid, 'AFC') = 'OK')
*/
Order By
                        2";
        }

        public static string CostCenterMasterMainDetail
        {
            get => @"Select
                        cmm.CostCodeId,
                        cmm.CostCode,
                        cmm.Name,
                        cmm.Abbr,
                        cmm.HoD,
                        cmm.HoD_PersonId HoDPersonId,
                        timecurr.hr_pkg_common.get_employee_name(cmm.hod) HoDName,
                        timecurr.hr_pkg_common.get_emp_abbreviation(cmm.hod) HoDAbbr,
                        cmm.NoOfEmps,
                        cmm.CostGroupId,
                        timecurr.hr_pkg_common.get_costgroup(cmm.CostGroupId) CostGroup,
                        timecurr.hr_pkg_common.get_costgroup_name(cmm.CostGroupId) CostGroupName,
                        cmm.GroupId,
                        timecurr.hr_pkg_common.get_costcode(cmm.GroupId) Groups,
                        timecurr.hr_pkg_common.get_costcenter_name(timecurr.hr_pkg_common.get_costcode(cmm.GroupId)) GroupsName,
                        cmm.Cost_Type_Id CostTypeId,
                        timecurr.hr_pkg_common.get_cost_type(cmm.Cost_Type_Id) CostType,
                        timecurr.hr_pkg_common.get_cost_type_name(cmm.Cost_Type_Id) CostTypeName,
                        cmm.Secretary,
                        cmm.Secretary_PersonId SecretaryPersonId,
                        timecurr.hr_pkg_common.get_employee_name(cmm.Secretary) SecretaryName,
                        cmm.SDate,
                        cmm.EDate,
                        cmm.SAPCC,
                        timecurr.hr_pkg_common.get_costcode(cmm.Parent_CostCodeId) ParentCostCode,
                        cmm.Parent_CostCodeId ParentCostCodeId,
                        timecurr.hr_pkg_common.get_costcenter_name(timecurr.hr_pkg_common.get_costcode(cmm.Parent_CostCodeId)) ParentCostCodeName,
                        cmm.Active,
                        cmm.cnt_ftc CntFTC,
                        cmm.cnt_roll CntRoll,
                        timecurr.hr_pkg_costmast_main.get_cost_center_linked(cmm.CostCodeId) IsLinked,
                        timecurr.hr_pkg_common.is_editable_tab(:p_EmpNo, cmm.costcodeid, 'MAIN') IsEditable,
                        cmm.engg_nonengg,
                        Case cmm.engg_nonengg
                            When 'E' Then 'Engineering'
                            When 'N' Then 'Non engineering'
                            Else ''
                        End As EnggNonenggDesc
                     From
                        timecurr.hr_costmast_main cmm
                     Where
                        cmm.CostCodeId = :p_CostCodeId
                        And cmm.Active = 1
                     Order By
                        cmm.costcode";
        }

        public static string CostCenterMasterHoDDetail
        {
            get => @"Select
                        cmh.CostCodeId,
                        cmm.CostCode,
                        cmh.Dy_HoD DyHoD,
                        cmh.Dy_HoD_PersonId DyHoDPersonId,
                        timecurr.hr_pkg_common.get_employee_name(cmh.dy_hod) DyHoDName,
                        cmh.changed_nemps ChangedNemps,
                        timecurr.hr_pkg_common.is_editable_tab(:p_EmpNo, cmm.costcodeid, 'HOD') IsEditable
                     From
                        timecurr.hr_costmast_hod cmh,
                        timecurr.hr_costmast_main cmm
                     Where
                        cmh.CostCodeId = :p_CostCodeId
                        And cmm.CostCodeId = cmh.CostCodeId
                        And cmm.Active = 1
                     Order By
                        cmm.costcode";
        }

        public static string CostCenterMasterCostControlDetail
        {
            get => @"Select
                        cmcc.CostCodeId,
                        cmm.CostCode,
                        cmcc.tm01id Tm01Id,
                        timecurr.hr_pkg_common.get_tm01_grp(cmcc.tm01id) Tm01Grp,
                        timecurr.hr_pkg_common.get_tm01_grp_name(cmcc.tm01id) Tm01GrpName,
                        cmcc.tmaid TmaId,
                        timecurr.hr_pkg_common.get_tma_grp(cmcc.tmaid) TmaGrp,
                        timecurr.hr_pkg_common.get_tma_grp_name(cmcc.tmaid) TmaGrpName,
                        case cmcc.activity when 1 Then 'Yes' else 'No' end Activity,
                        case cmcc.group_chart when 1 Then 'Yes' else 'No' end GroupChart,
                        cmcc.italian_name ItalianName,
                        cmcc.cmid CmId,
                        timecurr.hr_pkg_common.get_comp_report(cmcc.cmid) CompReport,
                        timecurr.hr_pkg_common.get_comp_report_name(cmcc.cmid) CompReportName,
                        cmcc.phase Phase,
                        timecurr.hr_pkg_common.get_job_phases_name(cmcc.phase) PhaseName,
                        timecurr.hr_pkg_common.is_editable_tab(:p_EmpNo, cmm.costcodeid, 'COSTCONTROL') IsEditable
                     From
                        timecurr.hr_costmast_costcontrol cmcc,
                        timecurr.hr_costmast_main cmm
                     Where
                        cmcc.CostCodeId = :p_CostCodeId
                        And cmm.CostCodeId = cmcc.CostCodeId
                        And cmm.Active = 1
                     Order By
                        cmm.costcode";
        }

        public static string CostCenterMasterAFCDetail
        {
            get => @"Select
                        cma.CostCodeId,
                        cmm.CostCode,
                        cma.TCMCostCodeId,
                        timecurr.hr_pkg_common.get_tcm_cost_center(cma.TCMCostCodeId) TcmCostCode,
                        timecurr.hr_pkg_common.get_tcm_cost_center_name(cma.TCMCostCodeId) TcmCostCodeName,
                        cma.TCM_Act_Ph_Id TcmActPhId,
                        timecurr.hr_pkg_common.get_tcm_act_ph(cma.TCM_Act_Ph_Id) TcmActPh,
                        timecurr.hr_pkg_common.get_tcm_act_ph_name(cma.TCM_Act_Ph_Id) TcmActPhName,
                        cma.TCM_Pas_Ph_Id,
                        timecurr.hr_pkg_common.get_tcm_pas_ph(cma.TCM_Pas_Ph_Id) TcmPasPh,
                        timecurr.hr_pkg_common.get_tcm_pas_ph_name(cma.TCM_Pas_Ph_Id) TcmPasPhName,
                        PO,
                        timecurr.hr_pkg_common.is_editable_tab(:p_EmpNo, cmm.costcodeid, 'AFC') IsEditable
                     From
                        timecurr.hr_costmast_afc cma,
                        timecurr.hr_costmast_main cmm
                     Where
                        cma.CostCodeId = :p_CostCodeId
                        And cmm.CostCodeId = cma.CostCodeId
                        And cmm.Active = 1
                     Order By
                        cmm.costcode";
        }

        public static string CostCenterMasterDownload
        {
            get => @"select
                        hcm.costcode,
                        hcm.name,
                        hcm.abbr,
                        hcm.hod,
                        initcap(emm.name) HOD_NAME,
                        hcm.hod_personid HOD_PERSONID,
                        hch.dy_hod DY_HOD,
                        timecurr.hr_pkg_common.get_employee_name(hch.dy_hod) DY_HOD_NAME,
                        hch.dy_hod_personid DY_HOD_PERSONID,
                        hcm.secretary,
                        timecurr.hr_pkg_common.get_employee_name(hcm.Secretary) SECRETARY_NAME,
                        hcm.secretary_personid SECRETARY_PERSONID,
                        hcm.noofemps NO_OF_EMPS,
                        timecurr.hr_pkg_common.get_costgroup(hcm.costgroupid) || ' ' || timecurr.hr_pkg_common.get_costgroup_name(hcm.costgroupid) COST_GROUP,
                        timecurr.hr_pkg_common.get_costcode(hcm.GroupId) || ' ' || timecurr.hr_pkg_common.get_costcenter_name(timecurr.hr_pkg_common.get_costcode(hcm.GroupId)) GROUPNAME,
                        timecurr.hr_pkg_common.get_cost_type(hcm.Cost_Type_Id) || ' ' || timecurr.hr_pkg_common.get_cost_type_name(hcm.Cost_Type_Id) COST_TYPE,
                        to_char(hcm.sdate, 'dd-Mon-yyyy') sdate,
                        to_char(hcm.edate, 'dd-Mon-yyyy') edate,
                        hcm.sapcc,
                        timecurr.hr_pkg_common.get_costcode(hcm.Parent_CostCodeId) || ' ' || timecurr.hr_pkg_common.get_costcenter_name(timecurr.hr_pkg_common.get_costcode(hcm.Parent_CostCodeId)) PARENT_COSTCODE,
                        case hcm.active when 1 Then 'True' else 'False' end ACTIVE,
                        case hcm.cnt_ftc when 1 Then 'True' else 'False' end COUNT_FTC,
                        case hcm.cnt_roll when 1 Then 'True' else 'False' end COUNT_ROLL,
                        hch.changed_nemps CHANGED_NO_EMPS,
                        timecurr.hr_pkg_common.get_tcm_cost_center(hca.TCMCostCodeId) || ' ' || timecurr.hr_pkg_common.get_tcm_cost_center_name(hca.TCMCostCodeId) TCM_COSTCODE,
                        timecurr.hr_pkg_common.get_tcm_act_ph(hca.TCM_Act_Ph_Id) || ' ' || timecurr.hr_pkg_common.get_tcm_act_ph_name(hca.TCM_Act_Ph_Id) TCM_ACT_PHASE,
                        timecurr.hr_pkg_common.get_tcm_pas_ph(hca.TCM_Pas_Ph_Id) || ' ' || timecurr.hr_pkg_common.get_tcm_pas_ph_name(hca.TCM_Pas_Ph_Id) TCM_PAS_PHASE,
                        hca.po,
                        timecurr.hr_pkg_common.get_tm01_grp(hcc.tm01id) || ' ' || timecurr.hr_pkg_common.get_tm01_grp_name(hcc.tm01id) TM01_GROUP,
                        timecurr.hr_pkg_common.get_tma_grp(hcc.tmaid)  || ' ' || timecurr.hr_pkg_common.get_tma_grp_name(hcc.tmaid) TMA_GROUP,
                        case hcc.activity when 1 Then 'True' else 'False' end ACTIVITY,
                        case hcc.group_chart when 1 Then 'True' else 'False' end GROUP_CHART,
                        hcc.italian_name ITALIAN_NAME,
                        timecurr.hr_pkg_common.get_comp_report(hcc.cmid) || ' ' || timecurr.hr_pkg_common.get_comp_report_name(hcc.cmid) COMPANY_REPORT,
                        hcc.phase || ' ' || timecurr.hr_pkg_common.get_job_phases_name(hcc.phase) PHASE,
                        Case hcm.engg_nonengg
                            When 'E' Then 'Engineering'
                            When 'N' Then 'Non engineering'
                            Else ''
                        End As EnggNonenggDesc
                    from
                        timecurr.hr_costmast_main hcm,
                        timecurr.hr_costmast_hod hch,
                        timecurr.hr_costmast_afc hca,
                        timecurr.hr_costmast_costcontrol hcc,
                        timecurr.hr_emplmast_main emm
                    where
                        hcm.hod = emm.empno and
                        hcm.costcodeid = hch.costcodeid and
                        hcm.costcodeid = hca.costcodeid and
                        hcm.costcodeid = hcc.costcodeid
                    Order by
                        hcm.costcode";
        }

        #endregion Cost center master

        #region Roles & Actions Query

        public static string HRMAstersUserRolesActions
        {
            get => @" select role_id, action_id from tcmpl_app_config.vu_module_user_role_actions where Empno = :pEmpno  and module_id = :pModuleId";
        }

        #endregion Roles & Actions Query

        #region >>>>>>>>>>> H O L I D A Y  M A S T E R <<<<<<<<<<<<<<

        public static string HolidayMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.holidays
                    Where
                         to_char(holiday,'yyyy') in (to_char(sysdate,'yyyy') + 1, to_char(sysdate,'yyyy'))";
        }

        public static string HolidayMasterList
        {
            get => @"Select
                        srno,
                        holiday,
                        yyyymm,
                        weekday,
                        description
                    From
                        timecurr.holidays
                    Where
                        to_char(holiday,'yyyy') >= (to_char(sysdate,'yyyy') - 1) and
                        to_char(holiday,'yyyy') <= (to_char(sysdate,'yyyy') + 1)
                    Order by holiday desc";
        }

        public static string HolidayDeatil
        {
            get => @"Select
                        *
                    From
                        timecurr.holidays
                    Where
                        srno = :pSrno";
        }

        #endregion >>>>>>>>>>> H O L I D A Y  M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> D E S I G N A T I O N   M A S T E R <<<<<<<<<<<<<<

        public static string DesignationMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.desgmast";
        }

        public static string DesignationMasterList
        {
            get => @"Select
                        desgcode,
                        desg,
                        desg_new,
                        ord,
                        subcode,
                        timecurr.hr_pkg_common.get_emp_count_4_desgcode(desgcode) IsDelete
                    From
                        timecurr.desgmast
                    Order by
                        desg";
        }

        public static string DesignationMasterDetail
        {
            get => @"select
                        desgcode,
                        desg,
                        desg_new,
                        ord,
                        subcode
                    from
                        timecurr.desgmast
                    where
                        desgcode = :pDesgcode";
        }

        public static string DesignationMasterDownload
        {
            get => @"Select
                        desgcode,
                        desg,
                        desg_new,
                        ord,
                        subcode
                    From
                        timecurr.desgmast
                    Order by
                        desg";
        }

        #endregion >>>>>>>>>>> D E S I G N A T I O N   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> B A N K C O D E   M A S T E R <<<<<<<<<<<<<<

        public static string BankcodeMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.hr_bankcode_master";
        }

        public static string BankcodeMasterList
        {
            get => @"Select
                        bm.bankcode,
                        bm.bankcodedesc,
                        count(eo.empno) emps
                    From
                        timecurr.hr_bankcode_master bm,
                        timecurr.hr_emplmast_organization eo
                    Where
                        eo.bankcode(+) = bm.bankcode
                    group by
                        bm.bankcode,
                        bm.bankcodedesc
                    Order by
                        bm.bankcodedesc";
        }

        public static string BankcodeMasterDetail
        {
            get => @"select
                        bankcode,
    			        bankcodedesc
                    from
                        timecurr.hr_bankcode_master
                    where
                        bankcode = :pBankcode";
        }

        #endregion >>>>>>>>>>> B A N K C O D E   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> C A T E G O R Y   M A S T E R <<<<<<<<<<<<<<

        public static string CategoryMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.hr_category_master";
        }

        public static string CategoryMasterList
        {
            get => @"Select
                        cm.categoryid,
                        cm.categorydesc,
                        count(em.empno) emps
                    From
                        timecurr.hr_category_master cm,
                        timecurr.hr_emplmast_main em
                    Where
                        em.category(+) = cm.categoryid
                    group by
                        cm.categoryid,
                        cm.categorydesc
                    Order by
                        cm.categorydesc";
        }

        public static string CategoryMasterDetail
        {
            get => @"select
                        categoryid,
                        categorydesc
                    from
                        timecurr.hr_category_master
                    where
                        categoryid = :pCategoryid";
        }

        #endregion >>>>>>>>>>> C A T E G O R Y   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> E M P T Y P E   M A S T E R <<<<<<<<<<<<<<

        public static string EmptypeMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.emptypemast";
        }

        public static string EmptypeMasterList
        {
            get => @"Select
                        et.emptype,
                        et.empdesc,
                        et.empremarks,
                        et.tm,
                        et.printlogo,
                        et.sortorder,
                        count(em.empno) emps
                    From
                        timecurr.emptypemast et,
                        timecurr.hr_emplmast_main em
                    Where
                        et.emptype = em.emptype(+)
                    group by
                        et.emptype,
                        et.empdesc,
                        et.empremarks,
                        et.tm,
                        et.printlogo,
                        et.sortorder
                    Order by
                        et.empdesc";
        }

        public static string EmptypeMasterDetail
        {
            get => @"select
                        emptype,
                        empdesc,
                        empremarks,
                        tm,
                        printlogo,
                        sortorder
                    from
                        timecurr.emptypemast
                    where
                        emptype = :pEmptype";
        }

        #endregion >>>>>>>>>>> E M P T Y P E   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> G R A D E   M A S T E R <<<<<<<<<<<<<<

        public static string GradeMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.hr_grade_master";
        }

        public static string GradeMasterList
        {
            get => @"Select
                        gm.grade_id gradeid,
                        gm.grade_desc gradedesc,
                        count(em.empno) emps
                    From
                        timecurr.hr_grade_master gm,
                        timecurr.hr_emplmast_main em
                    Where
                        gm.grade_id = em.grade(+)
                    group by
                        gm.grade_id,
                        gm.grade_desc
                    Order by
                        gm.grade_id";
        }

        public static string GradeMasterDetail
        {
            get => @"select
                        grade_id gradeid,
                        grade_desc gradedesc
                    from
                        timecurr.hr_grade_master
                    where
                        grade_id = :pGradeid";
        }

        public static string GradeMasterDownload
        {
            get => @"Select
                        gm.grade_desc       Grade
                    From
                        timecurr.hr_grade_master gm
                    Order by
                        gm.grade_id";
        }

        #endregion >>>>>>>>>>> G R A D E   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> L O C A T I O N   M A S T E R <<<<<<<<<<<<<<

        public static string LocationMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.hr_location_master";
        }

        public static string LocationMasterList
        {
            get => @"Select
                        lm.locationid,
                        lm.location,
                        count(eo.empno) emps
                    From
                        timecurr.hr_location_master lm,
                        timecurr.hr_emplmast_organization eo
                    Where
                        lm.locationid = eo.location(+)
                    group by
                        lm.locationid,
                        lm.location
                    Order by
                        lm.location";
        }

        public static string LocationMasterDetail
        {
            get => @"select
                        locationid,
                        location
                    from
                        timecurr.hr_location_master
                    where
                        locationid = :pLocationid";
        }

        #endregion >>>>>>>>>>> L O C A T I O N   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> O F F I C E   M A S T E R <<<<<<<<<<<<<<

        public static string OfficeMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.offimast";
        }

        public static string OfficeMasterList
        {
            get => @"Select
                        o.office,
                        o.name,
                        count(em.empno) emps
                    From
                        timecurr.offimast o,
                        timecurr.hr_emplmast_main em
                    Where
                        o.office = em.office(+)
                    group by
                        o.office,
                        o.name
                    Order by
                        o.name";
        }

        public static string OfficeMasterDetail
        {
            get => @"select
                        office,
                        name
                    from
                        timecurr.offimast
                    where
                        office = :pOffice";
        }

        #endregion >>>>>>>>>>> O F F I C E   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> S U B C O N T R A C T   M A S T E R <<<<<<<<<<<<<<

        public static string SubcontractMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.subcontractmast";
        }

        public static string SubcontractMasterList
        {
            get => @"Select
                        s.subcontract,
                        s.description,
                        count(eo.empno) emps
                    From
                        timecurr.subcontractmast s,
                        timecurr.hr_emplmast_organization eo
                    Where
                        s.subcontract = eo.subcontract(+)
                    group by
                        s.subcontract,
                        s.description
                    Order by
                        s.subcontract";
        }

        public static string SubcontractMasterDetail
        {
            get => @"select
                        subcontract,
                        description
                    from
                        timecurr.subcontractmast
                    where
                        subcontract = :pSubcontract";
        }

        public static string SubcontractMasterDownload
        {
            get => @"Select
                        s.subcontract,
                        s.description
                    From
                        timecurr.subcontractmast s
                    Order by
                        s.subcontract";
        }

        #endregion >>>>>>>>>>> S U B C O N T R A C T   M A S T E R <<<<<<<<<<<<<<

        #region Place master

        public static string PlaceMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.hr_place_master";
        }

        public static string PlaceMasterList
        {
            get => @"Select
                        pm.place_id     placeid,
                        pm.place_desc   placedesc,
                        Count(eo.empno) emps
                    From
                        timecurr.hr_place_master          pm,
                        timecurr.hr_emplmast_organization eo
                    Where
                        pm.place_id = eo.place (+)
                    Group By
                        pm.place_id,
                        pm.place_desc
                    Order By
                        pm.place_desc";
        }

        public static string PlaceMasterDetail
        {
            get => @"select
                        place_id placeid,
                        place_desc placedesc
                    from
                        timecurr.hr_place_master
                    where
                        place_id = :pPlaceid";
        }

        #endregion Place master

        #region Qualification master

        public static string QualificationMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.hr_qualification_master";
        }

        public static string QualificationMasterList
        {
            get => @"Select
                        qm.qualification_id         qualificationid,
                        qm.qualification            qualification,
                        Max(qm.qualification_desc)  qualificationdesc,
                        Count(eoq.empno) emps
                    From
                        timecurr.hr_qualification_master          qm,
                        timecurr.hr_emplmast_organization_qual    eoq
                    Where
                        qm.qualification_id = eoq.qualification_id (+)
                    Group By
                        qm.qualification_id,
                        qm.qualification
                    Order By
                        qm.qualification";
        }

        public static string QualificationMasterDetail
        {
            get => @"select
                        qualification_id   qualificationid,
                        qualification      qualification,
                        qualification_desc qualificationdesc
                    from
                        timecurr.hr_qualification_master
                    where
                        qualification_id = :pQualificationid";
        }

        public static string QualificationMasterDownload
        {
            get => @"Select
                        qm.qualification_id         QualificationCode,
                        qm.qualification            Qualification,
                        Max(qm.qualification_desc)  QualificationDesc
                    From
                        timecurr.hr_qualification_master          qm
                    Group By
                        qm.qualification_id,
                        qm.qualification
                    Order By
                        qm.qualification";
        }

        #endregion Qualification master

        #region Graduation master

        public static string GraduationMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.hr_graduation_master";
        }

        public static string GraduationMasterList
        {
            get => @"Select
                        gm.graduation_id     graduationid,
                        gm.graduation_desc   graduationdesc,
                        Count(eo.empno) emps
                    From
                        timecurr.hr_graduation_master       gm,
                        timecurr.hr_emplmast_organization   eo
                    Where
                        gm.graduation_id = eo.graduation (+)
                    Group By
                        gm.graduation_id,
                        gm.graduation_desc
                    Order By
                        gm.graduation_desc";
        }

        public static string GraduationMasterDetail
        {
            get => @"select
                        graduation_id graduationid,
                        graduation_desc graduationdesc
                    from
                        timecurr.hr_graduation_master
                    where
                        graduation_id = :pGraduationid";
        }

        public static string GraduationMasterDownload
        {
            get => @"Select
                        gm.graduation_id     Graduation,
                        gm.graduation_desc   GraduationDesc

                    From
                        timecurr.hr_graduation_master       gm
                    Order By
                        gm.graduation_desc";
        }

        #endregion Graduation master

        #region >>>>>>>>>>> R E P O R T S <<<<<<<<<<<<<<

        public static string EmployeewiseReportingList
        {
            get => @"select
                        hem.empno,
                        hem.name,
                        hem.parent,
                        heo.mngr manager,
                        timecurr.hr_pkg_common.get_employee_name(heo.mngr) ManagerName,
                        hcm.hod,
                        timecurr.hr_pkg_common.get_employee_name(hcm.hod) HoDName,
                        hcm.secretary,
                        timecurr.hr_pkg_common.get_employee_name(hcm.secretary) SecretaryName
                    from
                        timecurr.hr_emplmast_main hem,
                        timecurr.hr_emplmast_organization heo,
                        timecurr.hr_costmast_main hcm
                    where
                        hem.empno = heo.empno and
                        hem.parent = hcm.costcode
                    order by
                        hem.empno";
        }

        public static string EmployeeResignedList
        {
            get => @"select
                        hem.empno,
                        hem.name,
                        hem.parent,
                        timecurr.hr_pkg_common.get_costcenter_abbr(hem.parent) costcode,
                        hem.emptype,
                        hem.grade,
                        timecurr.hr_pkg_common.get_designation(hem.desgcode) designation,
                        hem.category,
                        timecurr.hr_pkg_common.get_place(heo.place) place,
                        hem.doj,
                        trunc(oee.relieving_date) dol,
                        timecurr.hr_pkg_common.get_leaving_reason(heo.reasonid) remarks
                     from
                        timecurr.hr_emplmast_main hem,
                        timecurr.hr_emplmast_organization heo,
                        tcmpl_hr.ofb_emp_exits oee
                     where
                        hem.empno = heo.empno and
                        oee.empno =  heo.empno and
                        oee.relieving_date between :pStartDate and :pEndDate
                     order by
                        hem.empno";
        }

        public static string EmployeeResignedCostcodewiseList
        {
            get => @"select
                        hem.parent,
                        timecurr.hr_pkg_common.get_costcenter_abbr(hem.parent) costcode,
                        count(hem.empno) cnt
                     from
                        timecurr.hr_emplmast_main hem,
                        tcmpl_hr.ofb_emp_exits oee
                     where
                        oee.empno = hem.empno and
                        oee.relieving_date between :pStartDate and :pEndDate
                     group by
                        hem.parent
                     order by
                        hem.parent";
        }

        public static string EmployeeResignedMonthwiseList
        {
            get => @"select
                        to_char(to_date(mm,'mm-yyyy'),'Mon yy') Month,
                        cnt
                    from
                        (select
                            to_char(oee.relieving_date,'mm')||'-'||to_char(oee.relieving_date,'yyyy') mm,
                            count(hem.empno) cnt
                        from
                            timecurr.hr_emplmast_main hem,
                            tcmpl_hr.ofb_emp_exits oee
                        where
                            oee.empno = hem.empno and
                            oee.relieving_date between :pStartDate and :pEndDate
                        group by
                           to_char(oee.relieving_date,'yyyy'), to_char(oee.relieving_date,'mm')
                         order by
                            to_char(oee.relieving_date,'yyyy'), to_char(oee.relieving_date,'mm'))";
        }

        public static string EmployeeJoinedList
        {
            get => @"select
                        hem.empno,
                        hem.name,
                        hem.parent,
                        timecurr.hr_pkg_common.get_costcenter_abbr(hem.parent) costcode,
                        hem.emptype,
                        hem.grade,
                        timecurr.hr_pkg_common.get_designation(hem.desgcode) designation,
                        hem.category,
                        timecurr.hr_pkg_common.get_place(heo.place) place,
                        trunc(hem.dob) dob,
                        hem.doj
                     from
                        timecurr.hr_emplmast_main hem,
                        timecurr.hr_emplmast_organization heo
                     where
                        hem.empno = heo.empno and
                        hem.doj between :pStartDate and :pEndDate
                     order by
                        hem.empno";
        }

        public static string EmployeeJoinedCostcodewiseList
        {
            get => @"select
                        hem.parent,
                        timecurr.hr_pkg_common.get_costcenter_abbr(hem.parent) costcode,
                        count(hem.empno) cnt
                     from
                        timecurr.hr_emplmast_main hem
                     where
                        hem.doj between :pStartDate and :pEndDate
                     group by
                        hem.parent
                     order by
                        hem.parent";
        }

        public static string EmployeeJoinedMonthwiseList
        {
            get => @"select
                        to_char(to_date(mm,'mm-yyyy'),'Mon yy') Month,
                        cnt
                    from
                        (select
                            to_char(hem.doj,'mm')||'-'||to_char(hem.doj,'yyyy') mm,
                            count(hem.empno) cnt
                        from
                            timecurr.hr_emplmast_main hem
                        where
                            hem.doj between :pStartDate and :pEndDate
                        group by
                            to_char(hem.doj,'yyyy'), to_char(hem.doj,'mm')
                         order by
                            to_char(hem.doj,'yyyy'), to_char(hem.doj,'mm'))";
        }

        public static string CostcodewiseEmployeeCountList
        {
            get => @"select
                        hem.parent Costcode,
                        timecurr.hr_pkg_common.get_costcenter_name(hem.parent) Name,
                        count(hem.empno) Nos
                     from
                        timecurr.hr_emplmast_main hem
                     where
                        hem.status = 1
                     group by
                        hem.parent,
                        timecurr.hr_pkg_common.get_costcenter_abbr(hem.parent)
                     order by
                        hem.parent";
        }

        public static string CategorywiseEmployeeCountList
        {
            get => @"select
                        hem.category,
                        count(hem.empno) Nos
                    from
                       timecurr.hr_emplmast_main hem
                    where
                        hem.status = 1
                    group by
                        hem.category
                    order by
                        hem.category";
        }

        public static string ContractEmployeeList
        {
            get => @"select
                        hem.empno,
                        decode(hea.payroll,1,'TRUE','FALSE') payroll,
                        hem.name,
                        hem.parent,
                        hem.assign,
                        trunc(hem.dob) dob,
                        trunc(hem.doj) doj,
                        timecurr.hr_pkg_common.get_designation(hem.desgcode) desg,
                        hem.emptype,
                        hem.grade
                    from
                        timecurr.hr_emplmast_main hem,
                        timecurr.hr_emplmast_applications hea
                    where
                        hem.empno = hea.empno and
                        hea.payroll = 1 and
                        hem.emptype = 'C'
                    order by
                        hem.empno";
        }

        public static string SubcontractEmployeeList
        {
            get => @"select
                        hem.empno,
                        decode(hea.payroll,1,'TRUE','FALSE') payroll,
                        hem.name,
                        hem.parent,
                        hem.assign,
                        trunc(hem.dob) dob,
                        trunc(hem.doj) doj,
                        timecurr.hr_pkg_common.get_designation(hem.desgcode) desg,
                        hem.emptype,
                        hem.grade,
                        heo.subcontract,
                        timecurr.hr_pkg_common.get_subcontract_name(heo.subcontract) subcontractname
                    from
                        timecurr.hr_emplmast_main hem,
                        timecurr.hr_emplmast_organization heo,
                        timecurr.hr_emplmast_applications hea
                    where
                        hem.empno = heo.empno and
                        hem.empno = hea.empno and
                        hea.payroll = 1  and
                        hem.emptype = 'S'
                    order by
                        hem.empno";
        }

        public static string SubcontractActiveEmployeeList
        {
            get => @"select
                hem.empno,
                decode(hea.payroll,1,'TRUE','FALSE') payroll,
                hem.name,
                hem.parent,
                hem.assign,
                trunc(hem.dob) dob,
                trunc(hem.doj) doj,
                timecurr.hr_pkg_common.get_designation(hem.desgcode) desg,
                hem.emptype,
                hem.grade,
                heo.subcontract,
                timecurr.hr_pkg_common.get_subcontract_name(heo.subcontract) subcontractname
            from
                timecurr.hr_emplmast_main hem,
                timecurr.hr_emplmast_organization heo,
                timecurr.hr_emplmast_applications hea
            where
                hem.empno = heo.empno and
                hem.empno = hea.empno and
                hem.status = 1  and
                hem.emptype = 'S'
            order by
                hem.empno";
        }

        public static string OutsourceEmployeeList
        {
            get => @"select
                        timecurr.hr_pkg_common.get_subcontract_4_empno(td.empno)  subcontract,
                        td.empno,
                        timecurr.hr_pkg_common.get_employee_name(td.empno) name,
                        td.projno,
                        td.d1,
                        td.d2,
                        td.d3,
                        td.d4,
                        td.d5,
                        td.d6,
                        td.d7,
                        td.d8,
                        td.d9,
                        td.d10,
                        td.d11,
                        td.d12,
                        td.d13,
                        td.d14,
                        td.d15,
                        td.d16,
                        td.d17,
                        td.d18,
                        td.d19,
                        td.d20,
                        td.d21,
                        td.d22,
                        td.d23,
                        td.d24,
                        td.d25,
                        td.d26,
                        td.d27,
                        td.d28,
                        td.d29,
                        td.d30,
                        td.d31,
                        td.total,
                        td.assign,
                        td.wpcode,
                        td.yymm,
                        td.activity,
                        td.grp,
                        td.parent,
                        heo.place
                    from
                        timecurr.time_daily  td,
                        timecurr.hr_emplmast_organization heo
                    where
                        td.empno = heo.empno and
                        td.empno like 'W%' and
                        td.yymm = :pYyyymm";
        }

        public static string SubcontractEmployeePivotList
        {
            get => @"select distinct hem.empno, hem.name, decode(hem.status,1,'True','False') status, hem.emptype,
                      hem.parent, hem.parent||'-'||timecurr.hr_pkg_common.get_costcenter_abbr(hem.parent) parentabbr, hem.assign, trunc(hem.dob) dob, trunc(hem.doj) doj, heo.location,
                      heo.subcontract, timecurr.hr_pkg_common.get_subcontract_name(heo.subcontract) subcontractname, hem.office, hem.sex gender, hem.grade
                            from timecurr.hr_emplmast_main hem, timecurr.hr_emplmast_organization heo, timecurr.subcontractmast sm, timecurr.time_daily td
                            where hem.empno = heo.empno and heo.subcontract = sm.subcontract and heo.empno = td.empno
                            and hem.emptype in ('S','O') and td.yymm = :pYyyymm UNION
                    select distinct hem1.empno, hem1.name, decode(hem1.status,1,'True','False') status, hem1.emptype,
                      hem1.parent, hem1.parent||'-'||timecurr.hr_pkg_common.get_costcenter_abbr(hem1.parent) parentabbr, hem1.assign, hem1.dob, hem1.doj, heo1.location,
                      heo1.subcontract, timecurr.hr_pkg_common.get_subcontract_name(heo1.subcontract) subcontractname, hem1.office, hem1.sex gender, hem1.grade
                        from timecurr.hr_emplmast_main hem1, timecurr.hr_emplmast_organization heo1
                        where hem1.empno = heo1.empno
                        and hem1.empno not in (select distinct empno from timecurr.time_daily where yymm = :pYyyymm)
                        and hem1.emptype in ('S','O')
                        and hem1.status = 1 and to_char(hem1.doj, 'yyyymm') <= :pYyyymm UNION
                    select distinct hem2.empno, hem2.name, decode(hem2.status,1,'True','False') status, hem2.emptype,
                      hem2.parent, hem2.parent||'-'||timecurr.hr_pkg_common.get_costcenter_abbr(hem2.parent) parentabbr, hem2.assign, hem2.dob, hem2.doj, heo2.location,
                      heo2.subcontract, timecurr.hr_pkg_common.get_subcontract_name(heo2.subcontract) subcontractname, hem2.office, hem2.sex gender, hem2.grade
                        from timecurr.hr_emplmast_main hem2, timecurr.hr_emplmast_organization heo2
                        where hem2.empno = heo2.empno
                        and hem2.empno not in (select distinct empno from timecurr.time_daily where yymm = :pYyyymm)
                        and hem2.emptype in ('S', 'O')
                        and hem2.status = 0 and to_char(heo2.dol, 'yyyymm') = :pYyyymm ";
        }

        public static string ParentwiseSubcontractEmployee
        {
            get => @"select timecurr.hr_pkg_emplmast_report.get_subcontract_emp_parentwise(:pYyyymm) jsonoutout from dual";
        }

        #endregion >>>>>>>>>>> R E P O R T S <<<<<<<<<<<<<<

        #region Job group master

        public static string JobGroupMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                       timecurr.hr_jobgroup_master";
        }

        public static string JobGroupMasterList
        {
            get => @"select
                        hjgm.job_group_code,
                        hjgm.job_group,
                        hjgm.milan_job_group,
                        nvl(count(empno),0) emps
                    from
                        timecurr.hr_jobgroup_master hjgm,
                        timecurr.hr_emplmast_misc hem
                    where
                        hjgm.job_group_code = hem.jobgroup (+)
                    group by
                        hjgm.job_group_code, hjgm.job_group,hjgm.milan_job_group
                    order by
                        hjgm.job_group_code";
        }

        public static string JobGroupMasterDetail
        {
            get => @"select
                        job_group_code,
                        job_group,
                        milan_job_group
                    from
                        timecurr.hr_jobgroup_master
                    where
                        job_group_code = :pGrpCd";
        }

        public static string JobGroupMasterDownload
        {
            get => @"select
                        job_group_code,
                        job_group,
                        milan_job_group
                    from
                        timecurr.hr_jobgroup_master
                    order by
                        job_group_code";
        }

        #endregion Job group master

        #region Job discipline master

        public static string JobDisciplineMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.hr_jobdiscipline_master";
        }

        public static string JobDisciplineMasterList
        {
            get => @"select
                        hjdm.jobdiscipline_code,
                        hjdm.jobdiscipline,
                        nvl(count(empno),0) emps
                    from
                        timecurr.hr_jobdiscipline_master hjdm,
                        timecurr.hr_emplmast_misc hem
                    where
                        hjdm.jobdiscipline_code = hem.jobdiscipline (+)
                    group by
                        hjdm.jobdiscipline_code, hjdm.jobdiscipline
                    order by
                        hjdm.jobdiscipline_code";
        }

        public static string JobDisciplineMasterDetail
        {
            get => @"select
                        jobdiscipline_code,
                        jobdiscipline
                    from
                        timecurr.hr_jobdiscipline_master
                    where
                        jobdiscipline_code = :pDisCd";
        }

        public static string JobDisciplineMasterDownload
        {
            get => @"select
                        jobdiscipline_code,
                        jobdiscipline
                    from
                        timecurr.hr_jobdiscipline_master
                    order by
                        jobdiscipline_code";
        }

        #endregion Job discipline master

        #region Job title master

        public static string JobTitleMasterListCount
        {
            get => @"Select
                        count(*) cnt
                    From
                        timecurr.hr_jobtitle_master";
        }

        public static string JobTitleMasterList
        {
            get => @"select
                        hjtm.jobtitle_code,
                        hjtm.jobtitle,
                        nvl(count(empno),0) emps
                    from
                        timecurr.hr_jobtitle_master hjtm,
                        timecurr.hr_emplmast_misc hem
                    where
                        hjtm.jobtitle_code = hem.jobtitle_code (+)
                    group by
                        hjtm.jobtitle_code, hjtm.jobtitle
                    order by
                        hjtm.jobtitle_code";
        }

        public static string JobTitleMasterDetail
        {
            get => @"select
                        hjtm.jobtitle_code,
                        hjtm.jobtitle
                    from
                        timecurr.hr_jobtitle_master hjtm
                    where
                        hjtm.jobtitle_code = :pTitCd";
        }

        public static string JobTitleMasterDownload
        {
            get => @"select
                        hjtm.jobtitle_code,
                        hjtm.jobtitle
                    from
                        timecurr.hr_jobtitle_master hjtm
                    order by
                        hjtm.jobtitle_code";
        }

        #endregion Job title master
    }
}