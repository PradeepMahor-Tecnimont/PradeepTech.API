using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class RapHoursDataTableList
    {
        public string Yymm { get; set; }
        public decimal WorkDays { get; set; }
        public decimal Weekend { get; set; }
        public decimal Holidays { get; set; }
        public decimal Leave { get; set; }
        public decimal TotDays { get; set; }
        public decimal WorkingHr { get; set; }
        public decimal? TotalRow { get; set; }
        public decimal RowNumber { get; set; }
    }
}
