using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class UpdateNumberOfEmployeeViewModel
    {
        [Required]
        [Display(Name = "CostCode")]
        public string Costcode { get; set; }

        [Required]
        [Display(Name = "Present number of employee")]
        public int? Noofemps { get; set; }

        [Required]
        [Display(Name = "Change to")]
        public long? Changednemps { get; set; }
    }

    public class NumberOfEmployeeObj
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public NoOfEmpData Data { get; set; }
    }

    public class NoOfEmpData
    {
        public List<NoOfEmpVal> Value { set; get; }
    }

    public class NoOfEmpVal
    {
        public string Costcode { set; get; }
        public int? Noofemps { set; get; }
        public long? Changednemps { set; get; }
    }
}