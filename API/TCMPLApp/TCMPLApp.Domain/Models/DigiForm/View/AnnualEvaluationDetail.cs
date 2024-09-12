using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DigiForm
{
    public class AnnualEvaluationDetail : DBProcMessageOutput
    {
        public string PEmpno { get; set; }
        public string PDesgcode { get; set; }
        public string PParent { get; set; }
        public string PAttendance { get; set; }
        public string PLocation { get; set; }
        public string PTraining1 { get; set; }
        public string PTraining2 { get; set; }
        public string PTraining3 { get; set; }
        public string PTraining4 { get; set; }
        public string PTraining5 { get; set; }
        public string PFeedback1 { get; set; }
        public string PFeedback2 { get; set; }
        public string PFeedback3 { get; set; }
        public string PFeedback4 { get; set; }
        public string PFeedback5 { get; set; }
        public string PFeedback6 { get; set; }
        public string PCommentsOfHr { get; set; }
        public string PCreatedBy { get; set; }
        public string PCreatedOn { get; set; }
        public string PModifiedBy { get; set; }
        public string PModifiedOn { get; set; }
        public string PIsdeleted { get; set; }
        public string PHodApproval { get; set; }
        public string PHodApprovalDate { get; set; }
        public string PHrApproval { get; set; }
        public string PHrApprovalDate { get; set; }
        public string PHrApproveBy { get; set; }

    }
}
