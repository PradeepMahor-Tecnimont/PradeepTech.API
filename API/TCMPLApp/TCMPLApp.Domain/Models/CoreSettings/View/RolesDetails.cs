using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class RolesDetails : DBProcMessageOutput
    {
        public string PRoleName { get; set; }
        public string PRoleDesc { get; set; }
        public string PRoleIsActive { get; set; }
    }
}
