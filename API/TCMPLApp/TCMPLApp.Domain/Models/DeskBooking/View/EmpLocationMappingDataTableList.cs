using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class EmpLocationMappingDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Key Id")]
        public string KeyId { get; set; }

        [Display(Name = "Employee")]
        public string Empno { get; set; }

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

        [Display(Name = "Office Location Code")]
        public string OfficeLocationCode { get; set; }

        [Display(Name = "Office Location Code Desc")]
        public string OfficeLocationCodeDesc { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }
    }
}
