using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class EmployeeMasterRolesEditViewModel
    {
        [Required]
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [DefaultValue(0)]
        [Display(Name = "Job Form Approver- AMFI")]
        public Int32? AmfiAuth { get; set; }

        [DefaultValue(0)]
        [Display(Name = "Job Form User- AMFI")]
        public Int32? AmfiUser { get; set; }

        [DefaultValue(0)]
        [Display(Name = "Cost Deputy")]
        public Int32? Costdy { get; set; }

        [DefaultValue(0)]
        [Display(Name = "Cost Head")]
        public Int32? Costhead { get; set; }

        [DefaultValue(0)]
        [Display(Name = "Costcode operator")]
        public Int32? Costopr { get; set; }

        [DefaultValue(0)]
        [Display(Name = "RAP  Admin")]
        public Int32? Dba { get; set; }

        [DefaultValue(0)]
        [Display(Name = "RAP Reporting Admin")]
        public Int32? Director { get; set; }

        [DefaultValue(0)]
        [Display(Name = "Job Form Approver - MD/CMD")]
        public Int32? Dirop { get; set; }

        [DefaultValue(0)]
        [Display(Name = "Project Deputy")]
        public Int32? Projdy { get; set; }

        [DefaultValue(0)]
        [Display(Name = "Project Manager")]
        public Int32? Projmngr { get; set; }
    }
}
