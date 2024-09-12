using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmpPensionFundViewModel
    {
        public GetLockStatusDetailViewModel LockStatusDetailViewModel { get; set; }
        [Display(Name = "Employee no")]
        public string Empno { get; set; }
    }
}