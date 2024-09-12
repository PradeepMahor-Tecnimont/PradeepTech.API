using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeJoinedMonth
    {
       
        [Display(Name = "Month")]
        public string Month { get; set; }
                
        [Display(Name = "Count")]
        public int? Cnt { get; set; }              
        
    }
}
