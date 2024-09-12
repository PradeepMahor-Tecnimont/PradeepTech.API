using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class ReportDetail
    {
        [Display(Name = "Key")]
        public string KeyId { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Report id")]
        public string ReportId { get; set; }

        [Display(Name = "Report name")]
        public string ReportName { get; set; }

        [Display(Name = "Report url")]
        public string ReportUrl { get; set; }

        [Display(Name = "Report parameter")]
        public string ReportParameter { get; set; }
    }
}