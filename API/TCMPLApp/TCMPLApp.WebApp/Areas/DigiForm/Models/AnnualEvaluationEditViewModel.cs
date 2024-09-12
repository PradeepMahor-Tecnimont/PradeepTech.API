using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class AnnualEvaluationEditViewModel
    {
        public string KeyId { get; set; }

        [StringLength(5)]
        [Display(Name = "Emp No")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string EmployeeName { get; set; }

        [StringLength(20)]
        [Display(Name = "Designation")]
        public string Desgcode { get; set; }

        [Display(Name = "Designation Name")]
        public string DesgName { get; set; }

        [Display(Name = "Evaluation Period")]
        public string EvaluationPeriod { get; set; }

        [StringLength(4)]
        [Display(Name = "Department")]
        public string Parent { get; set; }

        [Display(Name = "Date Of Joining")]
        public DateTime? Doj { get; set; }

        [Required]
        [StringLength(200)]
        [Display(Name = "Attendance")]
        public string Attendance { get; set; }

        [StringLength(3)]
        [Display(Name = "Location")]
        public string Location { get; set; }

        [StringLength(800)]
        [Display(Name = "Training Received in the areas of:")]
        public string Training1 { get; set; }

        [StringLength(800)]
        [Display(Name = "Ability to grasp work procedure & technical aspects in dept.: ")]
        public string Training2 { get; set; }

        [StringLength(800)]
        [Display(Name = "Approach towards learning:")]
        public string Training3 { get; set; }

        [StringLength(800)]
        [Display(Name = "Skills Acquired:")]
        public string Training4 { get; set; }

        [StringLength(800)]
        [Display(Name = "Effectiveness of Training/On the Job Training :")]
        public string Training5 { get; set; }

        [StringLength(800)]
        public string Feedback1 { get; set; }
        
        [StringLength(800)]
        public string Feedback2 { get; set; }

        [StringLength(800)]
        public string Feedback3 { get; set; }
        
        [StringLength(800)]
        public string Feedback4 { get; set; }
        
        [StringLength(800)]
        public string Feedback5 { get; set; }
        
        [StringLength(800)]
        public string Feedback6 { get; set; }
        
        [StringLength(400)]
        [Display(Name = "Comments of HR")]

        public string CommentsOfHr { get; set; }
        public decimal? Isdeleted { get; set; }
    }
}
