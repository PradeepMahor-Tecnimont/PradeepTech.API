using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;


namespace TCMPLApp.Domain.Models.Attendance
{
    public class DeskDetailsOutPut : DBProcMessageOutput
    {
            public string PDeskId { get; set; }
            public string PCompName { get; set; }
            public string PComputer { get; set; }
            public string PPcModel { get; set; }
            public string PMonitor1 { get; set; }
            public string PMonitor1Model { get; set; }
            public string PMonitor2 { get; set; }
            public string PMonitor2Model { get; set; }
            public string PTelephone { get; set; }
            public string PTelephoneModel { get; set; }



    }
}
