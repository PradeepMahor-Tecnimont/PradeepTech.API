using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.LC
{
    public class LcLiveStatusDataTableList
    {
        [Display(Name = "Application id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Lc key id")]
        public string LcKeyId { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Live Status")]
        public string LiveStatus { get; set; }

        [Display(Name = "LiveStatusKeyId")]
        public string LiveStatusKeyId { get; set; }

        [Display(Name = "Modified On")]
        public string ModifiedOn { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}