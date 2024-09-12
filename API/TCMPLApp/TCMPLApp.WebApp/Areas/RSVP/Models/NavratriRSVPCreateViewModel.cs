using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class NavratriRSVPCreateViewModel
    {
        //public string Empno { get; set; }
        public decimal? Attend { get; set; }

        public decimal? Bus { get; set; }

        public decimal? Dinner { get; set; }

        public string Counter { get; set; }
    }


}