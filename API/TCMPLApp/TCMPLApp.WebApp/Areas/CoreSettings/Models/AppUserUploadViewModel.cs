using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class AppUserUploadViewModel
    {
        [Required]
        [Display(Name = "Employee No")]
        public string Employee { get; set; }
    }
    public class ReturnEmpJsons
    {
        public List<ReturnEmp> ReturnEmpList { get; set; }
    }

    public class ReturnEmp
    {
        public string Empno { get; set; }
    }
}
