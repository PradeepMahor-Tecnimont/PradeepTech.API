using System;
using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.RAPEntityModels
{
    public partial class EmplmastVM
    {
        [Key]
        public string EmpCode { get; set; }

        public string EmpName { get; set; }
        public string ShortCd { get; set; }
        public string Emptype { get; set; }
        public string Office { get; set; }      // Offimast (Description)
        public string ParentCost { get; set; }  // CostMast (Name)
        public string AssignCost { get; set; }  // CostMast (Name)
        public string Designation { get; set; } // DesgMast (Desg)
        public DateTime? DateOfBirth { get; set; }
        public DateTime? DateOfJoining { get; set; }
        public DateTime? DateOfLeaving { get; set; }
        public DateTime? DateOfReturn { get; set; }
        public bool? Costhead { get; set; }
        public bool? Costdy { get; set; }
        public bool? Projmngr { get; set; }
        public bool? Projdy { get; set; }
        public bool? Dba { get; set; }
        public bool? Director { get; set; }
        public bool? EmpStatus { get; set; }
        public bool? TimesheetReqd { get; set; }
        public bool? Dirop { get; set; }
        public bool? AmfiUser { get; set; }
        public bool? AmfiAuth { get; set; }
        public bool? Secretary { get; set; }
        public string TimeOpr { get; set; }
        public bool? JobIncharge { get; set; }
        public bool? Costopr { get; set; }
        public string Manager { get; set; }
        public string Grade { get; set; }
        public bool? ProcOpr { get; set; }
        public string Company { get; set; }
        public bool? HrOpr { get; set; }
        public string Gender { get; set; }
        public string EmpHod { get; set; }
        public bool? NewEmployeePC { get; set; }
        public string Jobtitle { get; set; }
        public string Lastname { get; set; }
        public string Firstname { get; set; }
        public string Middlename { get; set; }
        public string Jobgroup { get; set; }
        public string Jobdiscipline { get; set; }
        public string Jobsubdiscipline { get; set; }
        public string Jobcategory { get; set; }
        public string Jobsubcategory { get; set; }
    }
}