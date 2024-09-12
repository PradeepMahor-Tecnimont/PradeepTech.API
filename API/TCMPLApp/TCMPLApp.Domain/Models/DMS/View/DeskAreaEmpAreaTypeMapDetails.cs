using System;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAreaEmpAreaTypeMapDetails : DBProcMessageOutput
    {
        public string PAreaId { get; set; }
        public string PAreaDesc { get; set; }

        public string PAreaCatgCode { get; set; }
        public string PAreaCatgDesc { get; set; }

        public string PAreaTypeCode { get; set; }
        public string PAreaTypeDesc { get; set; }

        public string PEmpNo { get; set; }
        public string PEmpName { get; set; }

        public string PModifiedBy { get; set; }
        public DateTime? PModifiedOn { get; set; }
    }
}