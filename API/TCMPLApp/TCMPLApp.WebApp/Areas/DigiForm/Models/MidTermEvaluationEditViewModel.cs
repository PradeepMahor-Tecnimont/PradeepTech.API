using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;
using Microsoft.CodeAnalysis.FlowAnalysis;
using System.Diagnostics.CodeAnalysis;

namespace TCMPLApp.WebApp.Models
{
    public class MidTermEvaluationEditViewModel
    {
        public string KeyId { get; set; }

        [StringLength(5)]
        [Display(Name = "Emp No")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string EmployeeName { get; set; }

        [StringLength(6)]
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

        [StringLength(3)]
        [Display(Name = "Attendance(%)")]
        [Range(1, 100, ErrorMessage = "Value must be between 1 to 100")]
        public string Attendance { get; set; }

        [StringLength(3)]
        [Display(Name = "Location")]
        public string Location { get; set; }

        [StringLength(200)]
        [Display(Name = "Skills")]
        public string Skill1 { get; set; }

        [Display(Name = "Rating")]
        public decimal? Skill1Rating { get; set; }

        [StringLength(200)]
        [Display(Name = "Remarks / Action plan")]
        public string Skill1Remark { get; set; }

        [StringLength(200)]
        [RequiredIf("Skill2Rating", "Skill is required")]
        public string Skill2 { get; set; }

        [RequiredIf("Skill2", "Skill Rating is required")]
        public decimal? Skill2Rating { get; set; }

        [StringLength(200)]
        //[RequiredIf("Skill2Rating", "Skill Remark is required")]
        public string Skill2Remark { get; set; }

        [StringLength(200)]
        [RequiredIf("Skill3Rating", "Skill is required")]
        public string Skill3 { get; set; }

        [RequiredIf("Skill3", "Skill Rating is required")]
        public decimal? Skill3Rating { get; set; }

        [StringLength(200)]
        //[RequiredIf("Skill3Rating", "Skill Remark is required")]
        public string Skill3Remark { get; set; }

        [StringLength(200)]
        [RequiredIf("Skill4Rating", "Skill is required")]
        public string Skill4 { get; set; }

        [RequiredIf("Skill4", "Skill Rating is required")]
        public decimal? Skill4Rating { get; set; }

        [StringLength(200)]
        //[RequiredIf("Skill4Rating", "Skill Remark is required")]
        public string Skill4Remark { get; set; }

        [StringLength(200)]
        [RequiredIf("Skill5Rating", "Skill is required")]
        public string Skill5 { get; set; }

        [RequiredIf("Skill5", "Skill Rating is required")]
        public decimal? Skill5Rating { get; set; }

        [StringLength(200)]
        //[RequiredIf("Skill5Rating", "Skill Remark is required")]
        public string Skill5Remark { get; set; }

        [Display(Name = "Rating")]
        public decimal? Que2Rating { get; set; }

        [Display(Name = "Remarks / Action plan")]
        [StringLength(200)]
        public string Que2Remark { get; set; }

        public decimal? Que3Rating { get; set; }

        [StringLength(200)]
        public string Que3Remark { get; set; }

        public decimal? Que4Rating { get; set; }

        [StringLength(200)]
        public string Que4Remark { get; set; }

        public decimal? Que5Rating { get; set; }

        [StringLength(200)]
        public string Que5Remark { get; set; }

        public decimal? Que6Rating { get; set; }

        [StringLength(200)]
        public string Que6Remark { get; set; }

        [Required]
        [StringLength(400)]
        public string Observations { get; set; }
        public decimal? Isdeleted { get; set; }


    }
}
