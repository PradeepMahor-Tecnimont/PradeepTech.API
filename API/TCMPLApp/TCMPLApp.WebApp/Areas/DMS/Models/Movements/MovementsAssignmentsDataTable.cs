using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class MovementsAssignmentsDataTable
    {
        [Display(Name = "Session Id")]
        public string Sid { get; set; }

        [Display(Name = "Curret desk")]
        public string CurrDeskId { get; set; }

        [Display(Name = "Target desk")]
        public string Deskid { get; set; }
    }
}