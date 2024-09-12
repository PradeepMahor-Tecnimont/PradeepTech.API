using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.SWP
{
    public class PrimaryWorkSpaceForAdminDataTableList
    {
        [Display(Name = "Key id")]
        public string KeyId { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Start date")]
        public string StartDate { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified on date")]
        public string ModifiedOnDate { get; set; }

        [Display(Name = "Workspace")]
        public decimal PrimaryWorkspace { get; set; }

        [Display(Name = "Workspace")]
        public string PrimaryWorkspaceText { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}