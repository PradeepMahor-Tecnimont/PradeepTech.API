using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models
{
    public class DmsUserCheck
    {
        public string CommandText { get => "dms.dmsv2.get_is_dms_user"; }
        public string PEmpno{ get; set; }
        public string OutReturnValue { get; set; }
    }
}
