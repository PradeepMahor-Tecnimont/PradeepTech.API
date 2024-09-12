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
    public class EmpPrimaryDetailOut : DBProcMessageOutput
    {
        public string PFirstName { get; set; }
        public string PSurname { get; set; }
        public string PFatherName { get; set; }
        public string PPAdd { get; set; }
        public string PPHouseNo { get; set; }
        public string PPCity { get; set; }
        public string PPDistrict { get; set; }
        public string PPPincode { get; set; }
        public string PPState { get; set; }
        public string PPCountry { get; set; }
        public string PPlaceOfBirth { get; set; }
        public string PCountryOfBirth { get; set; }
        public string PNationality { get; set; }
        public string PPPhone { get; set; }
        public string PNoOfChild { get; set; }
        public string PPersonalEmail { get; set; }
        public string PPMobile { get; set; }
        public string PDob { get; set; }
        public string PMaritalStatus { get; set; }
        public string PReligion { get; set; }
        public string PGender { get; set; }
        public string PNoDadHusbInName { get; set; }

        public string PEmpNo { get; set; }
        public string PEmpName { get; set; }
        public string PParent { get; set; }
        public string PCostName { get; set; }
        public string PAssign { get; set; }
        public string PAssignName { get; set; }
        public string PEmptype { get; set; }
        public string PDesgCode { get; set; }
        public string PDesgName { get; set; }
        public DateTime? PDoj { get; set; }
        public DateTime? PDol { get; set; }
        public string PDojService { get; set; }
        public string PHod { get; set; }
        public string PHodName { get; set; }
        public string PSecretary { get; set; }
        public string PSecretaryName { get; set; }
        public string PGrade { get; set; }
        public string PMngrName { get; set; }
    }
}