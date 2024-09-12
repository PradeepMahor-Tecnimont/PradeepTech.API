using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvItemAMSAssetMappingDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "key id")]
        public string KeyId { get; set; }

        [Display(Name = "item_type_key_id")]
        public string ItemTypeKeyId { get; set; }

        [Display(Name = "Item type code")]
        public string ItemTypeCode { get; set; }

        [Display(Name = "Category code")]
        public string CategoryCode { get; set; }

        [Display(Name = "Item assignment type")]
        public string ItemAssignmentType { get; set; }

        [Display(Name = "item type description")]
        public string ItemTypeDesc { get; set; }

        [Display(Name = "Sub asset type")]
        public string SubAssetType { get; set; }

        [Display(Name = "Sub asset type desc")]
        public string SubAssetTypeDesc { get; set; }

        [Display(Name = "Is active")]
        public decimal? IsActiveVal { get; set; }

        [Display(Name = "Is active")]
        public string IsActiveText { get; set; }

        [Display(Name = "Modified on")]
        public string ModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }
    }
}