using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;

namespace TCMPLApp.DataAccess.Repositories.Common
{
    public class SelectTcmPLRepository : ViewTcmPLRepository<DataField>, ISelectTcmPLRepository
    {
        public SelectTcmPLRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public virtual async Task<IEnumerable<DataField>> LeaveTypeListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_leave_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> LeaveTypesForLeaveClaims(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_leave_types_for_leaveclaims";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ApproversListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_approvers_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> OnDutyTypeListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_onduty_types_list_4_user";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> EmployeeListForHRAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_employee_list_4_hr";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> EmployeeListForMngrHodAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_emplist_4_mngrhod";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> EmployeeListForMngrHodOnBeHalfAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_emp_list_4_mngrhod_onbehalf";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> EmployeeListForSecretary(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_employee_list_4_secretary";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> EmployeeListAssignForHoDSec(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_employee_list_4_hod_sec";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> EmployeeList4DeskPlan(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_emp_list4desk_plan";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ProjectListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_project_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> CostCodeListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_costcode_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SWPCostCodeList4HodSecAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_costcode_list_4_hod_sec";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SWPCostCodeList4AdminAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_costcode_list_4_admin";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SWPEmployeeList4AdminAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_emp_list_4_admin";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SWPCostCodeList4SeatPlan4HodSecAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_dept_list4plan_4_hod_sec";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SWPSWPTypesAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_swp_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SWPSWPTypesForHodAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_swp_type_list_4_hod";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> EmployeeListForMngrHodAsync1(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_emp_list_for_hod_filter";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> EmployeeListForHRAsync1(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_emp_list_for_hr_filter";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> OnDutyTypeListForFilterAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_onduty_types_list_4_filter";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HRMISEmployeeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_emp_list_all";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HRMISDeptList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_dept_list_all";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HRMISOfficeLocationList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_office_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HRMISJoiningStatusList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_joining_status_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HRMISResignReasonTypeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_resign_reason_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HRMISResignStatusList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_resign_status_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HRMISCurrResidentialLocation(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_emp_curr_res_loc";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HrMisEmpTypeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_employment_type";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HrMisGradeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_grade";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HrMisDesignationList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_designation";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HrMisSourcesOfCandidateList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_sources_of_candidate";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HrMisPreEmpMedicalTestList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_pre_emp_medical_test";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public List<DataField> GetListOkKoYesNo()
        {
            var list = new List<DataField>();
            list.Add(new DataField { DataTextField = "", DataValueField = "" });
            list.Add(new DataField { DataTextField = "Yes", DataValueField = "OK" });
            list.Add(new DataField { DataTextField = "No", DataValueField = "KO" });

            return list;
        }

        public List<DataField> GetListOffice()
        {
            var list = new List<DataField>();
            list.Add(new DataField { DataTextField = "", DataValueField = "" });
            list.Add(new DataField { DataTextField = "MOC1", DataValueField = "MOC1" });
            list.Add(new DataField { DataTextField = "MOC2", DataValueField = "MOC2" });
            list.Add(new DataField { DataTextField = "MOC3", DataValueField = "MOC3" });
            list.Add(new DataField { DataTextField = "MOC4", DataValueField = "MOC4" });
            return list;
        }

        public List<DataField> GetListFloor()
        {
            var list = new List<DataField>();
            list.Add(new DataField { DataTextField = "", DataValueField = "" });
            list.Add(new DataField { DataTextField = "Ground", DataValueField = "Ground" });
            list.Add(new DataField { DataTextField = "First", DataValueField = "First" });
            list.Add(new DataField { DataTextField = "Second", DataValueField = "Second" });
            list.Add(new DataField { DataTextField = "Third", DataValueField = "Third" });
            list.Add(new DataField { DataTextField = "Fifth", DataValueField = "Fifth" });
            list.Add(new DataField { DataTextField = "Seven", DataValueField = "Seven" });
            list.Add(new DataField { DataTextField = "Home", DataValueField = "Home" });
            return list;
        }

        public List<DataField> GetListWing()
        {
            var list = new List<DataField>();
            list.Add(new DataField { DataTextField = "", DataValueField = "" });
            list.Add(new DataField { DataTextField = "East", DataValueField = "East" });
            list.Add(new DataField { DataTextField = "Centr", DataValueField = "Center" });
            list.Add(new DataField { DataTextField = "West", DataValueField = "West" });
            list.Add(new DataField { DataTextField = "Home", DataValueField = "Home" });
            return list;
        }

        public List<DataField> GetListYymmHalf()
        {
            var list = new List<DataField>();
            list.Add(new DataField { DataTextField = "", DataValueField = "" });
            list.Add(new DataField { DataTextField = "First half", DataValueField = "1" });
            list.Add(new DataField { DataTextField = "Second half", DataValueField = "2" });

            return list;
        }

        public List<DataField> GetListLcDurationType()
        {
            var list = new List<DataField>();
            list.Add(new DataField { DataTextField = "", DataValueField = "" });
            list.Add(new DataField { DataTextField = "Usance Period(U)​", DataValueField = "1" });
            list.Add(new DataField { DataTextField = "LC Tenure(T)​", DataValueField = "2" });

            return list;
        }

        public List<DataField> GetListDmsItemIssueAction()
        {
            var list = new List<DataField>();
            list.Add(new DataField { DataTextField = "", DataValueField = "" });
            list.Add(new DataField { DataTextField = "IT Inventory Issue", DataValueField = "A254" });
            list.Add(new DataField { DataTextField = "Mobile Inventory Issue", DataValueField = "A255" });

            return list;
        }

        public virtual async Task<IEnumerable<DataField>> BaySelectListCacheAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.iot_dms_qry.bay_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> WorkAreaSelectListCacheAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.iot_dms_qry.workarea_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskListForSWP(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_desk_list_for_smart";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskListForOfficeSWP(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_desk_list_for_office";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> EmployeeTypeListSWP(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_employee_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> GradeListSWP(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_grade_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ProjectListSWP(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_project_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectYearRapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_year_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectYearModeRapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_yearmode_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectYearMonthRapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_yearmonth_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectCostCodeRapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_costcode_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectCostCodeRapReportingProco(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_costcode_list_proco";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectTlpCodeRapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_tlpcode_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectActivityRapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_activity_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectProjnoRapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_projno_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectProjnoRapReportingProco(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_projno_list_proco";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectExpectedProjnoRapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_expt_projno_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectEmpnoRapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_empno_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectSimulationRapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_simulation_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> LcBankListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.lc_select_list_qry.fn_bank_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> LcCompanyListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.lc_select_list_qry.fn_company_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> LcCurrenciesListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.lc_select_list_qry.fn_currencies_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> LcVendorsListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.lc_select_list_qry.fn_vendors_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> LcChargesStatusListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.lc_select_list_qry.fn_charges_status_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> RapJobTMAGroupListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_job_tmagroup_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> EmpListForWorkspaceDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_emp_list4wp_details";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ManhoursProjectionsCurrentJobsYymmAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_mhrs_proj.get_yymm";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ManhoursProjectionsExpectedJobsYymmAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_mhrs_proj.get_expected_yymm";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> OvertimeUpdateYymmAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_ot.get_yymm";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HSENatureTypeListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_hse_qry.fn_naturetype_select_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HSEIncidentTypeListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_hse_qry.fn_incidenttype_select_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectYearTimesheet(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.ts_select_list_qry.fn_year_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectYearMonthTimesheet(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.ts_select_list_qry.fn_yearmonth_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectDeptEmpnoTimeSheet(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.ts_select_list_qry.fn_dept_empno_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectAllEmpnoTimeSheet(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.ts_select_list_qry.fn_all_empno_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectERSLocationList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.ers_hr_qry.fn_location_select_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectERSCVStatus(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.ers_qry.fn_cv_status_select_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ErsSelectCostCodeCreateList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.ers_qry.fn_costcode_create_select_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ErsSelectCostCodeEditList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.ers_qry.fn_costcode_edit_select_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ErsSelectJobReferenceList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.ers_hr_qry.fn_job_reference_select_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ErsSelectChangeJobReferenceList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.ers_hr_qry.fn_change_job_ref_select_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> BgCompanyListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.bg_select_list_qry.fn_company_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> BgCurrenciesListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.bg_select_list_qry.fn_currencies_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> BgProjectListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.bg_select_list_qry.fn_project_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> BgIssuedByListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.bg_select_list_qry.fn_issuedby_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> BgIssuedToListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.bg_select_list_qry.fn_issuedto_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> BgBankListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.bg_select_list_qry.fn_bank_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> BGAcceptableAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.bg_select_list_qry.fn_acceptable_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectBGStatus(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.pkg_bg_main_status_qry.fn_bg_status_select_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> BgProjectFilterList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.bg_select_list_qry.fn_bg_project_filter_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> VppRelationList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.vpp_select_qry.fn_relation_select_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> VppSumInsuredsList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.vpp_select_qry.fn_insured_sum_select_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> VppSumInsuredsConfigSelectList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.vpp_select_qry.fn_insured_sum_frm_config_select_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DmsOfficeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_office_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DmsFloorList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_floor_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DmsWingList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_wing_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DmsBayList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_bay_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DmsAreaList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_area_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DmsAreaTypeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_desk_area_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DmsAreaCatgCodeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_area_catg_code_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DmsDeskLockReasonList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_desklock_reason_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DmsEmp4AsgmtList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_emp_4_desk_asgmt_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> RapSOCDList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_socd_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectProjno5RapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_projno5_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectProjno5RapReportingProco(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_projno5_list_proco";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectSubcontractorRapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_subcontractor_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectOscHoursRapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_osc_hours_yyyymm_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectCostCodeRapReportingBal(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_costcode_list_bal";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectCostCodeRapReportingProcoBal(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_costcode_list_proco_bal";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectScopeWorkRapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_scope_work_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvItemList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_item_consumable_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvItemTypeFullList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_item_type_full_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvItemAsgmtTypesFullList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_item_asgmt_types_full_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvItemTypeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_item_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvItemType4DeskList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_item_type_4Desk_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvItemType4EmployeeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_item_type_4Desk_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvItemCategoryList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_item_category_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvItemAsgmtTypesList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_item_asgmt_types_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvAmsSubAssetTypeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_ams_sub_asset_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvItemAmsAssetMappingList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_item_ams_asset_mapping_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvConsumableItemTypeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_consumable_item_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvReturnItemList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_item_ret_consumable_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvTransTypeCreateList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_inv_trans_type_create_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvTransTypeReturnList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_inv_trans_type_return_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvRAMCapacityList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_inv_ram_capacity_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvItemAddonTypeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_inv_item_addon_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvItemAddonItemsList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_inv_item_addon_items_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvItemAddonContainerTypeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_inv_item_container_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvDesk4AssetOnHoldList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_desk_4assetonhold_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvAsset4AssetOnHoldList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_asset_4assetonhold_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvLaptopLotList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_laptop_lot_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DMSAdmHodSecCostCodeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_adm_hod_sec_dept_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DMSAvailableDesksForGuestList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_desks4guest_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DMSProject7List(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_project7_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvItemTypeAssetFullList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_item_type_asset_full_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvItemType4TransList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_item_type_4_trans_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DMSItemUsableTypesList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_item_usable_types_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvActionTypeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_action_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SourceDeskListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_select_list_qry.fn_source_desk_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> TargetDeskListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_select_list_qry.fn_target_desk_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> TargetAssignmentDeskListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_select_list_qry.fn_target_assignment_desk_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> JobApproversListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_job_approver_edit_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> CostcodeAbbrListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_costcode_abbr_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> JobPhaseListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_phases_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> JobResponsibleListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_job_responsible_edit_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> MailListCostcodesListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_mail_list_costcodes";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> JobTMAGroupListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_tmagroup_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> CountryListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_country_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> StateListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_state_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> PlantTypeListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_plant_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> BusinessLineListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_business_line_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SubBusinessLineListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_sub_business_line_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SegmentListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_segment_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ScopeOfWorkListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_scope_of_work_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ProjectTypeListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_project_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ContractTypeListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_contract_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> COListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_co_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ModuleIdList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_user_access_select_list.fn_modual_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> FlagIdList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_user_access_select_list.fn_flag_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> RoleIdList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_user_access_select_list.fn_role_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ActionIdList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_user_access_select_list.fn_action_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> UserAccessEmployeeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "pkg_user_access_select_list.fn_employee_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> InvoicingGroupCompanySelectListCacheAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_invoicing_grp_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> RelationListText(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_select_list_qry.fn_emp_relation_text_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> RelationListCode(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_select_list_qry.fn_emp_relation_code_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> OccupationList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_select_list_qry.fn_emp_occupation_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> BloodGroupListText(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_select_list_qry.fn_emp_blood_group_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> BusListText(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_select_list_qry.fn_bus_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> OnBehalfPrincipalList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_4_on_behalf_principal_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> CountryList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_select_list_qry.fn_emp_country_list_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ClientList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.iot_jobs_select_list_qry.fn_client_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> BlockReasonList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_select_list_qry.fn_desk_block_reason_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> PcModelList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_pc_model_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> MonitorModelList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_monitor_model_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> TelModelList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_telephone_model_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> PrinterModelList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_printer_model_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DockStationModelList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.dms_select_list_qry.fn_docstn_model_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> TSOSCMhrsCostcodeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.ts_select_list_qry.fn_osc_costcode_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> TSOSCMhrsCostcodeEmpnoList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.ts_select_list_qry.fn_osc_costcode_empno_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> TSOSCMhrsProjnoList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.ts_select_list_qry.fn_projno_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> TSOSCMhrsWPCodeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.ts_select_list_qry.fn_wpcode_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> TSOSCMhrsActivityList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.ts_select_list_qry.fn_activity_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> OFBEmployeeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_emp_list_all";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> OFBRollbackEmployeeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_rollback_emp_list_all";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> CostcodeEmployeeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.fn_costcode_empno_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> CostcodeDeptList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.fn_costcode_dept_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookDatesList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbook_select_list_qry.fn_deskbook_date_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookDateRangeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbook_select_list_qry.fn_deskbook_date_range_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookPreviousDatesList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbook_select_list_qry.fn_deskbook_previous_date_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookEmpOfficeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_deskbook_emp_office_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookEnabledOfficeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_deskbook_enabled_office_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookOfficeShiftList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbook_select_list_qry.fn_deskbook_office_shiftlist";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookAvailableDesks(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbook_select_list_qry.fn_deskbook_availabledesks";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookAvailableDesksForToday(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbook_select_list_qry.fn_today_availabledesks";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookDeskAreas(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbook_select_list_qry.fn_deskbook_deskareas";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookCostCodeList4HodSecAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_select_list_qry.fn_costcode_list_4_hod_sec";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookProjectList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbook_select_list_qry.fn_project_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> CostcodeSiteList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_select_qry.fn_dg_site_master_select_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> RelationList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_select_list_qry.fn_emp_relatives_relations_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> RelativeEmployeeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_relatives_as_colleagues_qry.fn_emp_relative_list_all";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> JobGroupListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_select_qry.fn_dg_jobgroup_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> JobDisciplineListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_select_qry.fn_dg_jobdiscipline_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> JobTitleListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_select_qry.fn_dg_jobtitle_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookAreaForAssignmentList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            //CommandText = "dms.db_select_list_qry.fn_area_list_4_desk_booking";
            CommandText = "dms.db_select_list_qry.fn_area_list_4_assignment";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookAreaForAssignmentDmsList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_area_list_4_assignment_dms";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookAreaForFixedPcList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_area_list_4_fixed_pc";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookCostcodeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_costcode_4_desk_booking";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookProjectMapList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_project_4_desk_booking";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookEmployeeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_employee_4_desk_booking";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookDeskList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_desk_list_4_desk_booking";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookingOfficeLocationList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_deskbook_emp_office_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookDeptInAreaList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_dept_in_area_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookProjectInAreaList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_project_in_area_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookUserInAreaList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_user_in_area_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookEmpAndDeskInAreaList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_emp_n_desk_in_area_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookEmpAndDeskTypeInAreaList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_emp_n_desk_type_in_area_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> TagObjectTypeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_tag_obj_mapping_qry.fn_tag_object_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> TagTypeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_tag_obj_mapping_qry.fn_tag_master_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectProjnoClosedRapReporting(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_projno_list_closed";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> SelectProjnoClosedRapReportingProco(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_select_list_qry.fn_projno_list_proco_closed";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookDepartmentListForHod(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_costcode_4_hod_desk_booking";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookEmployeeListForHod(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_employee_4_hod_desk_booking";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookDeskIdList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_desk_list_4_area_desk_booking";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookDeskAreasForHod(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.db_select_list_qry.fn_area_list_4_dept_proj";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookObjIdList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_tag_obj_mapping_qry.fn_object_id_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DmsDeskBookObjIdList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dm_tag_obj_mapping_qry.fn_object_id_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookingTagForEmpList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbook_select_list_qry.fn_tag_list_4_emp";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> AreaList4AreaCatgCodeWise(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbook_select_list_qry.fn_area_list_area_catg_code_wise";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DmsTagTypeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dm_tag_obj_mapping_qry.fn_tag_master_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DmsTagObjectTypeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dm_tag_obj_mapping_qry.fn_tag_object_type_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookOfficeLocationList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbook_select_list_qry.fn_office_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HRMISDeptDeputationList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.mis_select_list_qry.fn_dept_deputation_list_all";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> FloorPlanBookDeskList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbook_select_list_qry.fn_book_desk_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> RegionsList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_region_holidays_qry.fn_region_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> TimesheetCostcodeList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_timesheet_qry.fn_get_timesheet_costcode_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> ItemTypeListForAssetMapping(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.inv_select_list_qry.fn_item_type_list_for_asset_mapping";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> DeskBookCabinIdList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbook_select_list_qry.fn_cabin_list_4_desk_booking";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataField>> HRAnnualEvalPendingList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_select_qry.fn_hr_annual_eval_pending_dept_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        #region SiteMapFilterDropdownList

        public List<DataField> GetSelfServiceApprovalsList()
        {
            var list = new List<DataField>();
            list.Add(new DataField { DataTextField = "", DataValueField = "" });
            list.Add(new DataField { DataTextField = "Lead Approval", DataValueField = "LeadApproval" });
            list.Add(new DataField { DataTextField = "Hod Approval", DataValueField = "HodApproval" });
            list.Add(new DataField { DataTextField = "HR Approval", DataValueField = "HrApproval" });
            return list;
        }

        #endregion SiteMapFilterDropdownList
    }
}