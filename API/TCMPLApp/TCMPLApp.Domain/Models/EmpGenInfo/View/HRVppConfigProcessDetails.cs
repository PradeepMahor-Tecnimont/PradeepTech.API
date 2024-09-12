using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class HRVppConfigProcessDetails : DBProcMessageOutput
    {
        public DateTime? PStartDate { get; set; }
        public DateTime? PEndDate { get; set; }
        public decimal? PIsDisplayPremiumVal { get; set; }
        public string PIsDisplayPremiumText { get; set; }
        public decimal? PIsDraftVal { get; set; }
        public string PIsDraftText { get; set; }
        public DateTime? PEmpJoiningDate { get; set; }
        public decimal? PIsInitiateConfigVal { get; set; }
        public string PIsInitiateConfigText { get; set; }
        public decimal? PIsApplicableToAllVal { get; set; }
        public string PIsApplicableToAllText { get; set; }
        public string PCreatedBy { get; set; }
        public DateTime? PCreatedOn { get; set; }
        public string PModifiedBy { get; set; }
        public DateTime? PModifiedOn { get; set; }
    }
}