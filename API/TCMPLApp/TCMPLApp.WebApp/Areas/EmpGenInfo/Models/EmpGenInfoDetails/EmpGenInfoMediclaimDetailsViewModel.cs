using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.WebApp.Models
{
    public class EmpGenInfoMediclaimDetailsViewModel
    {
        public GetLockStatusDetailViewModel LockStatusDetailViewModel { get; set; }
        public GetDescripancyDetailViewModel DescripancyDetailViewModel { get; set; }

        [Display(Name = "Employee no")]
        public string Empno { get; set; }
    }
}