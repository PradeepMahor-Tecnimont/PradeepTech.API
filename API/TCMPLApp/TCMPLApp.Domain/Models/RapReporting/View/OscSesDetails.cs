using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class OscSesDetails : DBProcMessageOutput
    {
        public string POscmId { get; set; }

        public string PSesNo { get; set; }

        public DateTime? PSesDate { get; set; }

        public decimal? PSesAmount { get; set; }
    }
}