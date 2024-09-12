using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OscSesDataTableExcel
    {
        [Display(Name = "Project no")]
        public string ProjectNo { get; set; }

        [Display(Name = "Project name")]
        public string ProjectName { get; set; }

        [Display(Name = "SES no")]
        public string SesNo { get; set; }

        [Display(Name = "SES date")]
        public DateTime? SesDate { get; set; }

        [Display(Name = "SES amount")]
        public decimal SesAmount { get; set; }
    }
}