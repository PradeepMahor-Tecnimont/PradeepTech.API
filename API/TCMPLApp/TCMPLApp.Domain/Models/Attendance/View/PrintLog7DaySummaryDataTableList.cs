using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.Domain.Models.Attendance
{
    [Serializable]
    public class PrintLog7DaySummaryDataTableList
    {

        [Display(Name = "Print date")]
        public string PrintDate  { get; set; }
        
        [Display(Name = "Page count")]
        public decimal PageCount { get; set; }
        

    }
}
