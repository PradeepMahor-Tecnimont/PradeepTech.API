using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class ShiftMasterDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Shiftcode")]
        public string Shiftcode { get; set; }

        [Display(Name = "Shift Description")]
        public string Shiftdesc { get; set; }

        [Display(Name = "Time In")]
        public decimal TimeinHh { get; set; }

        [Display(Name = "Time In Min")]
        public decimal TimeinMn { get; set; }

        [Display(Name = "Time Out")]
        public decimal TimeoutHh { get; set; }

        [Display(Name = "Time Out Min")]
        public decimal TimeoutMn { get; set; }

        [Display(Name = "Shift Allowance")]
        public decimal Shift4allowance { get; set; }
        public string Shift4allowanceText{ get; set; }
        
        [Display(Name = "Lunch")]
        public decimal LunchMn { get; set; }
        
        [Display(Name = "OT Applicable")]
        public decimal OtApplicable { get; set; }
        public string OtApplicableText { get; set; }
    }
}
