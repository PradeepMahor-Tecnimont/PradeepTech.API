using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class EmployeePolicyViewModel
    {
        [Required]
        [Display(Name = "Policy Acceptance")]
        public bool PolicyAccepted { get; set; }
        public bool? HoDApproved { get; set; }
        public bool? HRApproved { get; set; }


        [Display(Name = "Download Speed >= 10Mb")]
        public string DownloadSpeed { get; set; }

        [Display(Name = "Upload Speed >= 10Mb")]
        public string UploadSpeed { get; set; }

        [Display(Name = "More than 200GB Monthly Quota")]
        public string MonthlyQuota { get; set; }

        [Display(Name = "Internet Service Provider")]
        public string ISP { get; set; }

        [Display(Name = "Router Brand")]
        public string RouterBrand { get; set; }

        [Display(Name = "Router Model")]
        public string RouterModel { get; set; }


        [Display(Name = "Power Backup")]
        public string ElectricityBackUp { get; set; }

        public string InstallMSAuthenticator { get; set; }

        public bool IsTrainingCompleted { get; set; }

        public bool IsIphoneUser { get; set; }

    }
}
