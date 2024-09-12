using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class PhaseCreateViewModel
    {
        [Display(Name = "Job No")]
        public string Projno { get; set; }

        [Display(Name = "Phase")]
        public string Phase { get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }

        [Display(Name = "TMA group")]
        public string Tmagrp { get; set; }

        [Display(Name = "Block booking")]
        public decimal? Blockbooking { get; set; }

        [Display(Name = "Block OT")]
        public decimal? Blockot { get; set; }
    }
}
