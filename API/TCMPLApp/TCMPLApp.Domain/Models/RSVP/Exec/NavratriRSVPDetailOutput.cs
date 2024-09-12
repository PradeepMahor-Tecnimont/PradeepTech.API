using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models
{
    public class NavratriRSVPDetailOutput : DBProcMessageOutput
    {       

        [Display(Name = "Attend")]
        public decimal? PAttend { get; set; }

        [Display(Name = "Bus")]
        public decimal? PBus { get; set; }

        [Display(Name = "Dinner")]
        public decimal? PDinner { get; set; }

        [Display(Name = "Counter")]
        public string PCounter { get; set; }
    }
}
