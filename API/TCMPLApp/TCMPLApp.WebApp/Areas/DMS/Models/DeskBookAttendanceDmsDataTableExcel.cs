using System;

namespace TCMPLApp.WebApp.Models
{
    public class DeskBookAttendanceDmsDataTableExcel
    {
        //public string KeyId { get; set; }

        public string Empno { get; set; }

        public string EmpName { get; set; }

        public string Office { get; set; }

        public string DeptCode { get; set; }

        public string DeptName { get; set; }
        public string AreaDesc { get; set; }
        public DateTime? BookingDate { get; set; }

        public string BookedDesk { get; set; }

        public string DeskOffice { get; set; }

        public string Shiftcode { get; set; }

        public string IsEmpPresent { get; set; }
    }
}