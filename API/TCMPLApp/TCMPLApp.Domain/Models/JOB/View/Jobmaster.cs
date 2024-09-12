using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.JOB
{
    public class Jobmaster
    {
        [Display(Name = "Project No")]
        public string Projno { get; set; }

        [Display(Name = "Client name")]
        public string Clientname { get; set; }

        [Display(Name = "Location")]
        public string Location { get; set; }
    }
}
