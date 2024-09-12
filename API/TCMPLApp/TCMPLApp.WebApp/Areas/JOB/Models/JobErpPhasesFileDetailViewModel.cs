using Microsoft.AspNetCore.Http;
using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.JOB.View;

namespace TCMPLApp.WebApp.Models
{
    public class JobErpPhasesFileDetailViewModel
    {
        [Display(Name = "Job no")]
        public string JobNo { get; set; }

        [Display(Name = "Clint file name")]
        public string ClintFileName { get; set; }

        [Display(Name = "Server file name")]
        public string ServerFileName { get; set; }

        [Display(Name = " Modified by")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified on")]
        public string ModifiedOn { get; set; }

        public IFormFile file { get; set; }
    }
}