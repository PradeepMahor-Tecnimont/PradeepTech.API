using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class MovementsSelectedDeskDataTableList
    {
        [Display(Name = "Session Id")]
        public string Sid { get; set; }

        [Display(Name = "Desk")]
        public string DeskId { get; set; }

        [Display(Name = "Category")]
        public string Category { get; set; }

        [Display(Name = "Asset")]
        public string AssetId { get; set; }

        public string Assettype { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        public string Iconname { get; set; }
    }
}