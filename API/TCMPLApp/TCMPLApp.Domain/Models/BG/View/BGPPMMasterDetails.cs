using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.BG
{
    public class BGPPMMasterDetail : DBProcMessageOutput
    {
        public string PEmpno { get; set; }
        public string PEmployee { get; set; }
        public string PProjno { get; set; }
        public string PProject { get; set; }
        public string PCompId { get; set; }
        public string PCompDesc { get; set; }

        public decimal PIsVisible { get; set; }
        public decimal PIsDeleted { get; set; }
        public string PModifiedBy { get; set; }
        public string PModifiedOn { get; set; }
    }
}