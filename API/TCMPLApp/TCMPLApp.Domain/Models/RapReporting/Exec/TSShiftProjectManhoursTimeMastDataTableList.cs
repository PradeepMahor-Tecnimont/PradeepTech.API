using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting.Exec
{
    public class TSShiftProjectManhoursTimeMastDataTableList
    {
        public string Yymm { get; set; }

        public string Empno { get; set; }

        public string Name { get; set; }

        public string Parent { get; set; }

        public string Assign { get; set; }

        [Display(Name = "Group")]
        public string Grp { get; set; }

        [Display(Name = "Normal hours")]
        public decimal? NormalHours { get; set; }

        [Display(Name = "OT hours")]
        public decimal? OtHours { get; set; }

        public string Company { get; set; }

        [Display(Name = "More than 240 hours")]
        public string Exceed { get; set; }

        [Display(Name = "Status")]
        public string Status { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

    }
}
