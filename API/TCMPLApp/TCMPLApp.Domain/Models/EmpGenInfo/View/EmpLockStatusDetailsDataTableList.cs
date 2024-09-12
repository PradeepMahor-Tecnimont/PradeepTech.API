using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class EmpLockStatusDetailsDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string Empno { get; set; }
        public string EmpName { get; set; }
        public string Parent { get; set; }
        public string ParentName { get; set; }
        public string Assign { get; set; }
        public string AssignName { get; set; }
        public string ModifiedOn { get; set; }
        public decimal IsLoginLockOpen { get; set; }
        public decimal IsPrimLockOpen { get; set; }
        public decimal IsSecondaryLockOpen { get; set; }
        public decimal IsNomLockOpen { get; set; }
        public decimal IsFmlyLockOpen { get; set; }
        public decimal IsAdhaarLock { get; set; }
        public decimal IsGtliLock { get; set; }
        public decimal IsPpLock { get; set; }
        public decimal PpExists { get; set; }
        public decimal AadhaarExists { get; set; }
        public decimal GtliExists { get; set; }
        public decimal NominationExists { get; set; }
    }
}
