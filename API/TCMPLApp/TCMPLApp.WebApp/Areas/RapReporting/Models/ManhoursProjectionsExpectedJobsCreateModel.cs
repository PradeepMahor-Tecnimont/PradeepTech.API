using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class ManhoursProjectionsExpectedJobsCreateModel
    {
        public string Projno { get; set; }
        public string Costcode { get; set; }
        public List<Exptprjc> addExproj { get; set; }
        public List<Exptprjc> editExproj { get; set; }
        public List<Exptprjc> deleteExproj { get; set; }
    }

    public class Exptprjc
    {
        public string Costcode { get; set; }

        public string Projno { get; set; }

        public string Yymm { get; set; }

        public decimal Hours { get; set; }
    }
}