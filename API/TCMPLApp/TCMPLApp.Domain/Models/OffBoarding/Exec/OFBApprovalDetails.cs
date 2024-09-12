using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OFBApprovalDetails : DBProcMessageOutput
    {
        public string PEmpno { get; set; }
        public string PEmployeeName { get; set; }
        public string PPersonId { get; set; }
        public string PParent { get; set; }
        public string PGrade { get; set; }
        public string PInitiatorRemarks { get; set; }
        public string PMobilePrimary { get; set; }
        public string PAlternateNumber { get; set; }
        public string PAddress { get; set; }
        public string PEmailId { get; set; }
        public DateTime PRelievingDate { get; set; }
        public DateTime PResignationDate { get; set; }
        public DateTime PDoj { get; set; }

    }
}
