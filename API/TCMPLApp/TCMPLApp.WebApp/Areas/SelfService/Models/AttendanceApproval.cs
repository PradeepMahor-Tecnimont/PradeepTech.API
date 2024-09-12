using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class AttendanceApproval
    {
    }

    public class ApprovalRemarks
    {
        public string appId { get; set; }
        public string remarkVal { get; set; }
    }

    public class ApprovalApprlVals
    {
        public string appId { get; set; }
        public string apprlVal { get; set; }
    }

    public class ApprovalJsonModel
    {
        public string appId { get; set; }
        public string apprlVal { get; set; }
        public string remarkVal { get; set; }
    }
}