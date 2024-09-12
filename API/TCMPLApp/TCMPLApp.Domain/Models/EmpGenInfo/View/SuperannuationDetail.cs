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
    public class SuperannuationDetail : DBProcMessageOutput
    {

        [Display(Name = "Empno")]
        public string PEmpno { get; set; }
    }
}