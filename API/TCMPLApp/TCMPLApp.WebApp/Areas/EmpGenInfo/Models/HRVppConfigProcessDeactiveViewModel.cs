using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class HRVppConfigProcessDeactiveViewModel
    {
        public string keyid { get; set; }

        [Display(Name = "End date")]
        public DateTime? EndDate { get; set; }
    }
}
