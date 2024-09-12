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
    public class VoluntaryParentPolicyConfiguration : DBProcMessageOutput
    {
        [Display(Name = "Config Id")]
        public string PConfigId { get; set; }

        [Display(Name = "Is Enable for Add/Update/Delete")]
        public decimal? PIsEnableMod { get; set; }

        [Display(Name = "Is Display Premium Amount ")]
        public decimal? PIsDisplayPremium { get; set; }
    }
}