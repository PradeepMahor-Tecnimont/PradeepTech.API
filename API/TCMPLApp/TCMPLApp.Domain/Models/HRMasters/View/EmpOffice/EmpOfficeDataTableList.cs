using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmpOfficeLocationHistoryDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string KeyId { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }
        
        [Display(Name = "Start date")]
        public DateTime StartDate { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified on date")]
        public DateTime ModifiedOn{ get; set; }

        [Display(Name = "Office Location")]
        public string EmpOfficeLocation { get; set; }
    }
}
