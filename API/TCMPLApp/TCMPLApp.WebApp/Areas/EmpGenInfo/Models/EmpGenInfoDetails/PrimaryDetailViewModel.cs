using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class PrimaryDetailViewModel
    {
        [Display(Name = "EmpNo")]
        public string Empno { get; set; }

        [Display(Name = "Employee Name")]
        public string Name { get; set; }

        [Display(Name = "Emp Type")]
        public string EmpType { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Gender")]
        public string Gender { get; set; }

        [Display(Name = "Designation Code")]
        public string DesgCode { get; set; }

        [Display(Name = "Designation Name")]
        public string DesgName { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd-MMM-yyyy}")]
        [Display(Name = "Date of Joining")]
        public DateTime? Doj { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd-MMM-yyyy}")]
        [Display(Name = "Date of birth")]
        public string Dob { get; set; }

        [Display(Name = "Cost Code")]
        public string Parent { get; set; }

        [Display(Name = "Dept Name")]
        public string CostName { get; set; }

        [Display(Name = "Assign Code")]
        public string Assign { get; set; }

        [Display(Name = "Assign Name")]
        public string AssignName { get; set; }

        [Display(Name = "HoD")]
        public string HoD { get; set; }

        [Display(Name = "HoD Name")]
        public string HoDName { get; set; }

        [Display(Name = "Department Secretary")]
        public string Secretary { get; set; }

        [Display(Name = "Department Secretary")]
        public string SecName { get; set; }

        [Display(Name = "Permanent address")]
        public string PermanentAddress { get; set; }

        [Display(Name = "Address as it would appear on Nomination form")]
        public string NominationFormAddress { get; set; }

        [Display(Name = "GTLI nomination %age")]
        public decimal? GTLINominationPercent { get; set; }
    }
}