using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobPhaseDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Job No")]
        public string Projno { get; set; }

        [Display(Name = "Phase")]
        public string Phase { get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }

        [Display(Name = "TMA group")]
        public string Tmagrp { get; set; }

        [Display(Name = "TMA group desc")]
        public string Tmagrpdesc { get; set; }

        [Display(Name = "Block booking")]
        public decimal? BlockBooking { get; set; }

        [Display(Name = "Block OT")]
        public decimal? BlockOt { get; set; }

        [Display(Name = "Is exits")]
        public decimal? Isexists { get; set; }
    }
}