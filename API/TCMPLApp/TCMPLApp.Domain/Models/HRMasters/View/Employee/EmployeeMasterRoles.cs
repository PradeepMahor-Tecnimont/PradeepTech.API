using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterRoles
    {
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        public string Name { get; set; }

        [UIHint("YesNo")]
        [Display(Name = "Job Form Approver- AMFI")]
        public Int32? AmfiAuth { get; set; }

        [Display(Name = "Job Form User- AMFI")]
        public Int32? AmfiUser { get; set; }

        [Display(Name = "Cost Deputy")]
        public Int32? Costdy { get; set; }

        [Display(Name = "Cost Head")]
        public Int32? Costhead { get; set; }

        [Display(Name = "Costcode operator")]
        public Int32? Costopr { get; set; }

        [Display(Name = "RAP  Admin")]
        public Int32? Dba { get; set; }

        [Display(Name = "RAP Reporting Admin")]
        public Int32? Director { get; set; }

        [Display(Name = "Job Form Approver - MD/CMD")]
        public Int32? Dirop { get; set; }

        [Display(Name = "Project Deputy")]
        public Int32? Projdy { get; set; }

        [Display(Name = "Project Manager")]
        public Int32? Projmngr { get; set; }

        public Int32? Status { get; set; }
        public string IsEditable { get; set; }
    }
}
