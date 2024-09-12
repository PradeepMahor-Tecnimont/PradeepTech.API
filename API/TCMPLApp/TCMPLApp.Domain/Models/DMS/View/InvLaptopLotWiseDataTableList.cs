using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvLaptopLotWiseDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

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


    public class InvLaptopLotwiseDataTableListExcel
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