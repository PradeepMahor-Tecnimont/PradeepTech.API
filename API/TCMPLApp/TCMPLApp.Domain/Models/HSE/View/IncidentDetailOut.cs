using System;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HSE
{
    public class IncidentDetailOut : DBProcMessageOutput
    {        
        public DateTime? PReportdate { get; set; }
        public string PYyyy { get; set; }
        public string POffice { get; set; }
        public string PLoc { get; set; }
        public string PCostcode { get; set; }
        public DateTime? PIncdate  { get; set; }
        public string PInctime { get; set; }
        public string PInctype { get; set; }
        public string PInctypename { get; set; }
        public string PNature { get; set; }
        public string PNaturename { get; set; }
        public string PInjuredparts { get; set; }
        public string PEmpno { get; set; }
        public string PEmpname { get; set; }
        public string PDesg { get; set; }
        public string PAge { get; set; }
        public string PSex { get; set; }
        public string PSubcontract { get; set; }
        public string PSubcontractname { get; set; }
        public string PAid { get; set; }
        public string PDescription { get; set; }
        public string PCauses { get; set; }
        public string PAction { get; set; }        
        public string PCorrectiveactions { get; set; }        
        public string PCloser { get; set; }  
        public DateTime? PCloserdate { get; set; }        
        public string PAttchmentlink { get; set; }
        public decimal PMailsend { get; set; }
        public decimal PIsactive { get; set; }
        public decimal PIsdelete { get; set; }



    }
}