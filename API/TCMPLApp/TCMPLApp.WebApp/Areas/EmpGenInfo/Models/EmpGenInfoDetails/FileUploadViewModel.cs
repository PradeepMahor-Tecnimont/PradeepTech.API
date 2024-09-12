using Microsoft.AspNetCore.Http;

using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class FileUploadViewModel
    {
        public string Empno { get; set; }
        public string EmpName { get; set; }

        [Required]
        public string FileType { get; set; }

        [Display(Name = "File name")]
        public string FileName { get; set; }

        public string RefNumber { get; set; }

        [Required]
        public IFormFile file { get; set; }
    }
}