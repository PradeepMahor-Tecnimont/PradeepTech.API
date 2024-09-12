using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{

    public class SWPCheckDetails
    {
        public string CommandText { get => SWPVaccineProcedures.CheckSWPDetails; }

        public string ParamWinUid { get; set; }

        public string OutParamSwpExists { get; set; }

        public string OutParamUserCanDoSwp { get; set; }

        public string OutParamIsIphoneUser { get; set; }

        public string OutParamSuccess { get; set; }

        public string OutParamMessage { get; set; }

    }
    
}
