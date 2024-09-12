using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LcChargesDetailsViewModel
    {
        public string ApplicationId { get; set; }

        public IEnumerable<TCMPLApp.Domain.Models.LC.LcChargesDataTableList> lcChargesDataTableList { get; set; }

        [Display(Name = "LC Status ")]
        public string LcStatusText { get; set; }

        public int LcStatusVal { get; set; }
        public int SendToTreasury { get; set; }
    }
}