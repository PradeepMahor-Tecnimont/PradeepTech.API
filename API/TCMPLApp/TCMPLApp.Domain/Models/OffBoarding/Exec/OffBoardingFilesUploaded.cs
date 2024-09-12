using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OffBoardingFilesUploaded
    {

        public string KeyId { get; set; }
        public string Empno { get; set; }
        public string EmployeeName { get; set; }
        public string UploadByGroup { get; set; }
        public string UploadByEmpno { get; set; }
        public string UploadByEmployeeName { get; set; }
        public string ClientFileName { get; set; }
        public string ServerFileName { get; set; }
        public DateTime UploadDate { get; set; }

    }
}
