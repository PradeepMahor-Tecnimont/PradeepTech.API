using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OWSEmpAbsentExcelModel
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }


        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Emptype")]
        public string Emptype { get; set; }

        public string PrimaryWorkspaceText { get; set; }
        public string DeskId { get; set; }

        public string IsAbsent { get; set; }



    }
}
