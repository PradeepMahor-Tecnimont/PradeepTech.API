using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.JOB
{
    public class TMAGroupsDetails : DBProcMessageOutput
    {
        public string PSubGroup { get; set; }
        public string PTmaGroupDesc { get; set; }

    }
}
