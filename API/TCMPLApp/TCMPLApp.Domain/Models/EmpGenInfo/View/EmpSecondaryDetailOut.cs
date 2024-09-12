using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class EmpSecondaryDetailOut : DBProcMessageOutput
    {
        public string PBloodGroup { get; set; }
        public string PReligion { get; set; }
        public string PMaritalStatus { get; set; }
        public string PRAdd { get; set; }
        public string PRHouseNo { get; set; }
        public string PRCity { get; set; }
        public string PRPincode { get; set; }
        public string PRDistrict { get; set; }
        public string PRCountry { get; set; }
        public string PPhoneRes { get; set; }
        public string PMobileRes { get; set; }
        public string PRefPersonName { get; set; }
        public string PFAdd { get; set; }
        public string PFHouseNo { get; set; }
        public string PFCity { get; set; }
        public string PFDistrict { get; set; }
        public string PFPincode { get; set; }
        public string PFCountry { get; set; }
        public string PRefPersonPhone { get; set; }
        public string PCoBusVal { get; set; }
        public string PCoBusText { get; set; }
        public string PPickUpPoint { get; set; }
        public string PMobileOff { get; set; }
        public string PFax { get; set; }
        public string PVoip { get; set; }

        public string PFState { get; set; }
        public string PRState { get; set; }
    }
}