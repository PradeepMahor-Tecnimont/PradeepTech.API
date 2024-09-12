using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HSE
{
    public class HSEQuizDetailOut : DBProcMessageOutput
    {
        public string PQuizId { get; set; }
        public string PDescription { get; set; }
        public DateTime? PQuizDate { get; set; }
        public DateTime? PQuizStartDate { get; set; }
        public DateTime? PQuizEndDate { get; set; }

    }
}
