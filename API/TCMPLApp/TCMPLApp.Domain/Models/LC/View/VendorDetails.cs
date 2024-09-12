using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.LC
{
    public class VendorDetails : DBProcMessageOutput
    {
        public string PVendorName { get; set; }

        public decimal PIsActive { get; set; }
    }
}