using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class HREmpNomineeDetailsDataTableExcel
    {
        public string Empno { get; set; }
        public string NomName { get; set; }
        public string Relation { get; set; }
        public decimal SharePcnt { get; set; }
    }
}
