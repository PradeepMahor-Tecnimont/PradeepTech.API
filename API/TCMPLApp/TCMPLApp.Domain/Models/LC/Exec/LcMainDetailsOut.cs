using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.LC
{
    public class LcMainDetailsOut : DBProcMessageOutput
    {
        public string PLcSerialNo { get; set; }
        public string PCompanyCode { get; set; }
        public string PCompanyFullName { get; set; }
        public string PCompanyShortName { get; set; }
        public string PPaymentYyyymm { get; set; }
        public string PPaymentYyyymmHalfVal { get; set; }
        public string PPaymentYyyymmHalfText { get; set; }
        public string PProjno { get; set; }
        public string PProject { get; set; }
        public string PVendor { get; set; }
        public string PVendorKeyId { get; set; }
        public string PCurrencyKeyId { get; set; }
        public string PCurrencyCode { get; set; }
        public string PCurrencyDesc { get; set; }
        public string PLcAmount { get; set; }
        public string PLcStatusVal { get; set; }
        public string PLcStatusText { get; set; }
        public string PModifiedOn { get; set; }
        public string PModifiedBy { get; set; }
        public string PLcClPaymentDate { get; set; }
        public string PLcClActualAmount { get; set; }
        public string PLcClOtherCharges { get; set; }
        public string PLcClModOn { get; set; }
        public string PLcClModBy { get; set; }
        public string PRemarks { get; set; }
        public string PLcClRemarks { get; set; }
        public string PSendToTreasury { get; set; }
    }
}