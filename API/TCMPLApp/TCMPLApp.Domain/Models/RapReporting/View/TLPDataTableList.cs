using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class TLPDataTableList
    {
        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Display(Name = "TLP Code")]
        public string Tlpcode { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }
        public decimal? TotalRow { get; set; }
        public decimal RowNumber { get; set; }
    }
}
