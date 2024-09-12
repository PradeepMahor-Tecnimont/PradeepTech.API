using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class SubcontractEmployeePivot
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Status")]
        public string  Status { get; set; }

        [Display(Name = "Emptype")]
        public string Emptype { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Parent abbr")]
        public string ParentAbbr { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "DoB")]
        public DateTime? Dob { get; set; }

        [Display(Name = "DoJ")]
        public DateTime? Doj { get; set; }

        [Display(Name = "Location")]
        public string Location { get; set; }
        
        [Display(Name = "Subcontract")]
        public string Subcontract { get; set; }

        [Display(Name = "Subcontract name")]
        public string SubcontractName { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Gender")]
        public string Gender { get; set; }
        
        [Display(Name = "Grade")]
        public string Grade { get; set; }

    }
}
