using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class IcardConsentDetails : DBProcMessageOutput
    {
        [Display(Name = "Empno")]
        public string PEmployee { get; set; }

        [Display(Name = "Consent")]
        public string PIsConsent { get; set; }

        [Display(Name = "New photo uploaded")]
        public string PNewImgUploaded { get; set; }
        
        public DateTime? PModifiedOn { get; set; }

        public string PModifiedBy { get; set; }

    }
}
