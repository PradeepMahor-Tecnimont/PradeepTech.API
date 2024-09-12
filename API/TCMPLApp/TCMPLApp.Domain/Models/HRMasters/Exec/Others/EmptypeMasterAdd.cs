using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmptypeMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.EmptypeMasterAdd; }

        public string PEmptype { get; set; }
        public string PEmpdesc { get; set; }
        public string PEmpremarks { get; set; }
        public int? PTm { get; set; }
        public int? PPrintlogo { get; set; }
        public string PSortorder { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
