using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class CostcodeGroupCostcodeDataTableList
    {       
        [Display(Name = "Costcode group name")]
        public string CostcodeGroupName { get; set; }

        [Display(Name = "Costcode")]
        public string Costcode { get; set; }
    }
}