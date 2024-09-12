namespace TCMPLApp.Domain.Models.Attendance
{
    public class EmployeeDetails
    {
        public string Empno { get; set; }

        public string Name { get; set; }

        public string Metaid { get; set; }
        public string Personid { get; set; }

        public string EmpGrade { get; set; }

        public string EmpEmail { get; set; }

        public string Emptype { get; set; }

        public string ParentCode { get; set; }

        public string AssignCode { get; set; }

        public string ParentDesc { get; set; }

        public string AssignDesc { get; set; }
        public string Projno { get; set; }
        public string WorkArea { get; set; }
        public string CurrentOfficeLocation { get; set; }
    }
}