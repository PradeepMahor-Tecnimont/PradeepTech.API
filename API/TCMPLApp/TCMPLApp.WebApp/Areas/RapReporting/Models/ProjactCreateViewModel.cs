using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ProjactCreateViewModel
    {
        [Required]
        [Display(Name = "Projno")]
        public string Projno { get; set; }
        
        [Required]
        [Display(Name = "Costcode")]
        public string Costcode { get; set; }
        
        [Required]
        [Display(Name = "Activity code")]
        public string Activity { get; set; }
        
        [Required]
        [Range(0, int.MaxValue, ErrorMessage = "Only positive number allowed")]
        [Display(Name = "Budget hours")]
        public string Budghrs { get; set; }
        
        [Required]
        [Range(0, int.MaxValue, ErrorMessage = "Only positive number allowed")]
        [Display(Name = "No of docs")]
        public string NoOfDocs { get; set; }
    }
}
