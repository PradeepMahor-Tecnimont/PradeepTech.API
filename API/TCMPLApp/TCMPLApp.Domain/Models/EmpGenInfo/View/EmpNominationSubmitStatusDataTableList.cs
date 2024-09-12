using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class EmpNominationSubmitStatusDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }
        public string Empno { get; set; }
        public string EmpName { get; set; }
        public string Parent { get; set; }
        public string Doj { get; set; }
        public string Email { get; set; }
        public string Submitted { get; set; }
        public decimal PRollStatus { get; set; }
        public string HrDate { get; set; }
        public string ModifiedOn { get; set; }
        public string ModifiedBy { get; set; }
    }
}
