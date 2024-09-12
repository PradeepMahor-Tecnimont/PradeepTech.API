using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models
{
    public class NavratriRSVPExcelList
    {
        [Display(Name = "Emp no.")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string Name { get; set; }

        [Display(Name = "Costcode")]
        public string Abbr { get; set; }

        [Display(Name = "Gender")]
        public string Gender { get; set; }

        [Display(Name = "Attend")]
        public string Attend { get; set; }
        [Display(Name = "Bus")]
        public string Bus { get; set; }

        [Display(Name = "Dinner")]
        public string Dinner { get; set; }

    }
}