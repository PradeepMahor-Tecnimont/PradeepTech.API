using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.LC
{
    public class BankDetails : DBProcMessageOutput
    {
        public string PBankDesc { get; set; }
        public decimal PIsActive { get; set; }
    }
}