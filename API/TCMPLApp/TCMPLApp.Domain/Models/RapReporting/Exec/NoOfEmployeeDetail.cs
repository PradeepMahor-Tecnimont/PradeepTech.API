using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class NoOfEmployeeDetail : DBProcMessageOutput
    {
        public decimal? PNoofemps { get; set; }
        public decimal? PChangedNemps { get; set; }
    }
}