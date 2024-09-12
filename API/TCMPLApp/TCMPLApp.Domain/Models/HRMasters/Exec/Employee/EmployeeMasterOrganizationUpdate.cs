using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterOrganizationUpdate
    {
        public string CommandText { get => HRMastersProcedure.EmployeeMasterOrganizationEdit; }
        public string PEmpno { get; set; }
        public DateTime? PDol { get; set; }
        public DateTime? PDor { get; set; }        
        public string PMngr { get; set; }
        public string PEmpHod { get; set; }
        public string PLocation { get; set; }
        public string PSapemp { get; set; }
        public string PItno { get; set; }
        public DateTime? PContractEndDate { get; set; }
        public string PSubcontract { get; set; }
        public string PCid { get; set; }
        public string PBankcode { get; set; }
        public string PAcctno { get; set; }
        public string PIfscno { get; set; }
        public string PGraduation { get; set; }
        public string PPlace { get; set; }
        public string PQualification { get; set; }
        public string PTitCd { get; set; }
        public string PJobTitle { get; set; }
        public string PGradyear { get; set; }
        public decimal? PExpbefore { get; set; }
        public int? PQualGroup { get; set; }
        public string PGratutityno { get; set; }
        public string PAadharno { get; set; }
        public string PPfno { get; set; }
        public string PSuperannuationno { get; set; }
        public string PUanno { get; set; }
        public string PPensionno { get; set; }
        public string PDiplomaYear { get; set; }
        public string PPostgraduationYear { get; set; }

        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
