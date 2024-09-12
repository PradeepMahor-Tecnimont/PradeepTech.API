

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DMS
{
    public class SetZoneDeskDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Desk Id")]
        public string DeskId { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified on")]
        public DateTime? ModifiedOn { get; set; }
    }
}

