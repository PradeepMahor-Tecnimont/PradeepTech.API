using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeDeleteCreate : DBProcMessageOutput
    {
        [MaxLength(5)]
        [Display(Name = "Employee")]
        public string Empno { get; set; }
        
    }
}
