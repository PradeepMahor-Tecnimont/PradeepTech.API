using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class AssetsOnDeskDataTableList
    {
        [Display(Name = "Asset Id")]
        public string AssetId { get; set; }

        [Display(Name = "Asset name")]
        public string AssetName { get; set; }

        [Display(Name = "Code")]
        public string AssetCode { get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }
    }
}