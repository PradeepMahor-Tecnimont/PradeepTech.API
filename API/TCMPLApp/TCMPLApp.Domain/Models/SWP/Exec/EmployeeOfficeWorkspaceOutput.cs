using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.SWP
{
    public class EmployeeOfficeWorkspaceOutput : DBProcMessageOutput
    {
        //public string POffice { get; set; }

        //public string PFloor { get; set; }
        //public string PWing { get; set; }
        //public string PDesk { get; set; }

        public decimal PCurrentPws { get; set; }
        public decimal? PPlanningPws { get; set; }
        public string PCurrentPwsText { get; set; }
        public string PPlanningPwsText { get; set; }
        public string PCurrDeskId { get; set; }
        public string PCurrOffice { get; set; }
        public string PCurrFloor { get; set; }
        public string PCurrWing { get; set; }
        public string PCurrBay { get; set; }
        public string PPlanDeskId { get; set; }
        public string PPlanOffice { get; set; }
        public string PPlanFloor { get; set; }
        public string PPlanWing { get; set; }
        public string PPlanBay { get; set; }

        //public IEnumerable<SmartWorkSpaceDataTableList> PCurrSws { get; set; }
        //public IEnumerable<SmartWorkSpaceDataTableList> PPlanSws { get; set; }
    }
}