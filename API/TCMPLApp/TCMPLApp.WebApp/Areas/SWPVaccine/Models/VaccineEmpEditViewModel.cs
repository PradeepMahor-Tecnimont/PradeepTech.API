using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class VaccineEmpCreateViewModel
    {
        [Required]
        [Display(Name = "Employee")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string Name { get; set; }

        [Required]
        [Display(Name = "Vaccine Type")]
        public string VaccineType { get; set; }


        [Display(Name = "First Jab Date")]
        [Required]
        //[DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        [DateLessThanToday("First jab date should be a past date")]
        public DateTime FirstJab { get; set; }

        [Display(Name = "Second Jab Date")]
        //[DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        [DateLessThanToday("Second jab date should be a past date")]
        [DateGreaterThan("FirstJab","Second jab date should be greater than First jab date")]
        public DateTime? SecondJab { get; set; }

        [Display(Name = "Booster Jab Date")]
        //[DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        [DateLessThanToday("Booster jab date should be a past date")]
        [DateGreaterThan("SecondJab", "Booster jab date should be greater than First jab date")]
        public DateTime? BoosterJab { get; set; }


        [Display(Name = "First jab sponsor")]
        public string FirstJabSponsorOffice { get; set; }

        [Display(Name = "Second jab sponsor")]
        public string SecondJabSponsorOffice { get; set; }

        public string CanEdit { get; set; }
    }
}
