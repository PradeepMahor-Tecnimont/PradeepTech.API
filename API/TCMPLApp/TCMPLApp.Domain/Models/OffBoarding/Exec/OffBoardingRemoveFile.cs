using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OffBoardingRemoveFile
    {
        public string CommandText { get => OffBoardingProcedure.OffBoardingFilesRemoveFile; }
        public string PEmpno { get; set; }
        public string PKeyId { get; set; }
        public string OutPServerFileName { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }

    }

}
