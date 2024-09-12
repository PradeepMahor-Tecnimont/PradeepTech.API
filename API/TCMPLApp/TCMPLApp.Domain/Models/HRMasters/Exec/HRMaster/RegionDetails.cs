using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class RegionDetails : DBProcMessageOutput
    {
        public string PRegionName { get; set; }
        public string PModifiedBy { get; set; }
        public DateTime? PModifiedOn { get; set; }
    }
}
