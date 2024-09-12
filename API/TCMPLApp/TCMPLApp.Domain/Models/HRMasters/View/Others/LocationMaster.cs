using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class LocationMaster
    {
        [Required]
        [Display(Name = "Location")]
        public string Locationid { get; set; }

        [Display(Name = "Description")]
        public string Location { get; set; }

        public int? Emps { get; set; }
    }
}
