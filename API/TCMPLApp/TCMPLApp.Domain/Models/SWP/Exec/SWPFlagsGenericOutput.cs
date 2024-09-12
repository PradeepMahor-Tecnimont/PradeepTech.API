using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.SWP
{
    public class SWPFlagsGenericOutput : DBProcMessageOutput
    {
        public string PFlagCode { get; set; }
        public string PFlagDesc { get; set; }
        public string PFlagValue { get; set; }
        public decimal? PFlagValueNumber { get; set; }
        public DateTime? PFlagValueDate { get; set; }
    }
}