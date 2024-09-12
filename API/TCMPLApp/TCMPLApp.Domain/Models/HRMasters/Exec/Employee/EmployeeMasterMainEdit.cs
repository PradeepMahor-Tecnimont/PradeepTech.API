using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterMainEdit
    {
        public string CommandText { get => HRMastersProcedure.EmployeeMasterMainEdit; }   
        public string PEmpno { get; set; }       
        public string PAbbr { get; set; }
        public string PEmptype { get; set; }        
        public string PEmail { get; set; }
        public string PParent { get; set; }
        public string PAssign { get; set; }
        public string PDesgcode { get; set; }
        public DateTime? PDob { get; set; }
        public DateTime? PDoj { get; set; }
        public string POffice { get; set; }
        public string PSex { get; set; }
        public string PCategory { get; set; }
        public string PMarried { get; set; }
        public string PMetaid { get; set; }
        public string PPersonid { get; set; }
        public string PGrade { get; set; }
        public string PCompany { get; set; }
        public DateTime? PDoc { get; set; }
        public string PFirstname { get; set; }
        public string PMiddlename { get; set; }
        public string PLastname { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
