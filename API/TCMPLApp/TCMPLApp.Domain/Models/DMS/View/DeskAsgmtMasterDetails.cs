using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAsgmtMasterDetails : DBProcMessageOutput
    {
        [Display(Name = "Desk no")]
        public string PDeskno { get; set; }

        [Display(Name = "Cabin/Desk")]
        public string PCabinDesk { get; set; }

        [Display(Name = "Employee1")]
        public string PEmp1 { get; set; }

        [Display(Name = "Employee2")]
        public string PEmp2 { get; set; }

        [Display(Name = "Office")]
        public string POffice { get; set; }

        [Display(Name = "Floor")]
        public string PFloor { get; set; }

        [Display(Name = "Area")]
        public string PArea { get; set; }

        [Display(Name = "IsBlocked")]
        public string PIsBlocked { get; set; }

        [Display(Name = "Blocked Reason")]
        public string PBlockedReason { get; set; }
    }
}