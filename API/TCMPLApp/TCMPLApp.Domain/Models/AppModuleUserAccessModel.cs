using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models
{
    public class AppModuleUserAccessModel
    {
        public string CommandText { get => "APP_MODULE.GET_USER_ACCESS"; }
        public string PWinUid { get; set; }

        public string OutPModulesCsv { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }

    }
}
