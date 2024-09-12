using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class HRExEmpContactInfoDataTableList
    {
        public string Empno { get; set; }
        public string EmployeeName { get; set; }
        public string DeptName { get; set; }
        public string Email { get; set; }
        public DateTime? Dol { get; set; }
        public string ResidentialAddress { get; set; }
        public string ResidentialPhone { get; set; }
        public string ResidentialMobile { get; set; }
        public string PermanentAddress { get; set; }
        public string Phone { get; set; }
        public string Mobile { get; set; }

    }
}