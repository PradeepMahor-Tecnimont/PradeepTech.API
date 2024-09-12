using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public  class OSCMhrsSummaryDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }
        public string OscmId { get; set; }

        [Display(Name = "OSC No")]
        public string Empno { get; set; }

        [Display(Name = "OSC Name")]
        public string EmpName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Parent Name")]
        public string ParentName { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Assign Name")]
        public string AssignName { get; set; }
        
        [Display(Name = "ManHours")]
        public decimal Hours { get; set; }
        public string IsLock { get; set; }

        [Display(Name = "Lock")]
        public string IsLockStatus { get; set; }
        public string IsLockEnable { get; set; }
        public string IsUnlockEnable { get; set; }
        public string IsHodApprove { get; set; }

        [Display(Name = "Hod Approval")]
        public string IsHodApproveStatus { get; set; }
        public string IsHodApproveEnable { get; set; }
        public string IsHodDisapproveEnable { get; set; }
        public string IsPost { get; set; }

        [Display(Name = "Post")]
        public string IsPostStatus { get; set; }
        public string IsPostEnable { get; set; }
        public string IsUnpostEnable { get; set; }
        public string IsEditable { get; set; }
    }
}
