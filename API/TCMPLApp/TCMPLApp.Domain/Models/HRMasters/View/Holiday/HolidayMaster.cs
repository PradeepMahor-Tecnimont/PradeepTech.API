using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class HolidayMaster
    {
        public int Srno { get; set; }

        [Required]
        [Display(Name = "Holiday date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime Holiday { get; set; }

        [Display(Name = "YYYYMM")]
        public string YYYYMM { get; set; }

        [Display(Name = "Weekday")]
        public string Weekday{ get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }
    }
}
