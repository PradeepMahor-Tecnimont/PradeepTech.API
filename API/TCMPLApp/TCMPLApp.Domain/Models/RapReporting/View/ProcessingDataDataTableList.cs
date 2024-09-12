using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class ProcessingDataDataTableList
    {
        [Display(Name = "Step No")]
        public decimal StepNo { get; set; }

        [Display(Name = "Created On")]
        public string CreatedOn { get; set; }

        [Display(Name = "Process Log Type")]
        public string ProcessLogType { get; set; }

        [Display(Name = "Process Log")]
        public string ProcessLog { get; set; }
    }
}
