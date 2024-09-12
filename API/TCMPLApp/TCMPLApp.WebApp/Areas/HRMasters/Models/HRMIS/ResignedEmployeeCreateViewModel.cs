using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ResignedEmployeeCreateViewModel
    {
        [Required]
        [StringLength(5)]
        [Display(Name = "Employee No")]
        public string Empno { get; set; }

        [Required]
        [Display(Name = "Employee Resign Date")]
        public DateTime? EmpResignDate { get; set; }

        [Required]
        [Display(Name = "Hr Receipt Date")]
        public DateTime? HrReceiptDate { get; set; }

        [Required]
        [Display(Name = "Date Of Relieving")]
        public DateTime? DateOfRelieving { get; set; }

        [Required]
        [StringLength(200)]
        [Display(Name = "Employee Resign Reason")]
        public string EmpResignReason { get; set; }

        [Required]
        [StringLength(2)]
        [Display(Name = "Primary Reason")]
        public string PrimaryReason { get; set; }

        [StringLength(2)]
        [Display(Name = "Secondary Reason")]
        public string SecondaryReason { get; set; }

        [StringLength(400)]
        [Required]
        [Display(Name = "Additional Feedback")]
        public string AdditionalFeedback { get; set; }

        [StringLength(2)]
        [Display(Name = "Exit Interview Complete")]
        [Required]
        public string ExitInterviewComplete { get; set; }

        [Display(Name = "Increase Percentage")]
        public int? PercentIncrease { get; set; }

        [StringLength(100)]
        [Display(Name = "Moving to State / City")]
        public string MovingToLocation { get; set; }

        [Display(Name = "Current Location Of Employee")]
        public string CurrentLocation { get; set; }

        [Required]
        [StringLength(2)]
        [Display(Name = "Resign Status Code")]
        public string ResignStatusCode { get; set; }

        [StringLength(200)]
        [Display(Name = "Commitment On RollBack")]
        public string CommitmentOnRollback { get; set; }

        [Display(Name = "Last Date In Office")]
        public DateTime? ActualLastDateInOffice { get; set; }

        [Display(Name = "Date of joining")]
        public DateTime? Doj { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Designation")]
        public string Designation { get; set; }

        [Display(Name = "Department")]
        public string Department { get; set; }

        [StringLength(2)]
        [Display(Name = "Is Email Sent")]
        [Required]
        public string IsEmailSent { get; set; }
    }
}