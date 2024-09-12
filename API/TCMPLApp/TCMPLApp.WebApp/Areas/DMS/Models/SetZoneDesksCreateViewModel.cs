
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class SetZoneDesksCreateViewModel
    {
        [Required]
        [Display(Name = "Desk Id")]
        public string DeskId { get; set; }
    }
    public class ReturnDeskJsons
    {
        public List<ReturnDesks> ReturnDeskList { get; set; }
    }

    public class ReturnDesks
    {
        public string DeskId { get; set; }
    }
}
