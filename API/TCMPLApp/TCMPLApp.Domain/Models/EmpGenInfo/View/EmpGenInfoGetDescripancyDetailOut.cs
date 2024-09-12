using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class EmpGenInfoGetDescripancyDetailOut : DBProcMessageOutput
    {
        public string PPrimaryStatus { get; set; }
        public string PPrimaryText { get; set; }
        public string PNominationStatus { get; set; }
        public string PNominationText { get; set; }
        public string PGratuityStatus { get; set; }
        public string PGratuityText { get; set; }
        public string PEpfStatus { get; set; }
        public string PEpfText { get; set; }
        public string PEpsaStatus { get; set; }
        public string PEpsaText { get; set; }
        public string PEpsmStatus { get; set; }
        public string PEpsmText { get; set; }
        public string PMediclaimStatus { get; set; }
        public string PMediclaimText { get; set; }
        public string PCanMediclaimAdd { get; set; }
        public string PCanMediclaimEdit { get; set; }
        public string PPpAaStatus { get; set; }
        public string PPpAaText { get; set; }
        public string PAaStatus { get; set; }
        public string PAaText { get; set; }
        public string PGtliStatus { get; set; }
        public string PGtliText { get; set; }
        public string PCanPrintGtli { get; set; }
        public string PSupAnnuStatus { get; set; }
        public string PSupAnnuText { get; set; }
    }
}