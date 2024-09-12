using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class OfficeDetails : DBProcMessageOutput
    {
        public string POfficeName { get; set; }
        public string POfficeDesc { get; set; }
        public string POfficeLocationVal { get; set; }
        public string POfficeLocationTxt { get; set; }
        public string PSmartDeskBookingEnabledVal { get; set; }
        public string PSmartDeskBookingEnabledTxt { get; set; }
    }
}
