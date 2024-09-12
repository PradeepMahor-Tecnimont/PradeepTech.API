using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class AppMailProcessStatusLogDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Process Status")]
        public string ProcessStatus { get; set; }
        public string ProcessMailText { get; set; }
        
        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }
        public string EmpName { get; set; }
        
        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }
    }
}
