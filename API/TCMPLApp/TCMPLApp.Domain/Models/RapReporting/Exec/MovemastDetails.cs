using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class MovemastDetails : DBProcMessageOutput
    {
        [Display(Name = "Movement")]
        public decimal? PMovement { get; set; }

        [Display(Name = "Move to tcm")]
        public decimal? PMovetotcm { get; set; }

        [Display(Name = "Move to site")]
        public decimal? PMovetosite { get; set; }

        [Display(Name = "Move to others")]
        public decimal? PMovetoothers { get; set; }

        [Display(Name = "Ext Sub contract")]
        public decimal? PExtSubcontract { get; set; }

        [Display(Name = "Future Recruit")]
        public decimal? PFutRecruit { get; set; }

        [Display(Name = "Int Dept")]
        public decimal? PIntDept { get; set; }

        [Display(Name = "HrsSubcont")]
        public decimal? PHrsSubcont { get; set; }

        [Display(Name = "Last Yymm")]
        public string PLastYymm { get; set; }

        [Display(Name = "Locked month")]
        public string PLockedMonth { get; set; }

        [Display(Name = "Processing month")]
        public string PProsMonth { get; set; }
    }
}