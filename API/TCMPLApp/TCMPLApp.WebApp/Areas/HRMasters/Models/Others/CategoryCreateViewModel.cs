using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class CategoryCreateViewModel
    {
        [Required]
        [StringLength(1)]
        [Display(Name = "Category id")]
        public string Categoryid { get; set; }
        
        [StringLength(50)]
        [Display(Name = "Description")]
        public string Categorydesc{ get; set; }
        
    }
}
