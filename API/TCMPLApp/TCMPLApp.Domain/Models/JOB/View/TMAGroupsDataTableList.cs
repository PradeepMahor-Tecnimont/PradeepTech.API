using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.JOB
{
    public class TMAGroupsDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "TMA Group")]
        public string TmaGroup { get; set; }

        [Display(Name = "Sub Group")]
        public string SubGroup { get; set; }

        [Display(Name = "TMA Group Description")]
        public string TmaGroupDesc { get; set; }
        
        public decimal? DeleteAllowed { get; set; }

    }
}
