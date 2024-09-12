using System;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DmAreaTypeDetails : DBProcMessageOutput
    {
        public string PShortDesc { get; set; }
        public string PDescription { get; set; }
        public decimal? PIsActiveVal { get; set; }
        public string PIsActiveText { get; set; }

        public DateTime? PModifiedOn { get; set; }
        public string PModifiedBy { get; set; }
    }
}