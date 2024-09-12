using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DigiForm
{
    public class SiteMasterDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string KeyId { get; set; }

        [Display(Name = "Site Name")]
        public string SiteName { get; set; }

        [Display(Name = "Site Location")]
        public string SiteLocation { get; set; }

        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }
        public decimal? IsActiveVal { get; set; }

        [Display(Name = "Is Active")]
        public string IsActiveText { get; set; }
    }
}
