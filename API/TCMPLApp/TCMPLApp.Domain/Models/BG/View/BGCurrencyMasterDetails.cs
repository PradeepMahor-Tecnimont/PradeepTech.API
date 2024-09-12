using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.BG
{
    public class BGCurrencyMasterDetail : DBProcMessageOutput
    {
        public string PCurrDesc { get; set; }
        public string PCompId { get; set; }
        public string PCompDesc { get; set; }
        public decimal PIsVisible { get; set; }
        public decimal PIsDeleted { get; set; }
        public string PModifiedBy { get; set; }
        public string PModifiedOn { get; set; }
    }
}