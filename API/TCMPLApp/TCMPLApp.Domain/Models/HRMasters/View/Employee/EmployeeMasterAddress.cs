using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterAddress
    {        
        [Display(Name = "Employee no")]
        public string Empno { get; set; }
        public string Name { get; set; }

        [Display(Name = "Address 1")]
        public string Add1 { get; set; }
        
        [Display(Name = "Address  2")]
        public string Add2 { get; set; }
        
        [Display(Name = "Address 3")]
        public string Add3 { get; set; }
        
        [Display(Name = "Address 4")]
        public string Add4 { get; set; }   

        [Display(Name = "Pin Code")]
        public Int32? Pincode { get; set; }

        public Int32? Status { get; set; }
        public string IsEditable { get; set; }
    }
}
