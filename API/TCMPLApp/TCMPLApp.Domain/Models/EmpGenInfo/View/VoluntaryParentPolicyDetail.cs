using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class VoluntaryParentPolicyDetail : DBProcMessageOutput
    {
        [Display(Name = "Voluntary Parent Policy id")]
        public string PApplicationId { get; set; }

        [Display(Name = "Empno")]
        public string PEmpno { get; set; }

        [Display(Name = "Employee")]
        public string PEmployee { get; set; }

        [Display(Name = "Insured Sum (Family floater)")]
        public string PInsuredSumId { get; set; }

        [Display(Name = "Insured Sum (Family floater)")]
        public string PInsuredSumWords { get; set; }

        [Display(Name = "Premium amount")]
        public decimal? PPremiumAmt { get; set; }

        [Display(Name = "GST amount")]
        public decimal? PGstAmt { get; set; }

        [Display(Name = "Total premium amount")]
        public decimal? PTotalPremium { get; set; }

        [Display(Name = "Voluntary Parent Policy Is Lock")]
        public decimal? PIsLock { get; set; }
    }
}