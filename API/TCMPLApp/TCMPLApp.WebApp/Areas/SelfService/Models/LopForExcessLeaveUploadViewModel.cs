using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace TCMPLApp.WebApp.Models
{
    public class LopForExcessLeaveUploadViewModel
    {
        [Required]
        [Display(Name = "Lop Type")]
        public string LopType { get; set; }

        [Required]
        [Display(Name = "Salary Month")]
        public DateTime? PayslipYyyymm { get; set; }

        public string PaySlipMonth {  get; set; }
        public IFormFile file { get; set; }
    }
}
