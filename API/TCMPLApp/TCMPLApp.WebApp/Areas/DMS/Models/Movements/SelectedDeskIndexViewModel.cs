using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class SelectedDeskIndexViewModel
    {
        [Display(Name = "Session Id")]
        public string Sid { get; set; }

        public IEnumerable<MovementsSelectedDeskDataTableList> MovementsSelectedDeskDataTableLists { get; set; }
    }
}