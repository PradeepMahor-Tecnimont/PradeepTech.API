using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterMiscUpdate
    {
        public string CommandText { get => HRMastersProcedure.EmployeeMasterMiscEdit; }
        public string PEmpno { get; set; }
        public string PDeptCode { get; set; }
        public string PEow { get; set; }
        public DateTime? PEowDate { get; set; }
        public Int32? PEowWeek { get; set; }
        public Int32? PEsiCover { get; set; }
        public string PIpadd { get; set; }
        public string PJobcategoorydesc { get; set; }
        public string PJobcategory { get; set; }
        public string PJobdiscipline { get; set; }        
        public string PJobgroup { get; set; }        
        public string PJobsubcategory { get; set; }
        public string PJobsubcategorydesc { get; set; }
        public string PJobsubdiscipline { get; set; }
        public string PJobsubdisciplinedesc { get; set; }
        public string PJobtitleCode { get; set; }
        public DateTime? PLastday { get; set; }
        public string PLocId { get; set; }
        public Int32? PNoTcmUpd { get; set; }
        public string POldco { get; set; }
        public Int32? POndeputation { get; set; }
        public string PPfslno { get; set; }
        public string PProjno { get; set; }
        public string PPwd { get; set; }
        public Int32? PReporting { get; set; }
        public string PReporto { get; set; }
        public Int32? PSecretary { get; set; }
        public DateTime? PTransIn { get; set; }
        public DateTime? PTransOut { get; set; }
        public string PUserDomain { get; set; }
        public Int32? PUserid { get; set; }
        public Int32? PWebItdecl { get; set; }
        public Int32? PWinidReqd { get; set; }        
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
