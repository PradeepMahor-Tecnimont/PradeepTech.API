using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmploymentOfRelativesAddViewModel
    {


        [Display(Name = "Colleague Name")]
        public string ColleagueName { get; set; }

        [Display(Name = "Colleague Relation")]
        public string ColleagueRelation { get; set; }

        [Display(Name = "Colleague Name")]
        public string RelativeName { get; set; }

        [Display(Name = "Colleague Relation")]
        public string RelativeRelation { get; set; }

        [Display(Name = "Colleague Department")]
        public string ColleagueDept { get; set; }

        [Display(Name = "Colleague Location")]
        public string ColleagueLocation { get; set; }

        [Display(Name = "Colleague Empno")]
        public string ColleagueEmpno { get; set; }
    }
}
