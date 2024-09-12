using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DMSGuestMasterDetails : DBProcMessageOutput
    {
        public string PGuestName { get; set; }

        public string PCostcode { get; set; }

        public string PProjno5 { get; set; }

        //public string PProjName { get; set; }

        public DateTime? PFromDate { get; set; }

        public DateTime? PToDate { get; set; }

        public string PTargetDesk { get; set; }

        //public string PCreatedBy { get; set; }

        //public DateTime? PCreationDate { get; set; }

        public string PModifiedBy { get; set; }

        public DateTime? PModifiedDate { get; set; }
    }
}