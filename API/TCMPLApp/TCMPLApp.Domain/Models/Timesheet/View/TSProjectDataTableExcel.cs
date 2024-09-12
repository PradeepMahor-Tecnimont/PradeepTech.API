using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class TSProjectDataTableExcel
    {       
        [Display(Name = "Month")]
        public string Yymm { get; set; }

        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Display(Name = "Project name")]
        public string Name { get; set; }
        
        [Display(Name = "Hours")]
        public decimal? Hours { get; set; }

        [Display(Name = "OT hours")]
        public decimal? OtHours { get; set; }

        [Display(Name = "Total hours")]
        public decimal? TotHours { get; set; }
    }
}
