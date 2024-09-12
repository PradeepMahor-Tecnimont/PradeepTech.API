using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvAddOnContainerDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "key id")]
        public string KeyId { get; set; }

        [Display(Name = "Addon item")]
        public string AddonItemId { get; set; }

        [Display(Name = "Addon item")]
        public string AddonItemDesc { get; set; }

        [Display(Name = "Container item")]
        public string ContainerItemId { get; set; }

        [Display(Name = "Container item")]
        public string ContainerItemDesc { get; set; }
    }
}
