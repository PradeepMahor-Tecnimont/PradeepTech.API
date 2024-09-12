using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAreaOfficeMapDetails : DBProcMessageOutput
    {
        public string PAreaText { get; set; }
        public string POfficeText { get; set; }
    }
}
