using System.ComponentModel.DataAnnotations;
using System;

namespace TCMPLApp.WebApp.Models
{
    public class AnnualEvaluationDetailsViewModel
    {
        public string KeyId { get; set; }

        [Display(Name = "Emp No")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Designation")]
        public string DesgCode { get; set; }

        [Display(Name = "Designation Name")]
        public string DesgName { get; set; }

        [Display(Name = "Department")]
        public string CostName { get; set; }

        [Display(Name = "Date Of Joining")]
        public DateTime? Doj { get; set; }

        [Display(Name = "Attendance")]
        public string Attendance { get; set; }

        [Display(Name = "Evaluation Period")]
        public string EvaluationPeriod { get; set; }

        [Display(Name = "Location")]
        public string Location { get; set; }

        [Display(Name = "Training Received in the areas of:")]
        public string Training1 { get; set; }

        [Display(Name = "Ability to grasp work procedure & technical aspects in dept.: ")]
        public string Training2 { get; set; }

        [Display(Name = "Approach towards learning:")]
        public string Training3 { get; set; }

        [Display(Name = "Skills Acquired:")]
        public string Training4 { get; set; }

        [Display(Name = "Effectiveness of Training/On the Job Training :")]
        public string Training5 { get; set; }

        public string Feedback1 { get; set; }
        public string Feedback2 { get; set; }
        public string Feedback3 { get; set; }
        public string Feedback4 { get; set; }
        public string Feedback5 { get; set; }
        public string Feedback6 { get; set; }

        [Display(Name = "Comments of HR")]
        public string CommentOfHr { get; set; }

        public string HodApproval { get; set; }
        public string HrApproval { get; set; }
        public string HrApprovalDate { get; set; }
        public string HrApproveBy { get; set; }
    }
}
