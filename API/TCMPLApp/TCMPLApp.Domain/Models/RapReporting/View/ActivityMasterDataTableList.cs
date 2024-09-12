using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public partial class ActivityMasterDataTableList
    {
        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Display(Name = "Activity")]
        public string Activity { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "TLP code")]
        public string Tlpcode { get; set; }

        [Display(Name = "Activity type")]
        public string ActivityType { get; set; }

        [Display(Name = "Active")]
        public string Active { get; set; }
        public decimal? TotalRow { get; set; }
        public decimal RowNumber { get; set; }
    }
}
