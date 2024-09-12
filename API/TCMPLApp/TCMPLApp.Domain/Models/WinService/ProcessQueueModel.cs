using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.WinService
{
    public class ProcessQueueModel
    {
        public string KeyId { get; set; }
        public string Empno { get; set; }
        public string ModuleId { get; set; }
        public string ProcessId { get; set; }
        public string ProcessDesc { get; set; }
        public string ParameterJson { get; set; }
        //public DateTime ProcessStartDate { get; set; }
        //public DateTime ProcessFinishDate { get; set; }
        //public DateTime CreatedOn { get; set; }
        //public decimal Status { get; set; }
        public string MailTo { get; set; }
        public string MailCc { get; set; }

    }


}
