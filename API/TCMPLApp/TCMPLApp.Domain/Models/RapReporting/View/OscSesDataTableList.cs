using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class OscSesDataTableList
    {
        public decimal? RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "SES id")]
        public string OscsId { get; set; }

        [Display(Name = "OSCM Id")]
        public string OscmId { get; set; }

        [Display(Name = "Project no")]
        public string ProjectNo { get; set; }

        [Display(Name = "Project name")]
        public string ProjectName { get; set; }

        [Display(Name = "SES No")]
        public string SesNo { get; set; }

        [Display(Name = "SES date")]
        public string SesDate { get; set; }

        [Display(Name = "SES amount")]
        public double? SesAmount { get; set; }
    }
}