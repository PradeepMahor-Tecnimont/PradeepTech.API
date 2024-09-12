using Microsoft.AspNetCore.Http;
using System;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.WebApp.Areas.ERS
{
    public class HRCVActionUpdateViewModel
    {        
        [Required]
        public string JobKeyId { get; set; }

        [Required]
        [Display(Name = "Email")]
        public string CandidateEmail { get; set; }

        [Required]
        [Display(Name = "Status")]
        public string CvStatus { get; set; }

        [Display(Name = "Change job reference")]
        public string ChangeJobReference { get; set; }

        public HRCVDetailViewModel hRCVDetailViewModel { get; set; }
    }
}
