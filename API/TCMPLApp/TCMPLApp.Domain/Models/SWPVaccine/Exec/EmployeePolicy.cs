using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    public class EmployeePolicyExecModel
    {
        public bool PolicyAccepted { get; set; }
        //public bool? HoDApproved { get; set; }
        //public bool? HRApproved { get; set; }

        
        
        
        public string DownloadSpeed { get; set; }

        
        public string UploadSpeed { get; set; }

        
        public string MonthlyQuota { get; set; }

        
        public string ISP { get; set; }

        
        public string RouterBrand { get; set; }

        
        public string RouterModel { get; set; }


        
        public string ElectricityBackUp { get; set; }

        public string MSAuthOnOwnMob { get; set; }

        //public bool IsTrainingCompleted { get; set; }

    }
}
