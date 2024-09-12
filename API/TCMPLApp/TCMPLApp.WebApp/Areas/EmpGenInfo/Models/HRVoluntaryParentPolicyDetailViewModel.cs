using DocumentFormat.OpenXml.Wordprocessing;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.WebApp.Models
{
    public class HRVoluntaryParentPolicyDetailViewModel : Domain.Models.EmpGenInfo.HRVoluntaryParentPolicyDetailDataTableList
    {
        public HRVoluntaryParentPolicyDetailViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        public HRVoluntaryParentPolicyDetail hrVoluntaryParentPolicyDetail { get; set; }
    }
}