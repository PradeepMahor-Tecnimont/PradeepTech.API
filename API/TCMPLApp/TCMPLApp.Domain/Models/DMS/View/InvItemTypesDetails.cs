using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvItemTypesDetails : DBProcMessageOutput
    {
        [Display(Name = "Item type key id")]
        public string PItemTypeKeyId { get; set; }

        [Display(Name = "Item type code")]
        public string PItemTypeCode { get; set; }

        [Display(Name = "Category code")]
        public string PCategoryCode { get; set; }

        [Display(Name = "Category description")]
        public string PCategoryDesc { get; set; }

        [Display(Name = "Item assignment type")]
        public string PItemAssignmentType { get; set; }

        [Display(Name = "Item assignment description")]
        public string PItemAssignmentDesc { get; set; }

        [Display(Name = "Item type description")]
        public string PItemTypeDesc { get; set; }

        [Display(Name = "Is active")]
        public decimal? PIsActiveVal { get; set; }

        [Display(Name = "Is active")]
        public string PIsActiveText { get; set; }

        [Display(Name = "Print Order")]
        public decimal? PPrintOrder { get; set; }

        [Display(Name = "Modified on")]
        public string PModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string PModifiedBy { get; set; }

        [Display(Name = "Action")]
        public string PActionId { get; set; }
    }
}