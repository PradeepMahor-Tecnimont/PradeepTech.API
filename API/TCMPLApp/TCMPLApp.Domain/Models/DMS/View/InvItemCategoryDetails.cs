using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvItemCategoryDetails : DBProcMessageOutput
    {
        [Display(Name = "Category description")]
        public string PItemCategoryDesc { get; set; }

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