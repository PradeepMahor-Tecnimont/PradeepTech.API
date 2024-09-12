using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class PlaceMaster
    {        
        [Display(Name = "Place")]
        public string Placeid { get; set; }

        [Display(Name = "Description")]
        public string Placedesc { get; set; }

        public int? Emps { get; set; }
    }
}
