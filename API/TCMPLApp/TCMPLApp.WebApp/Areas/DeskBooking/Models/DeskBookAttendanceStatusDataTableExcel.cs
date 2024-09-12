using System;

namespace TCMPLApp.WebApp.Models
{
    public class DeskBookAttendanceStatusDataTableExcel
    {
        public string AreaDesc { get; set; }
        public string Empno { get; set; }
        public string EmpName { get; set; }
        public string EmpOfficeLocation { get; set; }
        public string DeptCode { get; set; }
        public string DeptName { get; set; }
        public DateTime? BookingDate { get; set; }
        public string BookedDesk { get; set; }
        public string DeskOffice { get; set; }
        public string Shiftcode { get; set; }
        public string IsPresent { get; set; }
        public string IsDeskBook { get; set; }
        public string PunchInOffice { get; set; }
        public string IsCrossAttend { get; set; }
    }
}