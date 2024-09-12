using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class OffBoardingExitsApproveViewModel
    {

        [Display(Name = "Empno")]
        [Required]
        public string Empno { get; set; }

        [Display(Name = "Remarks")]
        [MaxLength(200)]
        [Required]
        public string Remarks { get; set; }

        [Required]
        public string ApprovalType { get; set; }

        [AllowedExtensions(new string[] { ".pdf" })]
        [Display(Name = "Upload Files")]
        public List<IFormFile> Files { get; set; }

    }
}
