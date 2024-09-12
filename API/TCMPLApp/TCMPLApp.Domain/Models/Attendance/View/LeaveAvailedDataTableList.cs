using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{
    [Serializable]
    public class LeaveAvailedDataTableList
    {

        public string Empno { get; set; }

        public string EmployeeName { get; set; }

        public string Parent { get; set; }

        public string ParentDesc { get; set; }

        public string Grade { get; set; }
        public DateTime? Doj { get; set; }


        public string Emptype { get; set; }

        public string Designation { get; set; }

        public decimal Cl { get; set; }

        public decimal Sl { get; set; }

        public decimal Pl { get; set; }

        public decimal Co { get; set; }

        public decimal Total { get; set; }


    }
}
