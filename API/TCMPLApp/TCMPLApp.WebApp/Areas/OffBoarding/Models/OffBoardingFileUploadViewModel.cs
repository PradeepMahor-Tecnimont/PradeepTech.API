using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class OffBoardingFileUploadViewModel
    {
        [Required]
        public string OfbEmpno { get; set; }

        [Required]
        public string UploadByEmpno { get; set; }

        [Required]
        public string UploadByGroup { get; set; }

        [AllowedExtensions(new string[] { ".pdf" })]
        [Display(Name = "Upload Files")]
        public List<IFormFile> Files { get; set; }

    }
}
