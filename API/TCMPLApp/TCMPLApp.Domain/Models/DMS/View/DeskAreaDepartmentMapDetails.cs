using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAreaDepartmentMapDetails : DBProcMessageOutput
    {

        public string PAreaCatgCode { get; set; }
        public string PAreaCatgDesc { get; set; }
        public string PAreaId { get; set; }
        public string PAreaDesc { get; set; }
        public string PCostCode { get; set; }
        public string PCostCodeName { get; set; }
        public string PModifiedBy { get; set; }
        public DateTime? PModifiedOn { get; set; }
    }
}
