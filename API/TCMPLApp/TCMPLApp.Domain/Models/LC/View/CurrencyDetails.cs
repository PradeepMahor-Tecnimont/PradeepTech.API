using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.LC
{
    public class CurrencyDetails : DBProcMessageOutput
    {
        public string PCurrencyCode { get; set; }
        public string PCurrencyDesc { get; set; }
        public decimal PIsActive { get; set; }
    }
}