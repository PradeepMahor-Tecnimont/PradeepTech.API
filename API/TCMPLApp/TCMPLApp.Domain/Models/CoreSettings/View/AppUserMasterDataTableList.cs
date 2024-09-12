using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class AppUserMasterDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Employee")]
        public string Empno { get; set; }
        public string Name { get; set; }

        [Display(Name = "Status")]
        public string Status { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }
        
        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }
        public string CheckboxFlag { get; set; }
    }
}
