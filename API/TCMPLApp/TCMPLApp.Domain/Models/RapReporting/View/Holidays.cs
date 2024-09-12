using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public partial class Holidays
    {
        public DateTime? Holiday { get; set; }
        public string Yyyymm { get; set; }
        public string Weekday { get; set; }
        public string Description { get; set; }
        public string Holidayid { get; set; }
    }
}
