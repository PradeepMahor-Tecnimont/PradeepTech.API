using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterRolesUpdate
    {
        public string CommandText { get => HRMastersProcedure.EmployeeMasterRolesEdit; }
        public string PEmpno { get; set; }
        public Int32? PAmfiAuth { get; set; }
        public Int32? PAmfiUser { get; set; }
        public Int32? PCostdy { get; set; }
        public Int32? PCosthead { get; set; }
        public Int32? PCostopr { get; set; }
        public Int32? PDba { get; set; }
        public Int32? PDirector { get; set; }
        public Int32? PDirop { get; set; }
        public Int32? PProjdy { get; set; }
        public Int32? PProjmngr { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
