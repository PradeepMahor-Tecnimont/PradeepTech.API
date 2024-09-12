using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class ManhoursProjectionsCurrentJobsCreateModel
    {
        public string Projno { get; set; }
        public string Costcode { get; set; }
        public List<Prjcmast> addCurrproj { get; set; }
        public List<Prjcmast> editCurrproj { get; set; }
        public List<Prjcmast> deleteCurrproj { get; set; }
    }

    public class Prjcmast
    {
        public string Costcode { get; set; }

        public string Projno { get; set; }

        public string Yymm { get; set; }

        public decimal Hours { get; set; }
    }
}