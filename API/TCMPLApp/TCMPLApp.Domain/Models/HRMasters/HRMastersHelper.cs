using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public static class HRMastersHelper
    {   
        public const string RoleHoDAdmin = "R002";
        public const string RolePayRollAdmin = "R010";
        public const string RoleAttendanceAdmin = "R011";
        public const string RoleCostControlAdmin = "R012";
        public const string RoleAFCAdmin = "R013";
        public const string RoleHRMastersView = "R014";
        public const string RoleHRMastersEmpExport = "R096";


        public const string ActionEditEmplmast = "A001";
        public const string ActionViewHRMasters = "A002";
        public const string ActionEditHRMasters = "A003";
        public const string ActionHRMastersEmpExport = "A214";

        public const string ActionHRMISFeature = "A163";

        public const string ActionHRMISResignedUpdate = "A157";
        public const string ActionHRMISProspectiveUpdate = "A158";
        public const string ActionHRMISTransfersUpdate = "A159";
        public const string ActionHRMISResignedReadAll = "A160";
        public const string ActionHRMISProspectiveReadAll = "A161";
        public const string ActionHRMISTransfersReadAll = "A162";


        public const string ActionHRMastersCostcodeExport = "A250";
    }
}
