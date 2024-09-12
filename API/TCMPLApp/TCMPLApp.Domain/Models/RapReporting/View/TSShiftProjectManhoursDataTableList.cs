using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class TSShiftProjectManhoursDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        public string LogId { get; set; }

        [Display(Name = "From month")]
        public string YymmFrom { get; set; }

        [Display(Name = "To month")]
        public string YymmTo { get; set; }

        [Display(Name = "From project")]
        public string ProjnoFrom { get; set; }

        [Display(Name = "To project")]
        public string ProjnoTo { get; set; }

        [Display(Name = "Status")]
        public string MessageType { get; set; }

        [Display(Name = "Remarks")]
        public string MessageText { get; set; }

    }
}
