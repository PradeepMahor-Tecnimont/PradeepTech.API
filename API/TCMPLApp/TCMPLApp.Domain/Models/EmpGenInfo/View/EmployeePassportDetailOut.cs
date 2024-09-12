using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class EmployeePassportDetailOut : DBProcMessageOutput
    {
        //public string PEmpno { get; set; }
        public string PHasPassport { get; set; }

        public string PSurname { get; set; }
        public string PGivenName { get; set; }
        public DateTime? PIssueDate { get; set; }
        public DateTime? PExpiryDate { get; set; }
        public string PIssuedAt { get; set; }
        public string PModifiedBy { get; set; }
        public string PPassportNo { get; set; }
        public string PFileName { get; set; }

        public DateTime? PModifiedOn { get; set; }
    }
}