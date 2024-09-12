using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class ProjactMasterDataTableList
    {
        public string Projno { get; set; }
        public string Costcode { get; set; }
        public string Activity { get; set; }
        public decimal Budghrs { get; set; }
        public decimal Noofdocs { get; set; }
        public decimal? TotalRow { get; set; }
        public decimal RowNumber { get; set; }
    }
}
