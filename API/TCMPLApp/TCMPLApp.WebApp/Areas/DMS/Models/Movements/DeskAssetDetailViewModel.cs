using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAssetDetailViewModel
    {
        [Display(Name = "Session Id")]
        public string Sid { get; set; }

        public IEnumerable<MovementsSelectedDeskDataTableList> DeskAssetDataTableLists { get; set; }
    }
}