using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class HREmpNomineeDataTableList
    {
        [Display(Name = "Employee No")]
        public string Empno { get; set; }

        [Display(Name = "Nominee Name")]
        public string NomName { get; set; }

        [Display(Name = "Relation")]
        public string Relation { get; set; }

        [Display(Name = "Share Percentage")]
        public decimal SharePcnt { get; set; }
    }
}