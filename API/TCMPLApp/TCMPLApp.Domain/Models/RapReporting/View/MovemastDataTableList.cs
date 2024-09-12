using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class MovemastDataTableList
    {
        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Display(Name = "Yymm")]
        public string Yymm { get; set; }

        [Display(Name = "Movement")]
        public decimal? Movement { get; set; }

        [Display(Name = "Move to tcm")]
        public decimal? Movetotcm { get; set; }

        [Display(Name = "Move to site")]
        public decimal? Movetosite { get; set; }

        [Display(Name = "Move to others")]
        public decimal? Movetoothers { get; set; }

        [Display(Name = "Ext Sub contract")]
        public decimal? ExtSubcontract { get; set; }

        [Display(Name = "Future Recruit")]
        public decimal? FutRecruit { get; set; }

        [Display(Name = "Int Dept")]
        public decimal? IntDept { get; set; }

        [Display(Name = "HrsSubcont")]
        public decimal? HrsSubcont { get; set; }

        public decimal? CanEdit { get; set; }
        public decimal? CanDelete { get; set; }

        public decimal? TotalRow { get; set; }
        public decimal RowNumber { get; set; }
    }
}