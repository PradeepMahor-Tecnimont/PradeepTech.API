using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class FilterDataModel
    {
        [Display(Name = "Search")]
        public string GenericSearch { get; set; }

        [Display(Name = "Search")]
        public string ModalSearch { get; set; }

        public int? Status { get; set; }

        public string Name { get; set; }

        public string Parent { get; set; }

        public string Assign { get; set; }

        public string Desgcode { get; set; }

        public string Desg { get; set; }

        [Display(Name = "On duty Type")]
        public string OndutyType { get; set; }

        [Display(Name = "Leave type")]
        public string LeaveType { get; set; }

        [Display(Name = "Start date")]
        public DateTime? StartDate { get; set; }

        [Display(Name = "Employee")]
        public string Empno { get; set; }

        [Display(Name = "End date")]
        public DateTime? EndDate { get; set; }

        public string ActionName { get; set; }

        [Display(Name = "Employee type")]
        public string[] EmployeeTypeList { get; set; }

        [Display(Name = "Grade")]
        public string[] GradeList { get; set; }

        [Display(Name = "Eligible for SWP")]
        public string EligibleForSWP { get; set; }

        [Display(Name = "Laptop user")]
        public string LaptopUser { get; set; }

        [Display(Name = "Primary workspace")]
        public string[] PrimaryWorkspaceList { get; set; }

        [Display(Name = "Is active")]
        public int? IsActive { get; set; }

        [Display(Name = "Exclude X1 - Employees")]
        public int? IsExcludeX1Employees { get; set; }

        [Display(Name = "Exclude X1 - Employees")]
        public int? IsExcludeX1EmployeesForDay { get; set; }

        /// <summary>
        /// Start - (CR000064) New Attendance Status Report - Weekly analysis for the month
        /// </summary>

        [Display(Name = "Exclude X1 - Employees")]
        public int? IsExcludeX1EmployeesForMonth { get; set; }

        [Display(Name = "Employee location")]
        public string IncludeEmployeeLocation { get; set; }

        [Display(Name = "Employee location")]
        public string IncludeEmployeeLocationForDay { get; set; }

        [Display(Name = "Employee location")]
        public string IncludeEmployeeLocationForMonth { get; set; }

        /// <summary>
        /// End - (CR000064) New Attendance Status Report - Weekly analysis for the month
        /// </summary>

        [Display(Name = "Is active future")]
        public int? IsActiveFuture { get; set; }

        [Display(Name = "Desk assignment")]
        public string DeskAssigmentStatus { get; set; }

        [Display(Name = "Currency")]
        public string Currency { get; set; }

        [Display(Name = "Company ")]
        public string CompanyCode { get; set; }

        [Display(Name = "Vendor")]
        public string Vendor { get; set; }

        [Display(Name = "Status")]
        public string StatusString { get; set; }

        [Display(Name = "Work Area")]
        public string WorkArea { get; set; }

        [Display(Name = "Area Category")]
        public string AreaCategory { get; set; }

        [Display(Name = "Action type")]
        public string ActionType { get; set; }

        [Display(Name = "Asset category")]
        public string AssetCategory { get; set; }

        #region RapReporting

        [Display(Name = "Year month")]
        public string Yymm { get; set; }

        [Display(Name = "Cost code")]
        public string CostCode { get; set; }

        [Display(Name = "Project")]
        public string Projno { get; set; }

        [Display(Name = "Cost center")]
        public string CostCenter { get; set; }

        [Required]
        [Display(Name = "Year month")]
        public string Yyyymm { get; set; }

        [Display(Name = "Report for")]
        public string RepFor { get; set; }

        [Required]
        [Display(Name = "Year mode")]
        public string YearMode { get; set; }

        public string Keyid { get; set; }
        public string User { get; set; }

        [Required]
        [Display(Name = "Year")]
        public string Yyyy { get; set; }

        [Display(Name = "Report id")]
        public string Reportid { get; set; }

        public string Runmode { get; set; }
        public string Category { get; set; }

        [Display(Name = "Report type")]
        public string ReportType { get; set; }

        [Display(Name = "Simulation")]
        public string Simul { get; set; }

        public string ControllerName { get; set; }

        public string Dummy_CostCode { get; set; }
        public string Dummy_Projno { get; set; }

        [Display(Name = "Project")]
        public string ProjectNo { get; set; }

        [Display(Name = "Simulation")]
        public string Sim { get; set; }

        #endregion RapReporting

        #region Employee referral program

        [Display(Name = "Job reference")]
        public string JobRefCode { get; set; }

        [Display(Name = "Location")]
        public string Location { get; set; }

        [Display(Name = "From date")]
        public DateTime? OpenFromDate { get; set; }

        [Display(Name = "To date")]
        public DateTime? OpenToDate { get; set; }

        #endregion Employee referral program

        #region Bank guarantee

        [Display(Name = "From")]
        public DateTime? BgFromDate { get; set; }

        [Display(Name = "To")]
        public DateTime? BgToDate { get; set; }

        [Display(Name = "From")]
        public DateTime? BgValFromDate { get; set; }

        [Display(Name = "To")]
        public DateTime? BgValToDate { get; set; }

        [Display(Name = "From")]
        public DateTime? BgClaimFromDate { get; set; }

        [Display(Name = "To")]
        public DateTime? BgClaimToDate { get; set; }

        [Display(Name = "Type")]
        public string BgType { get; set; }

        [Display(Name = "Blocked desk")]
        public decimal? IsBlocked { get; set; }

        #endregion Bank guarantee

        [Display(Name = "Module")]
        public string ModuleId { get; set; }

        [Display(Name = "Role")]
        public string RoleId { get; set; }

        [Display(Name = "Action")]
        public string ActionId { get; set; }

        [Display(Name = "Primary")]
        public decimal? IsPrimaryOpen { get; set; }

        [Display(Name = "Secondary")]
        public decimal? IsSecondaryOpen { get; set; }

        [Display(Name = "Mediclaim")]
        public decimal? IsMediclaimOpen { get; set; }

        [Display(Name = "Aadhaar")]
        public decimal? IsAadhaarOpen { get; set; }

        [Display(Name = "Passport")]
        public decimal? IsPassportOpen { get; set; }

        [Display(Name = "Nomination")]
        public decimal? IsNominationOpen { get; set; }

        [Display(Name = "GTLI")]
        public decimal? IsGtliOpen { get; set; }

        [Display(Name = "Submitted Type")]
        public string SubmitStatus { get; set; }

        [Display(Name = "Ex Employee No")]
        public string ExEmpno { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Office location")]
        public string OfficeLocationCode { get; set; }

        [Display(Name = "Department")]
        public string Costcode { get; set; }

        [Display(Name = "From Department")]
        public string FromDept { get; set; }

        [Display(Name = "To Department")]
        public string ToDept { get; set; }

        [Display(Name = "Resignation Status")]
        public string ResignStatusCode { get; set; }

        [Display(Name = "Floor")]
        public string Floor { get; set; }

        [Display(Name = "Wing")]
        public string Wing { get; set; }

        [Display(Name = "Department")]
        public string Department { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Designation")]
        public string Designation { get; set; }

        [Display(Name = "PC Model")]
        public string PcModelList { get; set; }

        [Display(Name = "Monitor Model")]
        public string MonitorModel { get; set; }

        [Display(Name = "Dual Monitor")]
        public int? DualMonitor { get; set; }

        [Display(Name = "Vacant desk")]
        public int? VacantDesk { get; set; }

        [Display(Name = "Tel Model")]
        public string TelModel { get; set; }

        [Display(Name = "Printer Model")]
        public string PrinterModel { get; set; }

        [Display(Name = "Docking Station Model")]
        public string DocstnModel { get; set; }

        [Display(Name = "LOT")]
        public string Lot { get; set; }

        [Display(Name = "Employee Type")]
        public string EmpType { get; set; }

        [Display(Name = "LogStatus")]
        public string LogStatus { get; set; }

        [Display(Name = "PrincipalEmpno")]
        public string PrincipalEmpno { get; set; }

        [Display(Name = "OnBehalfEmpno")]
        public string OnBehalfEmpno { get; set; }

        [Display(Name = "Select Year")]
        public DateTime? SelectYear { get; set; }

        [Display(Name = "Item Usable")]
        public string ItemUsable { get; set; }

        [Display(Name = "Select Start Year")]
        public DateTime? StartYear { get; set; }

        [Display(Name = "Select End Year")]
        public DateTime? EndYear { get; set; }

        [Display(Name = "Date")]
        public DateTime? Date1 { get; set; }

        [Display(Name = "Desk No")]
        public string DeskNo { get; set; }

        [Display(Name = "Current Costcode")]
        public string CurrentCostcode { get; set; }

        [Display(Name = "Target Costcode")]
        public string TargetCostcode { get; set; }

        [Display(Name = "Area")]
        public string AreaId { get; set; }

        [Display(Name = "Desk Type")]
        public string DeskType { get; set; }

        [Display(Name = "Closed project")]
        public string ClosedProjno { get; set; }

        [Display(Name = "Area Category")]
        public string AreaCatgCode { get; set; }

        [Display(Name = "Area Type")]
        public string AreaType { get; set; }

        [Display(Name = "Tag")]
        public string TagId { get; set; }

        [Display(Name = "Object Type")]
        public string ObjTypeId { get; set; }

        [Display(Name = "Is Restricted")]
        public decimal? IsRestricted { get; set; }

        [Display(Name = "Cabin")]
        public string Cabin { get; set; }

        [Display(Name = "Booking Date")]
        public string BookingDate { get; set; }

        [Display(Name = "Is Present")]
        public int? IsPresent { get; set; }

        [Display(Name = "Is DeskBooked")]
        public int? IsDeskBooked { get; set; }

        [Display(Name = "Is cross attend")]
        public int? IsCrossAttend { get; set; }

        [Display(Name = "Is Punch Aval")]
        public decimal? IsPunchAval { get; set; }

        [Display(Name = "Region Code")]
        public string[] RegionCode { get; set; }

        [Display(Name = "Salary Month Status")]
        public string SalaryMonthStatus { get; set; }
        
        [Display(Name = "Salary Month Status")]
        public DateTime? PayslipYyyymm { get; set; }

        public bool IsYes { get; set; }

        [Display(Name = "Year")]
        public string Year { get; set; }

        [Display(Name = "Group Type")]
        public string GroupType { get; set; }

        [Display(Name = "Asset Type")]
        public string[] AssetType { get; set; }

        [Display(Name = "Attendance Date")]
        public DateTime? AttendanceDate { get; set; }
        public bool IsFiltered
        {
            get
            {
                if (StartDate != null ||
                     EndDate != null)
                {
                    return true;
                }
                return false;
            }
        }
    }
}