using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class LeaveLedgerBalancesOutput : DBProcMessageOutput
    {
        public string POpenCl { get; set; }
        public string POpenSl { get; set; }
        public string POpenPl { get; set; }
        public string POpenEx { get; set; }
        public string POpenCo { get; set; }
        public string POpenOh { get; set; }
        public string POpenLv { get; set; }
        public string PCloseCl { get; set; }
        public string PCloseSl { get; set; }
        public string PClosePl { get; set; }
        public string PCloseEx { get; set; }
        public string PCloseCo { get; set; }
        public string PCloseOh { get; set; }
        public string PCloseLv { get; set; }
    }





}
