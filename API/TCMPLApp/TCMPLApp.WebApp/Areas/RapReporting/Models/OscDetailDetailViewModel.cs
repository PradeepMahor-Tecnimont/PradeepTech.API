using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OscDetailDetailViewModel
    {
        [Display(Name = "OSCM id")]
        public string OscmId { get; set; }

        [Display(Name = "Cost code")]
        public string Costcode { get; set; }

        [Display(Name = "Name")]
        public string CostcodeDesc { get; set; }

    }
}