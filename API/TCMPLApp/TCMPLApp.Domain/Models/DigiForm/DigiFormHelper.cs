using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DigiForm
{
    public class DigiFormHelper
    {
        //public const string ActionCreateDigiForm = "Axxx";

        public const string RoleHoD = "R002";
        public const string RoleProgEvalHR = "R094";
        public const string RoleSec = "R003";
        public const string RoleDGFormTransferCostcodeApprovalHR = "R095";
        public const string RoleDGTrfEvalHR = "R098";
        public const string RoleDGAnnulEvalHR = "R102";

        public const string ActionProgEvalUpdate = "A205";
        public const string ActionProgEvalView = "A210";

        public const string ActionProgEvalSendToHr = "A206";
        public const string ActionProgEvalPrint = "A207";
        public const string ActionProgEvalSendToHod = "A208";
        public const string ActionProgEvalHR = "A209";
        public const string ActionAnnualProgEvalActionHR = "A221";

        public const string ActionTransferTargetCostCodeHoD = "A247";
        public const string ActionTransferCostCodeHR = "A213";
        public const string ActionTransferCostCodeHRApproved = "A214";
        public const string ActionTransferCostCodeHRHoD = "A226";
        public const string ActionTransferCostCodeView = "A248";
    }
}