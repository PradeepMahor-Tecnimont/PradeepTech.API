using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ProcessDetailsViewModel
    {
        [Display(Name = "KeyId")]
        public string KeyId { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee Name")]
        public string EmpName { get; set; }

        [Display(Name = "Module id")]
        public string ModuleId { get; set; }

        [Display(Name = "Module description")]
        public string ModuleDesc { get; set; }

        [Display(Name = "Process id")]
        public string ProcessId { get; set; }

        [Display(Name = "Process description")]
        public string ProcessDesc { get; set; }

        [Display(Name = "Parameter json")]
        public string ParameterJson { get; set; }

        [Display(Name = "Process start date")]
        public string ProcessStartDate { get; set; }

        [Display(Name = "Process finish date")]
        public string ProcessFinishDate { get; set; }

        [Display(Name = "Created on")]
        public string CreatedOn { get; set; }

        [Display(Name = "Status")]
        public string Status { get; set; }

        [Display(Name = "Mail to")]
        public string MailTo { get; set; }

        [Display(Name = "Mail cc")]
        public string MailCc { get; set; }
    }
}