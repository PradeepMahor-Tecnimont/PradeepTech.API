using System;

namespace TCMPLApp.WebApp.Areas.ExcelTemplate.Models
{
    public class EmployeeMaster
    {       
        public string Empno { get; set; }
        public string Name { get; set; }
        public string Emptype  { get; set; }
        public string Gender { get; set; }
        public string Category { get; set; }
        public string Grade { get; set; }
        public string Designation { get; set; }
        public DateTime DOB { get; set; }
        public DateTime DOJ { get; set; }
        public DateTime ContractEndDate { get; set; }
        public string Parent { get; set; }
        public string Assinged { get; set; }
        public string Office { get; set; }
        public string SubcontractAgency { get; set; }
        public string Location { get; set; }
        public string Place { get; set; }
    }
}
