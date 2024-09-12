using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class MovementAssignmentIndexViewModel
    {
        [Display(Name = "Session Id")]
        public string Sid { get; set; }

        public IEnumerable<MovementAssignmentDataTableList> MovementsAssignmentsDataTableLists { get; set; }
    }
}