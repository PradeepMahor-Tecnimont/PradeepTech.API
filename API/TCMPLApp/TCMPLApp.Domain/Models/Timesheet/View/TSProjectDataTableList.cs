using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class TSProjectDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Month")]
        public string Yymm { get; set; }

        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Display(Name = "Project name")]
        public string Name { get; set; }

        [Display(Name = "Emp no")]
        public string Empno { get; set; }

        [Display(Name = "Employeename")]
        public string Empname { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Hours")]
        public decimal? Hours { get; set; }

        [Display(Name = "OT hours")]
        public decimal? OtHours { get; set; }

        [Display(Name = "Total hours")]
        public decimal? TotHours { get; set; }
    }
}
