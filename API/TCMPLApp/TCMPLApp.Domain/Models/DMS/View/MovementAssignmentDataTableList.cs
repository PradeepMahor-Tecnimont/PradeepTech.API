using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class MovementAssignmentDataTableList
    {
        [Display(Name = "Session Id")]
        public string Sid { get; set; }

        [Display(Name = "Curret desk")]
        public string CurrDeskid { get; set; }

        [Display(Name = "Target desk")]
        public string Deskid { get; set; }

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string Empname { get; set; }

        [Display(Name = "Asset")]
        public decimal IsAsset { get; set; }

        [Display(Name = "Employee")]
        public decimal IsEmployee { get; set; }
    }
}