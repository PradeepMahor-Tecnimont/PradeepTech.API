using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LcAmountDetailsViewModel
    {
        public string ApplicationId { get; set; }

        public IEnumerable<TCMPLApp.Domain.Models.LC.LcAmountDataTableList> lcAmountDataTableList { get; set; }

        [Display(Name = "LC Status ")]
        public string LcStatusText { get; set; }

        public int LcStatusVal { get; set; }
        public int SendToTreasury { get; set; }
    }
}