using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvItemAsgmtTypesDetails : DBProcMessageOutput
    {
        [Display(Name = "Item assignment type description")]
        public string PItemAsgmtTypesDesc { get; set; }

        [Display(Name = "Is active")]
        public decimal? PIsActiveVal { get; set; }

        [Display(Name = "Is active")]
        public string PIsActiveText { get; set; }

        [Display(Name = "Modified on")]
        public string PModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string PModifiedBy { get; set; }
    }
}