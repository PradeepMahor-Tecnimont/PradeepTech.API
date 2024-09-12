using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OscHoursOrigCreateViewModel
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
    }
}