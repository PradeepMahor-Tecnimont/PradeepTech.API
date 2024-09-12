using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.JOB.View
{
    public class JobApproverStatus : DBProcMessageOutput
    {
        public string PPmName { get; set; }
        public DateTime? PPmApprlDate { get; set; }
        public string PJsName { get; set; }
        public string PJsStatus { get; set; }
        public DateTime? PJsApprlDate { get; set; }

        public string PMdName { get; set; }
        public string PMdStatus { get; set; }
        public DateTime? PMdApprlDate { get; set; }

        public string PAfcName { get; set; }
        public string PAfcStatus { get; set; }
        public DateTime? PAfcApprlDate { get; set; }

    }
}
