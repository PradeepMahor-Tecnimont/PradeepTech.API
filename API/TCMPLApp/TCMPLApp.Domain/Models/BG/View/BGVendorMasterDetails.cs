using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.BG
{
    public class BGVendorMasterDetail : DBProcMessageOutput
    {
        public string PVendorName { get; set; }

        public string PCompId { get; set; }
        public string PCompDesc { get; set; }
        public decimal PIsVisible { get; set; }
        public decimal PIsDeleted { get; set; }
        public string PModifiedBy { get; set; }
        public string PModifiedOn { get; set; }
    }
}