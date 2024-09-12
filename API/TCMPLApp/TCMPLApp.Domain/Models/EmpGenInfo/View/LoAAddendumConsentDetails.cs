using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class LoAAddendumConsentDetails : DBProcMessageOutput
    {
        public decimal? PAcceptanceStatusVal { get; set; }
        public string PAcceptanceStatusText { get; set; }
        public string PAcceptanceText { get; set; }
        public string PCommunicationDate { get; set; }
        public DateTime? PAcceptanceDate { get; set; }
    }
}