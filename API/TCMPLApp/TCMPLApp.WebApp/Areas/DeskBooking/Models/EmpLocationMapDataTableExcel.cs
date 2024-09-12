using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmpLocationMapDataTableExcel
    {
        [Display(Name = "Employee no")]
        public string EmpNo { get; set; }

        [Display(Name = "Employee Name")]
        public string Name { get; set; }

        [Display(Name = "Employee Type")]
        public string Emptype { get; set; }

        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Display(Name = "Costcode")]
        public string CostcodeName { get; set; }

        [Display(Name = "Base Office Location")]
        public string BaseLocation { get; set; }

        [Display(Name = "Office Location Code Desc")]
        public string OfficeLocationCodeDesc { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }
    }
}
