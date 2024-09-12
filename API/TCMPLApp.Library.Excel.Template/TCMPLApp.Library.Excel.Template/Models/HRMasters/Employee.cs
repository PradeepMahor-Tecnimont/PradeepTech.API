using System;

namespace TCMPLApp.Library.Excel.Template.Models
{
    public class Employee
    {
        public string Empno { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string Emptype { get; set; }
        public string Gender { get; set; }
        public string Category { get; set; }
        public string Grade { get; set; }
        public string Designation { get; set; }
        public DateTime? DOB { get; set; }
        public DateTime? DOJ { get; set; }
        public DateTime? ContractEndDate { get; set; }
        public string Parent { get; set; }
        public string Assigned { get; set; }
        public string Office { get; set; }
        public string SubcontractAgency { get; set; }
        public string Location { get; set; }
        public string Place { get; set; }
    }
}
