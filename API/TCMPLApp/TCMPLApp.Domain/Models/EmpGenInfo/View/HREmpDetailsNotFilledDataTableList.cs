using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class HREmpDetailsNotFilledDataTableList
    {
        public string Empno { get; set; }
        public string Name { get; set; }
        public string Parent { get; set; }
        public string Assign { get; set; }
        public string CoBus { get; set; }
        public DateTime? Doj { get; set; }
        public string Email { get; set; }
    }
}