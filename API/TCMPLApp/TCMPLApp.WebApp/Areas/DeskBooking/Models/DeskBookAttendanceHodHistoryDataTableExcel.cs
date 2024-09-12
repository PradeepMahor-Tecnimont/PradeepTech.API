using System;

namespace TCMPLApp.WebApp.Models
{
    public class DeskBookAttendanceHodHistoryDataTableExcel
    {
        //public string KeyId { get; set; }

        public string Empno { get; set; }

        public string EmpName { get; set; }

        public string Office { get; set; }

        public string DeptCode { get; set; }

        public string DeptName { get; set; }

        public DateTime? AttendanceDate { get; set; }

        public string BookedDesk { get; set; }

        public string DeskBookInOffice { get; set; }

        public string Shiftcode { get; set; }

        public string IsEmpPresent { get; set; }
    }
}