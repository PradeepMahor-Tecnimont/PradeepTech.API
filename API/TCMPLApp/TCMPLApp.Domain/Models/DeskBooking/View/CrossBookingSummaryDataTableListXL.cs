using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class CrossBookingSummaryDataTableListXL
    {
        public string Empno { get; set; }

        public string EmpName { get; set; }

        public string DeptCode { get; set; }
        public string DeptName { get; set; }
        public string LocationEmpOffice { get; set; }

        public string LocationDesk { get; set; }
        public string DeskOffice { get; set; }
        public string DeskId { get; set; }
        public string AreaDesc { get; set; }
        public DateTime? BookingDate { get; set; }

        public string Shiftcode { get; set; }
        public string IsEmpPresent { get; set; }
        public string PunchExists { get; set; }
    }
}