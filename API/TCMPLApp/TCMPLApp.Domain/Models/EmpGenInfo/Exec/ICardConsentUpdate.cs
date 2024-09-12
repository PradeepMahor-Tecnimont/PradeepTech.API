using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class ICardConsentUpdate : DBProcMessageOutput
    {
        public string Empno { get; set; }
        public string IsConsent { get; set; }
    }
}
