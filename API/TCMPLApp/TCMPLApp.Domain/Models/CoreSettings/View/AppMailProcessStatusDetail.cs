using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class AppMailProcessStatusDetail : DBProcMessageOutput
    {
        public string PProcessMail { get; set; }
        public string PProcessMailText { get; set; }
    }
}
