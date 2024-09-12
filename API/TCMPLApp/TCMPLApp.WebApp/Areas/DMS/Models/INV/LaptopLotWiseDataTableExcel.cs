using System;

namespace TCMPLApp.WebApp.Models
{
    public class LaptopLotWiseDataTableExcel
    {
        public string LotId { get; set; }
        public string LotDesc { get; set; }
        public string AmsAssetId { get; set; }
        public decimal? SapAssetCode { get; set; }
        public string NbName { get; set; }
        public string NbSerialnum { get; set; }
        public string DsId { get; set; }
        public string DsSerialnum { get; set; }
        public DateTime? NbIssueDate { get; set; }
        public string Empno { get; set; }
        public string Name { get; set; }
        public string Parent { get; set; }
        public string Assign { get; set; }
        public string Grade { get; set; }
        public string Emptype { get; set; }
        public string Email { get; set; }
    }
}