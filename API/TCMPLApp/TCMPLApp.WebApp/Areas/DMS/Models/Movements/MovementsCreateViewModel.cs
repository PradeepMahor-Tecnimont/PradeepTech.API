using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class MovementsCreateViewModel
    {
        [Display(Name = "Session Id")]
        public string Sid { get; set; }

        [Display(Name = "Source desk list")]
        public List<MovementsSelectedDeskDataTableList> SourceDeskList { get; set; }

        [Display(Name = "Target desk list")]
        public List<MovementsSelectedDeskDataTableList> TargetDeskList { get; set; }

        [Display(Name = "Target assignments")]
        public List<MovementAssignmentDataTableList> TargetAssignments { get; set; }
    }

    //public class DeskDetails
    //{
    //    public string Sid { get; set; }
    //    public string DeskId { get; set; }
    //    public string AssetId { get; set; }
    //}

    public class AssignmentDetails
    {
        public string SourceDeskId { get; set; }

        public string TagetDeskId { get; set; }

        public string AssetId { get; set; }

        public string Empno { get; set; }
    }
}