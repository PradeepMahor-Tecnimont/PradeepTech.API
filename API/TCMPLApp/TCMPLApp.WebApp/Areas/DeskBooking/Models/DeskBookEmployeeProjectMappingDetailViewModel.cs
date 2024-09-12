using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskBookEmployeeProjectMappingDetailViewModel
    {
        public string KeyId { get; set; }

        [Display(Name = "Employee no.")]
        public string EmpNo { get; set; }

        [Display(Name = "Employee name")]
        public string EmpName { get; set; }

        [Display(Name = "Project no.")]
        public string Projno { get; set; }

        [Display(Name = "Project name")]
        public string Projname { get; set; }
    }
}