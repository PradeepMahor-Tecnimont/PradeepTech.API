using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterMainDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Employee no")]
        public string Empno { get; set; }
        
        [Display(Name = "Employee name")]
        public string Name { get; set; }
        
        [Display(Name = "Abbrivation")]
        public string Abbr { get; set; }
        
        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        //public string EmptypeDesc { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }
        
        [Display(Name = "Parent costcode")]
        public string Parent { get; set; }
        
        public string ParentAbbr { get; set; }

        [Display(Name = "Parent SAP code")]
        public string SapParent { get; set; }

        [Display(Name = "Assign costcode")]
        public string Assign { get; set; }

        public string AssignAbbr { get; set; }

        [Display(Name = "Assign SAP code")]
        public string SapAssign { get; set; }

        [Display(Name = "Designation")]
        public string Desgcode { get; set; }
        //public string Desg { get; set; }

        [Display(Name = "Date of brith")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Dob { get; set; }
        
        [Display(Name = "Date of joining")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Doj { get; set; }
        
        [Display(Name = "Office")]
        public string Office { get; set; }
        //public string OfficeName { get; set; }

        [Display(Name = "Gender")]
        public string Sex { get; set; }

        //public string GenderDesc { get; set; }

        [Display(Name = "Category")]
        public string Category { get; set; }
        
        [Display(Name = "Married")]
        public string Married { get; set; }
        
        [Display(Name = "Meta id")]
        public string Metaid { get; set; }
        
        [Display(Name = "Group person id")]
        public string Personid { get; set; }
        
        [Display(Name = "Grade")]
        public string Grade { get; set; }
        
        [Display(Name = "Company")]
        public string Company { get; set; }

        [Display(Name = "Date of confirm")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Doc { get; set; }
        
        [Display(Name = "First name")]
        public string Firstname { get; set; }
        
        [Display(Name = "Middle name")]
        public string Middlename { get; set; }
        
        [Display(Name = "Last name")]
        public string Lastname { get; set; }

        public Int16 Status { get; set; }

        public string IsEditable { get; set; }
    }
}
