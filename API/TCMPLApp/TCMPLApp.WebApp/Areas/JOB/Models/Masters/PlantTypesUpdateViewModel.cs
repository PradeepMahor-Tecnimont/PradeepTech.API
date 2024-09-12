﻿using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class PlantTypesUpdateViewModel
    {
        [Required]
        public string Code { get; set; }

        [Required]
        [StringLength(20)]
        [Display(Name = "Plant Type ")]
        public string ShortDescription { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Plant Type description")]
        public string Description { get; set; }
    }
}