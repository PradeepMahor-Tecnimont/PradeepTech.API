using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models
{

    public class AppModuleUserDetailsModel
    {
        public string CommandText { get => "APP_USERS.GET_EMP_DETAILS_FROM_WIN_UID"; }
        public string PWinUid { get; set; }
        public string OutPEmpno { get; set; }
        public string OutPEmpName { get; set; }
        public string OutPCostcode { get; set; }
        public string OutPMetaId{ get; set; }
        public string OutPPersonId{ get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }

    }
}

