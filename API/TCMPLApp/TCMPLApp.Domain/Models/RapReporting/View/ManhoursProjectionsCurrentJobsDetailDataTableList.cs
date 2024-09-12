using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.Domain.Models.RapReporting
{
    public class ManhoursProjectionsCurrentJobsDetailDataTableList
    {
        [Display(Name = "Cost code")]
        public string Costcode { get; set; }

        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Display(Name = "Yymm")]
        public string Yymm { get; set; }

        [Display(Name = "Hours")]
        public decimal Hours { get; set; }
        public decimal? TotalRow { get; set; }
        public decimal RowNumber { get; set; }
    }
}
