using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvItemAMSAssetMappingDetails : DBProcMessageOutput
    {
        [Display(Name = "item_type_key_id")]
        public string PItemTypeKeyId { get; set; }

        [Display(Name = "Item type code")]
        public string PItemTypeCode { get; set; }

        [Display(Name = "Category code")]
        public string PCategoryCode { get; set; }

        [Display(Name = "Item assignment type")]
        public string PItemAssignmentType { get; set; }

        [Display(Name = "item type description")]
        public string PItemTypeDesc { get; set; }

        [Display(Name = "Sub asset type")]
        public string PSubAssetType { get; set; }

        [Display(Name = "Sub asset type desc")]
        public string PSubAssetTypeDesc { get; set; }

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