using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class ResignedEmployeeDetails : DBProcMessageOutput
    {
        public string PEmpno { get; set; }

        public string PEmployeeName { get; set; }
        public DateTime? PEmpResignDate { get; set; }

        public DateTime? PHrReceiptDate { get; set; }

        public DateTime? PDateOfRelieving { get; set; }

        public string PEmpResignReason { get; set; }

        public string PPrimaryReason { get; set; }
        public string PPrimaryReasonDesc { get; set; }

        public string PSecondaryReason { get; set; }
        public string PSecondaryReasonDesc { get; set; }

        public string PAdditionalFeedback { get; set; }

        public string PExitInterviewComplete { get; set; }

        public decimal? PPercentIncrease { get; set; }
        public string PMovingToLocation { get; set; }
        public string PCurrentLocation { get; set; }
        public string PCurrentLocDesc { get; set; }

        public string PResignStatusCode { get; set; }
        public string PResignStatusDesc { get; set; }

        public string PCommitmentOnRollback { get; set; }

        public DateTime? PActualLastDateInOffice { get; set; }

        public DateTime? PDoj { get; set; }

        public string PGrade { get; set; }

        public string PDesignation { get; set; }

        public string PDepartment { get; set; }
        public string PEmailSent { get; set; }
    }
}