using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class ManhoursProjectionsCurrentJobsDetailForExcelDataTableList
    {
        [Display(Name = "Cost code")]
        public string Costcode { get; set; }

        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Display(Name = "Yymm")]
        public string Yymm { get; set; }

        [Display(Name = "Hours")]
        public decimal Hours { get; set; }
    }
}
