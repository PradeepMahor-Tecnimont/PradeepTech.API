using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskBlockDetails : DBProcMessageOutput
    {
        public string PRemarks { get; set; }
        public decimal? PReasoncode { get; set; }
        public string PDescription { get; set; }
    }
}