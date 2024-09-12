using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class ActivityDetails : DBProcMessageOutput
    {
        public string PName { get; set; }
        public string PTlpcode { get; set; }
        public string PActivityType { get; set; }
        public decimal? PIsActive { get; set; }


    }
}
