using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class HRVoluntaryParentPolicyDetail : DBProcMessageOutput
    {
        [Display(Name = "Voluntary Parent Policy detail id")]
        public string PApplicationId { get; set; }

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
        public string PIsLock { get; set; }
    }
}