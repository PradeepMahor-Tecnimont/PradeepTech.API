using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class ProspectiveEmployeesDetails : DBProcMessageOutput
    {
        public string PCostcode { get; set; }
        public string PEmpName { get; set; }
        public string POfficeLocationCode { get; set; }
        public DateTime? PProposedDoj { get; set; }
        public DateTime? PRevisedDoj { get; set; }
        public string PJoinStatusCode { get; set; }
        public string PEmpno { get; set; }

        public string PGrade { get; set; }
        public string PDesignation { get; set; }
        public string PEmploymentType { get; set; }
        public string PSourcesOfCandidate { get; set; }

        public string PPreEmplmntMedclTest { get; set; }
        public string PRecForAppt { get; set; }
        public string POfferLetter { get; set; }
        public DateTime? PMedclRequestDate { get; set; }
        public DateTime? PActualApptDate { get; set; }
        public DateTime? PMedclFitnessCert { get; set; }
        public DateTime? PRecIssued { get; set; }
        public DateTime? PRecReceived { get; set; }
        public string PReRecAppt { get; set; }
        public string PRePreEmplmntMedclTest { get; set; }
    }
}