using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;
using System;
using System.ComponentModel;

namespace TCMPLApp.WebApp.Models
{
    public class ResignedEmployeeUpdateViewModel
    {
        [Required]
        [StringLength(8)]
        public string KeyId { get; set; }

        [Required]
        [StringLength(5)]
        [Display(Name = "Employee No")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string EmployeeName { get; set; }

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

        public string PrimaryReasonDesc { get; set; }

        [StringLength(2)]
        [Display(Name = "Secondary Reason")]
        public string SecondaryReason { get; set; }

        public string SecondaryReasonDesc { get; set; }

        [StringLength(400)]
        [Display(Name = "Additional Feedback")]
        [Required]
        public string AdditionalFeedback { get; set; }

        [StringLength(2)]
        [Display(Name = "Exit Interview Complete")]
        [Required]
        public string ExitInterviewComplete { get; set; }

        [Display(Name = "Increase Percentage")]
        public decimal? PercentIncrease { get; set; }

        [StringLength(100)]
        [Display(Name = "Moving to State / City")]
        public string MovingToLocation { get; set; }

        [Display(Name = "Current Location")]
        public string CurrentLocation { get; set; }

        public string CurrentLocationDesc { get; set; }

        [Required]
        [StringLength(2)]
        [Display(Name = "Resign Status Code")]
        public string ResignStatusCode { get; set; }

        public string ResignStatusDesc { get; set; }

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