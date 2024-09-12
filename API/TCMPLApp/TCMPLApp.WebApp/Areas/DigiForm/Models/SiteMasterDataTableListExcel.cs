using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class SiteMasterDataTableListExcel
    {
        public string KeyId { get; set; }
        public string SiteName { get; set; }
        public string SiteLocation { get; set; }
        public decimal? IsActiveVal { get; set; }
        public string IsActiveText { get; set; }
        public DateTime? ModifiedOn { get; set; }
        public string ModifiedBy { get; set; }
    }
}
