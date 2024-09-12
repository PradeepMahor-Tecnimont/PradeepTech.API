using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class AccessGrantExcelModel
    {
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Employee MetaId")]
        public string EmpMetaid { get; set; }

        [Display(Name = "Manager MetaId ")]
        public string ManagerMetaid { get; set; }

        [Display(Name = "Manager name")]
        public string ManagerName { get; set; }

        [Display(Name = "UserId")]
        public string Userid { get; set; }

        //[Display(Name = "Employee name")]
        //public string EmpName { get; set; }

        [Display(Name = "Full name")]
        public string FullName { get; set; }

        [Display(Name = "Start date")]
        public string StartDate { get; set; }

        [Display(Name = "End date")]
        public string EndDate { get; set; }

        [Display(Name = "Role Name")]
        public string RoleName { get; set; }

        [Display(Name = "Company")]
        public string Company { get; set; }

        [Display(Name = "Role description")]
        public string RoleDesc { get; set; }

        [Display(Name = "System")]
        public string System { get; set; }

        [Display(Name = "Module")]
        public string Module { get; set; }

        [Display(Name = "Process owner")]
        public string ProcessOwner { get; set; }

        [Display(Name = "Role on CostCode")]
        public string RoleOnCostcode { get; set; }

        [Display(Name = "Role on project no")]
        public string RoleOnProjno { get; set; }

        [Display(Name = "Approver")]
        public string Approver { get; set; }
    }
}