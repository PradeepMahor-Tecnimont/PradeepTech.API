using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class HREmpMediclaimDataTableList
    {
        public string Empno { get; set; }
        public string Member { get; set; }
        public DateTime? Dob { get; set; }
        public string Remarks { get; set; }
        public DateTime? ChgDate { get; set; }
        public string ChgType { get; set; }
        public string Relation { get; set; }
        public string Occupation { get; set; }
        public string Name { get; set; }
        public string Grade { get; set; }
        public string KeyId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
    }
}