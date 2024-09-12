using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class OscDetailDetails : DBProcMessageOutput
    {                    
        public string POscmId { get; set; }

        [Display(Name = "Cost code")]
        public string PCostcode { get; set; }

        [Display(Name = "Name")]
        public string PCostcodeDesc { get; set; }

    }
}