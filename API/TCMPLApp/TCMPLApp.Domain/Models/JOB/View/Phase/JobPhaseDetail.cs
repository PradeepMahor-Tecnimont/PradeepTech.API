using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobPhaseDetail : DBProcMessageOutput
    {        
        [Display(Name = "Description")]
        public string PDescription { get; set; }

        [Display(Name = "TMA group")]
        public string PTmagrp { get; set; }

        [Display(Name = "Block booking")]
        public decimal? PBlockbooking { get; set; }

        [Display(Name = "Block OT")]
        public decimal? PBlockot { get; set; }
    }
}
