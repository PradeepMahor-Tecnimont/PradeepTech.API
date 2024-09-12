using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class PrimaryWorkSpaceViewModel : Domain.Models.SWP.PrimaryWorkSpaceDataTableList
    {
        public PrimaryWorkSpaceViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }

    public class PrimaryWorkspace
    {
        public string key { get; set; }
        public string empNo { get; set; }
        public string workspace { get; set; } // 0(Pending),1(Office),2(SmartWork),3(Not in mumbai office)
    }

    public class PrimaryWorkspaceAdmin
    {
        public string key { get; set; }
        public string empNo { get; set; }
        public string workspace { get; set; } // 0(Pending),1(Office),2(SmartWork),3(Not in mumbai office)
        public string startdate { get; set; }
    }
}