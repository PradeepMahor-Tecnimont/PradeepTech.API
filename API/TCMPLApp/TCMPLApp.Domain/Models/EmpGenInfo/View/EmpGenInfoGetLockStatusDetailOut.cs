using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class EmpGenInfoGetLockStatusDetailOut : DBProcMessageOutput
    {
        public string PIsPrimaryOpen { get; set; }
        public string PIsNominationOpen { get; set; }
        public string PIsMediclaimOpen { get; set; }
        public string PIsAadhaarOpen { get; set; }
        public string PIsPassportOpen { get; set; }
        public string PIsGtliOpen { get; set; }
        public string PIsSecondaryOpen { get; set; }
    }
}