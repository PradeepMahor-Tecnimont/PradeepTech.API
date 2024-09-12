using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.RAPReporting.WinService.Classes
{
    //Http Client Model
    public class HCModel
    {

        [Display(Name = "Year month")]
        public string Yymm { get; set; }

        [Required]
        [Display(Name = "Year mode")]
        public string YearMode { get; set; }
        public string Keyid { get; set; }
        public string User { get; set; }

        [Required]
        [Display(Name = "Year")]
        public string Yyyy { get; set; }

        [Display(Name = "Report id")]
        public string Reportid { get; set; }
        public string Category { get; set; }

        [Display(Name = "Report type")]
        public string ReportType { get; set; }

        [Display(Name = "Simulation")]
        public string Simul { get; set; }
        public string Runmode { get; set; }
        public string Costcode { get; set; }
        public string Status { get; set; }
        public string Projno { get; set; }
        public string ReportMode { get; set; }

    }
}
