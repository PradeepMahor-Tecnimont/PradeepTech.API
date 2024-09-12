using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.WebApp.Models
{
    public class LeaveCreateViewModel
    {

        [Display(Name = "Office location")]
        [MaxLength(30)]
        [Required]
        public string OfficeLocation { get; set; }


        [Display(Name = "Working on")]
        [MaxLength(30)]
        [Required]
        public string Project { get; set; }

        [Display(Name = "Work caretaker in your absence")]
        [MaxLength(30)]
        [Required]
        public string CareTaker { get; set; }

        [Display(Name = "Approver")]
        [Required]
        public string Appover { get; set; }

        [Display(Name = "Leave period")]
        [Required]
        [RegularExpression(@"^(([0-9]*)?(\.[05])?)$", ErrorMessage = "Leave period should in multiples of '0.5'")]
        public decimal? LeavePeriod { get; set; }

        [Display(Name = "Half day")]
        [Required]
        public Int32 HalfDayDay { get; set; }

        [Display(Name = "Leave type")]
        [Required]
        public string LeaveType { get; set; }

        [Display(Name = "Leave start date")]
        [Required]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? StartDate { get; set; }

        [Display(Name = "Leave end date")]
        [Required]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? EndDate { get; set; }


        [Display(Name = "Reason of leave")]
        [Required]
        [MaxLength(60)]
        public string Reason { get; set; }

        [Display(Name = "Phone number")]
        public string PhoneNumber { get; set; }

        [Display(Name = "Std. number")]
        public string StdNumber { get; set; }

        [Display(Name = "Medical certificate available")]
        public bool MedicalCertificate { get; set; }

        [Display(Name = "Address")]
        [MaxLength(60)]
        public string Address { get; set; }
    }
}
