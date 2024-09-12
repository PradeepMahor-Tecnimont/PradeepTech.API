using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class VaccineSelfEditViewModel1
    {
        [Required]
        [Display(Name = "Vaccine Type")]
        public string VaccineType { get; set; }


        [Display(Name = "First Jab Date")]
        [Required]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime FirstJab { get; set; }

        [Display(Name = "Second Jab Date")]
        [Required]
        [ValidateVaccineDatesEdit]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? SecondJab { get; set; }

    }
}
