using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HSE
{
    public class HSEQuizCountDetailsOut : DBProcMessageOutput
    {
        public decimal? PEmpSubmitCount { get; set; }
        public decimal? PEmpCount { get; set; }
        public string PSubmitRating { get; set; }
    }
}
