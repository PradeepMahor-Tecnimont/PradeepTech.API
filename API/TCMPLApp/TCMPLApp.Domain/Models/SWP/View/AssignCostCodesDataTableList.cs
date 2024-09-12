using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWP
{
    public class AssignCostCodesDataTableList
    {
        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "AssignDesc")]
        public string AssignDesc { get; set; }
    }
}
