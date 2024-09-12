using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OscHoursCurCreateViewModel
    {
        [Required]        
        public string OscdId { get; set; }

        [Required]
        [Display(Name = "Year month")]
        public string Yyyymm { get; set; }        

        [Required]
        [Range(0, int.MaxValue, ErrorMessage = "Only positive number allowed")]
        [Display(Name = "Original est hours")]
        public decimal OrigEstHrs { get; set; }

        [Required]
        [Range(0, int.MaxValue, ErrorMessage = "Only positive number allowed")]
        [Display(Name = "Current est hours")]
        public decimal CurEstHrs { get; set; }
    }
}