using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LeaveOnDutyTab1ViewModel
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Application Id")]
        public string ApplicationId { get; set; }

        [Display(Name = "On duty type")]
        [Required]
        public string OndutyType { get; set; }

        [Display(Name = "From date")]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        [Required]
        public DateTime? StartDate { get; set; }

        [Display(Name = "Select Lead Engineer /1st Level Approver")]
        [Required]
        public string Approvers { get; set; }

        [Display(Name = "Late Come Time / Early Go Time")]
        [Required]
        public string FromHRS { get; set; }

        [MaxLength(60)]
        [Required]
        [Display(Name = "Reason")]
        public string Reason { get; set; }
    }

    public class LeaveOnDutyTab2ViewModel
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Application Id")]
        public string ApplicationId { get; set; }

        [Display(Name = "On duty type")]
        [Required]
        public string OndutyType { get; set; }

        [Display(Name = "From date")]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        [Required]
        public DateTime StartDate { get; set; }

        [Display(Name = "Select Lead Engineer /1st Level Approver")]
        [Required]
        public string Approvers { get; set; }

        [Display(Name = "Late Come Time / Early Go Time ")]
        [Required]
        public string FromHRS { get; set; }

        [Display(Name = "Late Come Time / Early Go Time ")]
        [Required]
        public string ToHRS { get; set; }

        [Display(Name = "Reason/Description of leave")]
        [MaxLength(60)]
        [Required]
        public string Reason { get; set; }
    }

    public class LeaveOnDutyTab3ViewModel
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Application Id")]
        public string ApplicationId { get; set; }

        [Display(Name = "From date")]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        [Required]
        public DateTime StartDate { get; set; }

        [Display(Name = "On duty type")]
        [Required]
        public string OndutyType { get; set; }

        [Display(Name = "On duty sub-type")]
        [Required]
        public string OndutySubType { get; set; }

        [Display(Name = "Select Lead Engineer /1st Level Approver")]
        [Required]
        public string Approvers { get; set; }

        [Display(Name = "Late Come Time / Early Go Time ")]
        [Required]
        public string FromHRS { get; set; }

        [Display(Name = "Late Come Time / Early Go Time ")]
        [Required]
        public string ToHRS { get; set; }

        [Display(Name = "Reason/Description of leave")]
        [MaxLength(60)]
        [Required]
        public string Reason { get; set; }
    }

    public class LeaveOnDutyTab4ViewModel
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Application Id")]
        public string ApplicationId { get; set; }

        [Display(Name = "On duty type")]
        [Required]
        public string OndutyType { get; set; }

        [Display(Name = "From date")]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        [Required]
        public DateTime StartDate { get; set; }

        [Display(Name = "To date")]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        [Required]
        public DateTime EndDate { get; set; }

        [Display(Name = "Select Lead Engineer /1st Level Approver")]
        [Required]
        public string Approvers { get; set; }

        [Display(Name = "Reason/Description of leave")]
        [MaxLength(60)]
        [Required]
        public string Reason { get; set; }
    }

    public class LeaveOnDutyTab5ViewModel
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Application Id")]
        public string ApplicationId { get; set; }

        [Display(Name = "On duty type")]
        [Required]
        public string OndutyType { get; set; }

        [Display(Name = "From date")]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        [Required]
        public DateTime StartDate { get; set; }

        [Display(Name = "Reason/Description of leave")]
        [MaxLength(60)]
        [Required]
        public string Reason { get; set; }
    }

    public class LeaveOnDutyTab6ViewModel
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Application Id")]
        public string ApplicationId { get; set; }

        [Display(Name = "On duty type")]
        [Required]
        public string OndutyType { get; set; }

        [Display(Name = "From date")]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        [Required]
        public DateTime StartDate { get; set; }

        [Display(Name = "Reason/Description of leave")]
        [MaxLength(60)]
        [Required]
        public string Reason { get; set; }
    }
}