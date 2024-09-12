using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    public class ChangePassword
    {
        public string CommandText { get => "Selfservice.CHANGE_PASSWORD"; }
        public string ParamEmpno { get; set; }
        public string ParamCurPwd { get; set; }
        public string ParamNewPwd1 { get; set; }
        public string ParamNewPwd2 { get; set; }
        public string OutParamSuccess { get; set; }
        public string OutParamMessage { get; set; }

    }
}
