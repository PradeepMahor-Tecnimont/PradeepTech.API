using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class OvertimeUpdateDataTableList
    {
        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Display(Name = "Yymm")]
        public string Yymm { get; set; }

        [Display(Name = "OT")]
        public decimal Ot { get; set; }
        public decimal? TotalRow { get; set; }
        public decimal RowNumber { get; set; }
    }
}
