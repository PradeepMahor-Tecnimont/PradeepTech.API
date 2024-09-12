using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAsgmtMasterDataTableList
    {
        [Display(Name = "Desk no")]
        public string DeskNo { get; set; }

        [Display(Name = "Cabin/Desk")]
        public string CabinDesk { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Floor")]
        public string Floor { get; set; }

        [Display(Name = "Area")]
        public string Area { get; set; }
    }
}