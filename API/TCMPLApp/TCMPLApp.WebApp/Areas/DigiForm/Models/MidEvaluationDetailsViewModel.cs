using System.ComponentModel.DataAnnotations;
using System;

namespace TCMPLApp.WebApp.Models
{
    public class MidEvaluationDetailsViewModel
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

        [Display(Name = "Skill")]
        public string Skill1 { get; set; }

        [Display(Name = "Rating")]
        public decimal? Skill1RatingVal { get; set; }
        public string Skill1RatingText { get; set; }

        [Display(Name = "Remarks / Action plan")]
        public string Skill1Remark { get; set; }
        public string Skill2 { get; set; }
        public decimal? Skill2RatingVal { get; set; }
        public string Skill2RatingText { get; set; }
        public string Skill2Remark { get; set; }
        public string Skill3 { get; set; }
        public decimal? Skill3RatingVal { get; set; }
        public string Skill3RatingText { get; set; }
        public string Skill3Remark { get; set; }
        public string Skill4 { get; set; }
        public decimal? Skill4RatingVal { get; set; }
        public string Skill4RatingText { get; set; }
        public string Skill4Remark { get; set; }
        public string Skill5 { get; set; }
        public decimal? Skill5RatingVal { get; set; }
        public string Skill5RatingText { get; set; }
        public string Skill5Remark { get; set; }

        [Display(Name = "Rating")]
        public decimal? Que2RatingVal { get; set; }
        public string Que2RatingText { get; set; }

        [Display(Name = "Remarks / Action plan")]
        public string Que2Remark { get; set; }
        public decimal? Que3RatingVal { get; set; }
        public string Que3RatingText { get; set; }
        public string Que3Remark { get; set; }
        public decimal? Que4RatingVal { get; set; }
        public string Que4RatingText { get; set; }
        public string Que4Remark { get; set; }
        public decimal? Que5RatingVal { get; set; }
        public string Que5RatingText { get; set; }
        public string Que5Remark { get; set; }
        public decimal? Que6RatingVal { get; set; }
        public string Que6RatingText { get; set; }
        public string Que6Remark { get; set; }
        public string Observations { get; set; }
    }
}
