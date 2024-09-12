using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class LeavePLReviseViewModel
    {

        [Display(Name = "Application Id")]
        [Required]
        public string ApplicationId { get; set; }


        [Display(Name = "Leave type")]
        public string LeaveType { get; set; }



        [Display(Name = "Approver")]
        [Required]
        public string RevisedAppover { get; set; }


        [Display(Name = "Leave period")]
        public decimal? RevisedLeavePeriod { get; set; }

        [Display(Name = "Half day")]
        [Required]
        public Int32 RevisedHalfDayDay { get; set; }


        [Display(Name = "Leave start date")]
        [Required]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? RevisedStartDate { get; set; }


        [Display(Name = "Leave end date")]
        [Required]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? RevisedEndDate { get; set; }


    }
}
