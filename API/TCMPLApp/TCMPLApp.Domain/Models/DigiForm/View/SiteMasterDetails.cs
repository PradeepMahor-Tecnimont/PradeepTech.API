using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DigiForm
{
    public class SiteMasterDetails : DBProcMessageOutput
    {
        public string PSiteName { get; set; }
        public string PSiteLocation { get; set; }
        public DateTime? PModifiedOn { get; set; }
        public string PModifiedBy { get; set; }
        public decimal PIsActiveVal { get; set; }
        public string PIsActiveText { get; set; }
    }
}
