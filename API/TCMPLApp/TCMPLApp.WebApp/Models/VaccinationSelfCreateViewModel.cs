using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class VaccinationSelfCreateViewModel1
    {
        [Required]
        [Display(Name = "Vaccine Type")]
        public string VaccineType { get; set; }

        [Display(Name = "First Jab Date")]
        [Required]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        [ValidateVaccineDatesFirstJab]
        public DateTime? FirstJab { get; set; }

        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        [Display(Name = "Second Jab Date")]
        [ValidateVaccineDatesSecondJab]
        public DateTime? SecondJab { get; set; }

        public bool? IsSecondJabNull { get; set; }

    }
}
