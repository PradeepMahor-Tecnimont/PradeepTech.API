using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.SWP
{
    public class EmployeePrimaryWorkspaceOutput : DBProcMessageOutput
    {
        public string PCurrentWorkspaceText { get; set; }

        public string PCurrentWorkspaceVal { get; set; }
        public string PCurrentWorkspaceDate { get; set; }
        public string PPlanningWorkspaceText { get; set; }

        public string PPlanningWorkspaceVal { get; set; }
        public string PPlanningWorkspaceDate { get; set; }
    }
}