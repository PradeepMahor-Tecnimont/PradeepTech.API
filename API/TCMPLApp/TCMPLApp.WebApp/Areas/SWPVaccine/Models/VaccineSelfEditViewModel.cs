using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class VaccineSelfEditViewModel
    {
        [Required]
        [Display(Name = "Vaccine Type")]
        public string VaccineType { get; set; }


        [Display(Name = "First Jab Date")]
        [Required]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime FirstJab { get; set; }

        public DateTime? DummySecondJabDate { get; set; }

        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        [Display(Name = "Second Jab Date")]
        [DateLessThanToday("Second jab date should be a past date")]
        [DateGreaterThan("FirstJab", "Second jab date should be greater than First jab date")]
        public DateTime? SecondJab { get; set; }

        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        [Display(Name = "Booster Jab Date")]
        [DateLessThanToday("Booster jab date should be a past date")]
        [DateGreaterThan("SecondJab", "Booster jab date should be greater than Second jab date")]
        [RequiredIf("DummySecondJabDate", "Booster jab date is required")]
        public DateTime? BoosterJab { get; set; }

        public bool IsSecondJabNull { get; set; }
    }
}
