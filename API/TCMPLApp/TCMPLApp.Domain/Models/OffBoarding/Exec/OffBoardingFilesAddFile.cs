using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OffBoardingFilesAddFile
    {
        public string CommandText { get => OffBoardingProcedure.OffBoardingFilesAddFile; }
        public string PEmpno { get; set; }
        public string PUploadByGroup { get; set; }
        public string PUploadByEmpno { get; set; }
        public string PClientFileName { get; set; }
        public string PServerFileName { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }

    }
}
