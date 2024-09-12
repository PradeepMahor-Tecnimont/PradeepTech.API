using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ExcludeCreateViewModel
    {
        [Required]
        [Display(Name = "Employee No")]
        public string Employee { get; set; }
    }

    public class ReturnJsons
    {
        public List<ReturnEmployee> ReturnEmpList { get; set; }
    }

    public class ReturnEmployee
    {
        public string Empno { get; set; }
    }
}