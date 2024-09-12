using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class BayDetails : DBProcMessageOutput
    {
        public string PBayDesc { get; set; }
    }
}