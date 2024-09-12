using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace TCMPLApp.WebApp.Models
{
    public class LeaveClaimCreateViewModel
    {

        [Display(Name = "Empno")]
        [Required]
        public string Empno { get; set; }


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

        [Display(Name = "Description")]
        [Required]
        [MaxLength(60)]
        public string Description { get; set; }

        public IFormFile file { get; set; }


    }
}
