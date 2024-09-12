using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class TSRepostingDetailsOut : DBProcMessageOutput
    {
        public decimal? PRepost { get; set; }
        public string PProcMonth { get; set; }
    }
}
