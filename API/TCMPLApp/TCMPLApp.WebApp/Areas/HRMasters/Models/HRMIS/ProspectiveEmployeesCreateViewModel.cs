using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ProspectiveEmployeesCreateViewModel
    {
        [Required]
        [Display(Name = "Department")]
        public string Costcode { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Prospective employee")]
        public string EmpName { get; set; }

        [Required]
        [Display(Name = "Joining Office")]
        public string OfficeLocationCode { get; set; }

        [Required]
        [Display(Name = "Proposed DOJ")]
        public DateTime? ProposedDoj { get; set; }

        [Display(Name = "Revised DOJ")]
        public DateTime? RevisedDoj { get; set; }

        [Required]
        [Display(Name = "Status")]
        public string JoinStatusCode { get; set; }

        [Display(Name = "Joined as")]
        public string Empno { get; set; }

        [Required]
        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Required]
        [Display(Name = "Designation")]
        public string Designation { get; set; }

        [Required]
        [Display(Name = "Employment Type")]
        public string EmploymentType { get; set; }

        [Required]
        [Display(Name = "Sources of Candidate")]
        public string SourcesOfCandidate { get; set; }
    }
}